// src/parser.rs
// ScrapeC Parser: Parses tokens into an AST

use crate::lexer::Token;

#[derive(Debug)]
pub enum AstNode {
    Function { name: String, body: Vec<AstNode> },
    Let { name: String, value: i64 },
    Int(i64),
    Ident(String),
    // ... more node types as language grows
}

pub fn parse(tokens: &[Token]) -> Vec<AstNode> {
    // Minimal stub: recognizes 'fn main() { let x = 42; }'
    let mut ast = Vec::new();
    let mut i = 0;
    while i < tokens.len() {
        match &tokens[i] {
            Token::Fn => {
                if let Token::Ident(name) = &tokens[i+1] {
                    ast.push(AstNode::Function { name: name.clone(), body: vec![] });
                    i += 2;
                } else {
                    i += 1;
                }
            },
            Token::Let => {
                if let Token::Ident(name) = &tokens[i+1] {
                    if let Token::Assign = tokens[i+2] {
                        if let Token::Int(val) = tokens[i+3] {
                            ast.push(AstNode::Let { name: name.clone(), value: *val });
                            i += 4;
                        } else { i += 1; }
                    } else { i += 1; }
                } else { i += 1; }
            },
            _ => { i += 1; }
        }
    }
    ast
}
