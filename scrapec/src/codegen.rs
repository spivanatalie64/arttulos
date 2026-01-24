// src/codegen.rs
// ScrapeC Code Generation (Stub)

use crate::parser::AstNode;

pub fn generate_c(ast: &[AstNode]) -> String {
    let mut code = String::from("// Generated C code\n");
    for node in ast {
        match node {
            AstNode::Function { name, .. } => {
                code.push_str(&format!("void {}() {{}}\n", name));
            },
            AstNode::Let { name, value } => {
                code.push_str(&format!("int {} = {};\n", name, value));
            },
            _ => {}
        }
    }
    code
}
