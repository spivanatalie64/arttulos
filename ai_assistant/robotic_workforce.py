#!/usr/bin/env python3
import os
import json
import time
import logging

from github import Github
import openai

logging.basicConfig(level=logging.INFO)

COPILOT_TOKEN = os.getenv("COPILOT_TOKEN")
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
GITHUB_TOKEN = os.getenv("GITHUB_TOKEN")
GITHUB_REPOSITORY = os.getenv("GITHUB_REPOSITORY")

API_KEY = COPILOT_TOKEN or OPENAI_API_KEY
if not API_KEY:
    logging.error("COPILOT_TOKEN or OPENAI_API_KEY not set; exiting.")
    raise SystemExit(1)

if not GITHUB_TOKEN or not GITHUB_REPOSITORY:
    logging.error("GITHUB_TOKEN or GITHUB_REPOSITORY not set; exiting.")
    raise SystemExit(1)

openai.api_key = API_KEY
gh = Github(GITHUB_TOKEN)
repo = gh.get_repo(GITHUB_REPOSITORY)

AGENTS = [
    {"name": "triager", "system": "You are a triage agent: classify issues, suggest labels, and a short comment."},
    {"name": "developer", "system": "You are a developer agent: propose actionable fixes or feature implementations."},
    {"name": "reviewer", "system": "You are a reviewer agent: evaluate proposed actions and suggest improvements."},
]

def ask_agent(agent, issue):
    prompt = f"""Issue title: {issue.title}
Issue body: {issue.body or "<no body>"}

Respond ONLY with a JSON object with keys:
  - labels: list of label strings (may be empty)
  - comment: short suggestion/comment string (may be empty)
  - create_issue: null or an object with keys "title" and "body"

Example:
{"labels": ["bug"], "comment": "This looks like ...", "create_issue": null}

Keep responses concise.
"""
    messages = [
        {"role": "system", "content": agent["system"]},
        {"role": "user", "content": prompt},
    ]
    try:
        resp = openai.ChatCompletion.create(
            model="gpt-5-mini",
            messages=messages,
            max_tokens=500,
            temperature=0.2,
        )
        return resp["choices"][0]["message"]["content"]
    except Exception as e:
        logging.exception("OpenAI request failed")
        return None


def parse_json(text):
    if not text:
        return None
    try:
        return json.loads(text)
    except Exception:
        # try to extract first JSON object
        start = text.find("{")
        end = text.rfind("}")
        if start != -1 and end != -1:
            try:
                return json.loads(text[start:end+1])
            except Exception:
                return None
        return None


def consensus_and_act(issue, outputs):
    label_counts = {}
    comments = []
    create_suggestions = []

    for out in outputs:
        parsed = parse_json(out)
        if not parsed:
            continue
        for l in parsed.get("labels") or []:
            label_counts[l] = label_counts.get(l, 0) + 1
        c = parsed.get("comment")
        if c:
            comments.append(c)
        ci = parsed.get("create_issue")
        if ci:
            create_suggestions.append(ci)

    # Add labels with majority (>=2)
    labels_to_add = [lbl for lbl, cnt in label_counts.items() if cnt >= 2]
    if labels_to_add:
        try:
            issue.add_to_labels(*labels_to_add)
            logging.info(f"Added labels {labels_to_add} to issue #{issue.number}")
        except Exception:
            logging.exception("Failed to add labels")

    # Post a summary comment
    summary_parts = []
    if label_counts:
        summary_parts.append("Label votes:\n" + "\n".join(f"- {k}: {v}" for k,v in label_counts.items()))
    if comments:
        summary_parts.append("Agent comments:\n" + "\n\n".join(f"- {c}" for c in comments))
    if create_suggestions:
        summary_parts.append("Proposed new issues:\n" + "\n".join(f"- {ci.get('title')}" for ci in create_suggestions))

    if summary_parts:
        body = "Robotic workforce summary:\n\n" + "\n\n".join(summary_parts)
        try:
            issue.create_comment(body)
            logging.info(f"Created comment on issue #{issue.number}")
        except Exception:
            logging.exception("Failed to create comment")

    # Create new issues for any proposals (naive: create all)
    for ci in create_suggestions:
        try:
            repo.create_issue(title=ci.get("title", "Suggested issue"), body=ci.get("body", ""))
            logging.info("Created suggested issue: %s", ci.get("title"))
        except Exception:
            logging.exception("Failed to create suggested issue")


def main():
    issues = repo.get_issues(state="open")
    for idx, issue in enumerate(issues):
        if idx >= 10:
            break
        logging.info("Processing issue #%s: %s", issue.number, issue.title)
        outputs = []
        for agent in AGENTS:
            out = ask_agent(agent, issue)
            outputs.append(out)
            time.sleep(1)
        consensus_and_act(issue, outputs)

if __name__ == "__main__":
    main()
