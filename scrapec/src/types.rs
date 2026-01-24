// src/types.rs
// ScrapeC Type System (Stub)

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum Type {
    Int,
    Float,
    Bool,
    Char,
    Str,
    Unit,
    Custom(String),
    Ref(Box<Type>),
    MutRef(Box<Type>),
    Option(Box<Type>),
    Result(Box<Type>, Box<Type>),
    // ... more types as language grows
}

pub fn infer_type(_ast: &crate::parser::AstNode) -> Type {
    // Minimal stub: always returns Int
    Type::Int
}
