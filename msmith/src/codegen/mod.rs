// Copyright (c) Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

use crate::{
    move_ast::*,
    states::{
        ids::Id,
        types::{Type, Typed},
        GenericType, NumberType, Primitive,
    },
};

/// The code put before each generated Move source code.
static PROLOGUE: &str = include_str!("prologue.move");
/// The code put after each generated Move source code.
static EPILOGUE: &str = include_str!("epilogue.move");

/// The number of spaces to use for indentation.
const INDENTATION_SIZE: usize = 4;

/// Generates Move source code from an AST.
/// `emit_code_lines` should be implemented for each AST node.
/// `emit_code_lines` should return a vector of strings, where each string is a single line of code.
pub trait CodeGenerator {
    /// Generate Move source code.
    fn emit_code(&self) -> String {
        self.emit_code_lines().join("\n")
    }

    /// Concatenate the code lines with newlines and return one single string.
    fn inline(&self) -> String {
        // Trim the leading whitespaces added for indentation
        // and then join them with a space.
        self.emit_code_lines()
            .iter()
            .map(|line| line.trim())
            .collect::<Vec<&str>>()
            .join(" ")
    }

    /// Each AST node should implement this
    /// Each element should be a line of code.
    /// The string should not contain any newlines.
    fn emit_code_lines(&self) -> Vec<String>;
}

/// Helper function add indentation to each line of code.
fn append_code_lines_with_indentation(
    program: &mut Vec<String>,
    lines: Vec<String>,
    indentation: usize,
) {
    for line in lines {
        program.push(format!("{:indent$}{}", "", line, indent = indentation));
    }
}

/// Append a block: concatenate the first line in block with the last line of the existing code
/// For the rest of block, append them with the given indentation.
fn append_block(program: &mut Vec<String>, mut block: Vec<String>, indentation: usize) {
    if program.is_empty() || block.is_empty() {
        return;
    }

    let suffix = format!(" {}", block.remove(0));
    program.last_mut().unwrap().push_str(&suffix);
    if block.is_empty() {
        return;
    }
    let last_line = block.remove(block.len() - 1);
    append_code_lines_with_indentation(program, block, indentation);
    program.push(last_line);
}

impl CodeGenerator for MoveAST {
    fn emit_code_lines(&self) -> Vec<String> {
        match self {
            MoveAST::Program(p) => p.emit_code_lines(),
            _ => unimplemented!(),
        }
    }
}

impl CodeGenerator for Id {
    fn emit_code_lines(&self) -> Vec<String> {
        vec![self.name.clone()]
    }
}

impl CodeGenerator for Program {
    fn emit_code_lines(&self) -> Vec<String> {
        let mut code = vec![PROLOGUE.to_string()];
        for m in &self.modules {
            code.extend(m.emit_code_lines());
        }
        code.push(EPILOGUE.to_string());
        code
    }
}

impl CodeGenerator for MoveModule {
    fn emit_code_lines(&self) -> Vec<String> {
        // The `//# publish` is for the transactional test
        let mut code = vec![
            "//# publish".to_string(),
            format!(
                "module {}::{} {{",
                self.address.emit_code(),
                self.name.emit_code()
            ),
        ];

        for s in &self.structs {
            append_code_lines_with_indentation(&mut code, s.emit_code_lines(), INDENTATION_SIZE);
        }

        for f in &self.functions {
            append_code_lines_with_indentation(&mut code, f.emit_code_lines(), INDENTATION_SIZE);
        }

        code.push("}\n".to_string());
        code
    }
}

impl CodeGenerator for Address {
    fn emit_code_lines(&self) -> Vec<String> {
        vec![self.name.clone().unwrap()]
    }
}

impl CodeGenerator for Struct {
    fn emit_code_lines(&self) -> Vec<String> {
        let mut code = vec![format!("struct {} {{", self.name)];
        code.push("}".to_string());
        code
    }
}

impl CodeGenerator for Function {
    fn emit_code_lines(&self) -> Vec<String> {
        let mut code = vec![self.signature.emit_code()];
        append_block(&mut code, self.body.emit_code_lines(), INDENTATION_SIZE);
        code
    }
}

impl CodeGenerator for Signature {
    fn emit_code_lines(&self) -> Vec<String> {
        let mut code = format!("fun {}", self.name);

        let params = self
            .parameters
            .iter()
            .map(|p| p.emit_code())
            .collect::<Vec<String>>();
        code.push_str(&format!("({})", params.join(", ")));

        if self.has_return() {
            code.push_str(": ");
            code.push_str(&self.return_type.emit_code());
        }
        vec![code]
    }
}

