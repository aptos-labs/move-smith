// Copyright (c) Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

use crate::{move_ast::*, states::ids::Id};

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
        vec![]
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
