// src/types.rs
// ScrapeC Type System (Type Checking and Inference Engine)

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
}

use crate::parser::AstNode;
use std::collections::HashMap;

pub struct TypeEnv {
    vars: HashMap<String, Type>,
}

impl TypeEnv {
    pub fn new() -> Self {
        TypeEnv { vars: HashMap::new() }
    }
    pub fn insert(&mut self, name: String, ty: Type) {
        self.vars.insert(name, ty);
    }
    pub fn get(&self, name: &str) -> Option<&Type> {
        self.vars.get(name)
    }
}

pub fn infer_type(ast: &AstNode, env: &mut TypeEnv) -> Type {
    match ast {
        AstNode::Let { name, value } => {
            let ty = Type::Int; // Only int supported in stub
            env.insert(name.clone(), ty.clone());
            ty
        },
        AstNode::Int(_) => Type::Int,
        AstNode::Ident(name) => env.get(name).cloned().unwrap_or(Type::Unit),
        AstNode::Function { .. } => Type::Unit,
        _ => Type::Unit,
    }
}