impl CodeGenerator for Block {
    fn emit_code_lines(&self) -> Vec<String> {
        let mut body_lines = vec![];
        for s in &self.sequences {
            body_lines.extend(s.emit_code_lines());
        }

        if let Some(expr) = &self.return_expr {
            body_lines.extend(expr.emit_code_lines());
        }

        let mut code = vec![format!("{{ /* {} */", self.name.inline())];
        append_code_lines_with_indentation(&mut code, body_lines, INDENTATION_SIZE);
        code.push("}".to_string());
        code
    }
}

impl CodeGenerator for Sequence {
    fn emit_code_lines(&self) -> Vec<String> {
        if self.statements.is_empty() {
            return vec![];
        }
        let mut body = vec![];
        for s in &self.statements {
            body.extend(s.emit_code_lines());
        }
        body
    }
}

impl CodeGenerator for Statement {
    fn emit_code_lines(&self) -> Vec<String> {
        let mut code_lines = match self {
            Statement::Let(e) => vec![format!("let {}", e.emit_code())],
            Statement::Expression(e) => e.emit_code_lines(),
        };
        if !code_lines.is_empty() {
            code_lines.last_mut().unwrap().push_str(";");
        }
        return code_lines;
    }
}

impl CodeGenerator for Expression {
    fn emit_code_lines(&self) -> Vec<String> {
        use Expression as E;
        match self {
            E::Assignment(a) => a.emit_code_lines(),
            E::Variable(v) => v.emit_code_lines(),
            E::NumberLiteral(n) => n.emit_code_lines(),
            E::Tuple(t) => t.emit_code_lines(),
            E::FunctionCall(f) => f.emit_code_lines(),
        }
    }
}

impl CodeGenerator for Tuple {
    fn emit_code_lines(&self) -> Vec<String> {
        let mut elems = vec![];
        for expr in &self.expressions {
            elems.push(expr.emit_code());
        }
        let mut code = format!("({})", elems.join(", "));
        if self.show_type {
            code.push_str(": ");
            code.push_str(&self.ty().emit_code());
        }
        vec![code]
    }
}

impl CodeGenerator for Assignment {
    fn emit_code_lines(&self) -> Vec<String> {
        vec![format!(
            "{} = {}",
            self.lhs.emit_code(),
            self.rhs.emit_code()
        )]
    }
}

impl CodeGenerator for Variable {
    fn emit_code_lines(&self) -> Vec<String> {
        let mut code = format!("{}", self.name);
        if self.show_type {
            code.push_str(": ");
            code.push_str(&self.typ.emit_code());
        }
        vec![code]
    }
}

impl CodeGenerator for NumberLiteral {
    fn emit_code_lines(&self) -> Vec<String> {
        vec![format!("{}{}", self.value, self.typ.emit_code())]
    }
}

impl CodeGenerator for FunctionCall {
    fn emit_code_lines(&self) -> Vec<String> {
        let mut args = vec![];
        for arg in &self.arguments {
            args.push(arg.emit_code());
        }
        vec![format!("{}({})", self.func_type.name, args.join(", "))]
    }
}

impl CodeGenerator for Type {
    fn emit_code_lines(&self) -> Vec<String> {
        use Type as T;
        vec![match self {
            T::Generic(g) => g.emit_code(),
            T::Primitive(p) => p.emit_code(),
            _ => unimplemented!(),
        }]
    }
}

impl CodeGenerator for GenericType {
    fn emit_code_lines(&self) -> Vec<String> {
        use GenericType as G;
        vec![match self {
            G::Struct(st) => st.name.name.clone(),
            G::Tuple(t) => {
                let mut code = vec![];
                for ty in &t.types {
                    code.push(ty.emit_code());
                }
                format!("({})", code.join(", "))
            },
            _ => unimplemented!(),
        }]
    }
}

impl CodeGenerator for Primitive {
    fn emit_code_lines(&self) -> Vec<String> {
        use Primitive as P;
        vec![match self {
            P::Address => "address".to_string(),
            P::Bool => "bool".to_string(),
            P::Number(n) => n.emit_code(),
        }]
    }
}

impl CodeGenerator for NumberType {
    fn emit_code_lines(&self) -> Vec<String> {
        use NumberType as N;
        vec![match self {
            N::U8 => "u8".to_string(),
            N::U16 => "u16".to_string(),
            N::U32 => "u32".to_string(),
            N::U64 => "u64".to_string(),
            N::U128 => "u128".to_string(),
            N::U256 => "u256".to_string(),
        }]
    }
}

#[cfg(test)]
mod ast_tests {
    use super::*;

    #[test]
    fn test_codegen() {
        let program = Program::default();
        println!("{}", program.emit_code());
    }
}
