// src/lexer.rs
// ScrapeC Lexer: Tokenizes ScrapeC source code

#[derive(Debug, PartialEq, Eq)]
pub enum Token {
    Fn,
    Let,
    Ident(String),
    Int(i64),
    Plus,
    Minus,
    Star,
    Slash,
    LParen,
    RParen,
    LBrace,
    RBrace,
    Semicolon,
    Comma,
    Assign,
    Print,
    Eof,
    Unknown(char),
}

pub fn lex(input: &str) -> Vec<Token> {
    // Minimal stub: recognizes 'fn', 'let', identifiers, and numbers
    let mut tokens = Vec::new();
    let mut chars = input.chars().peekable();
    while let Some(&c) = chars.peek() {
        match c {
            ' ' | '\n' | '\t' => { chars.next(); },
            'f' => {
                let lookahead: String = chars.clone().take(2).collect();
                if lookahead == "fn" {
                    tokens.push(Token::Fn);
                    chars.next(); chars.next();
                } else {
                    tokens.push(Token::Unknown(c));
                    chars.next();
                }
            },
            'l' => {
                let lookahead: String = chars.clone().take(3).collect();
                if lookahead == "let" {
                    tokens.push(Token::Let);
                    chars.next(); chars.next(); chars.next();
                } else {
                    tokens.push(Token::Unknown(c));
                    chars.next();
                }
            },
            '0'..='9' => {
                let mut num = 0i64;
                while let Some(d) = chars.peek().and_then(|c| c.to_digit(10)) {
                    num = num * 10 + d as i64;
                    chars.next();
                }
                tokens.push(Token::Int(num));
            },
            '+' => { tokens.push(Token::Plus); chars.next(); },
            '-' => { tokens.push(Token::Minus); chars.next(); },
            '*' => { tokens.push(Token::Star); chars.next(); },
            '/' => { tokens.push(Token::Slash); chars.next(); },
            '(' => { tokens.push(Token::LParen); chars.next(); },
            ')' => { tokens.push(Token::RParen); chars.next(); },
            '{' => { tokens.push(Token::LBrace); chars.next(); },
            '}' => { tokens.push(Token::RBrace); chars.next(); },
            ';' => { tokens.push(Token::Semicolon); chars.next(); },
            ',' => { tokens.push(Token::Comma); chars.next(); },
            '=' => { tokens.push(Token::Assign); chars.next(); },
            _ => {
                if c.is_alphabetic() {
                    let mut ident = String::new();
                    while let Some(&ch) = chars.peek() {
                        if ch.is_alphanumeric() || ch == '_' {
                            ident.push(ch);
                            chars.next();
                        } else {
                            break;
                        }
                    }
                    tokens.push(Token::Ident(ident));
                } else {
                    tokens.push(Token::Unknown(c));
                    chars.next();
                }
            }
        }
    }
    tokens.push(Token::Eof);
    tokens
}
