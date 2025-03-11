// Copyright (c) Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

use crate::{
    move_ast::*,
    states::{
        ids::{Id, Named},
        types::{Type, Typed},
        Ability, GenericType, NumberType, Primitive,
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
        lines_to_inline(self.emit_code_lines())
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

fn lines_to_inline(lines: Vec<String>) -> String {
    lines
        .iter()
        .map(|line| line.trim())
        .collect::<Vec<&str>>()
        .join(" ")
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

        for e in &self.enums {
            append_code_lines_with_indentation(&mut code, e.emit_code_lines(), INDENTATION_SIZE);
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
        let abilities = if self.abilities.is_empty() {
            "".to_string()
        } else {
            format!(
                " has {} ",
                self.abilities
                    .iter()
                    .map(|a| a.emit_code())
                    .collect::<Vec<String>>()
                    .join(", ")
            )
        };
        let mut code = vec![format!("struct {}{}{{", self.name, abilities)];
        let fields = self
            .fields
            .iter()
            .map(|f| format!("{},", f.emit_code()))
            .collect::<Vec<String>>();
        append_code_lines_with_indentation(&mut code, fields, INDENTATION_SIZE);
        code.push("}".to_string());
        code
    }
}

impl CodeGenerator for StructInstantiation {
    fn emit_code_lines(&self) -> Vec<String> {
        let mut code = vec![format!("{} {{", self.struct_type.name())];
        let mut fields = vec![];
        for (var, expr) in &self.fields {
            fields.push(format!("{}:", var.name()));

            let expr_liens = expr.emit_code_lines();
            if expr_liens.len() == 1 {
                fields.last_mut().unwrap().push(' ');
                fields.last_mut().unwrap().push_str(&expr_liens[0]);
            } else {
                append_block(&mut fields, expr_liens, INDENTATION_SIZE);
            }
            fields.last_mut().unwrap().push(',');
        }
        append_code_lines_with_indentation(&mut code, fields, INDENTATION_SIZE);
        code.push("}".to_string());
        code
    }
}

impl CodeGenerator for StructDestructure {
    fn emit_code_lines(&self) -> Vec<String> {
        let fields = if let Type::Generic(GenericType::Struct(struct_type)) =
            self.struct_type.typ.as_ref()
        {
            struct_type
                .fields
                .iter()
                .map(|(id, _)| id.emit_code())
                .collect::<Vec<String>>()
        } else {
            panic!(
                "StructDestructure: {:?} is not a struct",
                self.struct_type.typ
            );
        };
        let mut pairs = vec![];
        for (new_var, field) in self.new_vars.iter().zip(fields) {
            // TODO: 2.0 three dots style
            if let Some(new_var) = new_var {
                pairs.push(format!("{}: {}", field, new_var.name));
            }
        }
        vec![format!(
            "{} {{ {} }}",
            self.struct_type.name(),
            pairs.join(", ")
        )]
    }
}

impl CodeGenerator for Enum {
    fn emit_code_lines(&self) -> Vec<String> {
        let abilities = if self.abilities.is_empty() {
            "".to_string()
        } else {
            format!(
                " has {} ",
                self.abilities
                    .iter()
                    .map(|a| a.emit_code())
                    .collect::<Vec<String>>()
                    .join(", ")
            )
        };
        let mut code = vec![format!("enum {}{}{{", self.name, abilities)];
        let variants = self
            .variants
            .iter()
            .flat_map(|v| {
                let mut lines = v.emit_code_lines();
                lines.last_mut().unwrap().push(',');
                lines
            })
            .collect::<Vec<String>>();
        append_code_lines_with_indentation(&mut code, variants, INDENTATION_SIZE);
        code.push("}".to_string());
        code
    }
}

impl CodeGenerator for EnumVariant {
    fn emit_code_lines(&self) -> Vec<String> {
        let mut code = vec![];

        if self.positional {
            let mut line = format!("{}(", self.name);
            let fields = self
                .fields
                .iter()
                .map(|f| f.typ.inline())
                .collect::<Vec<String>>();
            line.push_str(&fields.join(", "));
            line.push(')');
            code.push(line);
        } else {
            code.push(self.name.inline());
            let mut body = vec!["{".to_string()];
            let fields = self
                .fields
                .iter()
                .map(|f| format!("{},", f.emit_code()))
                .collect::<Vec<String>>();
            append_code_lines_with_indentation(&mut body, fields, 0);
            body.push("}".to_string());
            append_block(&mut code, body, INDENTATION_SIZE);
        };
        code
    }
}

impl CodeGenerator for EnumInstantiation {
    fn emit_code_lines(&self) -> Vec<String> {
        let variant_type = self.get_variant_type();
        let open_brace = if variant_type.positional { '(' } else { '{' };
        let close_brace = if variant_type.positional { ')' } else { '}' };
        let mut code = vec![format!(
            "{}::{} {}",
            self.enum_type.name(),
            variant_type.name(),
            open_brace
        )];

        let mut field_lines = vec![];
        for (var, expr) in &self.fields {
            let expr_lines = expr.emit_code_lines();
            if variant_type.positional {
                field_lines.extend(expr_lines);
            } else {
                field_lines.push(format!("{}:", var.name()));
                append_block(&mut field_lines, expr_lines, INDENTATION_SIZE);
            }
            field_lines.last_mut().unwrap().push(',');
        }

        if field_lines.len() < variant_type.fields.len() {
            // Inline generation
            code.last_mut()
                .unwrap()
                .push_str(&lines_to_inline(field_lines));
            code.last_mut().unwrap().push(close_brace);
        } else {
            append_code_lines_with_indentation(&mut code, field_lines, INDENTATION_SIZE);
            code.push(close_brace.to_string());
        }
        code
    }
}

impl CodeGenerator for Ability {
    fn emit_code_lines(&self) -> Vec<String> {
        use Ability as A;
        vec![match self {
            A::Copy => "copy".to_string(),
            A::Drop => "drop".to_string(),
            A::Store => "store".to_string(),
            A::Key => "key".to_string(),
        }]
    }
}

impl CodeGenerator for Function {
    fn emit_code_lines(&self) -> Vec<String> {
        let mut code = vec![format!("{}", self.signature.emit_code())];
        append_block(&mut code, self.body.emit_code_lines(), 0);
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
            Statement::LetAssign(e) => {
                let mut code = vec!["let".to_string()];
                append_block(&mut code, e.emit_code_lines(), 0);
                code
            },
            Statement::LetDeclare(vs) => {
                let mut code = "let ".to_string();
                if vs.len() == 1 {
                    code.push_str(&vs[0].inline());
                } else {
                    let names = vs
                        .iter()
                        .map(|v| v.name().inline())
                        .collect::<Vec<String>>();
                    let types = vs.iter().map(|v| v.ty().inline()).collect::<Vec<String>>();
                    code.push('(');
                    code.push_str(&names.join(", "));
                    code.push_str("): (");
                    code.push_str(&types.join(", "));
                    code.push(')');
                }
                vec![code]
            },
            Statement::Expression(e) => e.emit_code_lines(),
        };
        if !code_lines.is_empty() {
            code_lines.last_mut().unwrap().push(';');
        }
        code_lines
    }
}

impl CodeGenerator for Expression {
    fn emit_code_lines(&self) -> Vec<String> {
        use Expression as E;
        match self {
            E::StructInstantiation(s) => s.emit_code_lines(),
            E::StructDestructure(s) => s.emit_code_lines(),
            E::EnumInstantiation(e) => e.emit_code_lines(),
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
        let mut elem_lines = vec![];
        for expr in &self.expressions {
            elem_lines.push(expr.emit_code_lines());
        }

        let mut code = vec!['('.to_string()];

        let total_lines = elem_lines.iter().map(|l| l.len()).sum::<usize>();
        if total_lines <= self.expressions.len() + 2 {
            // Inline generation
            let elems_inline = elem_lines
                .into_iter()
                .map(lines_to_inline)
                .collect::<Vec<String>>();
            code.last_mut().unwrap().push_str(&elems_inline.join(", "));
            code.last_mut().unwrap().push(')');
        } else {
            for lines in elem_lines {
                append_code_lines_with_indentation(&mut code, lines, INDENTATION_SIZE);
                code.last_mut().unwrap().push(',');
            }
            code.push(')'.to_string());
        }

        if self.show_type {
            code.last_mut()
                .unwrap()
                .push_str(&format!(": {}", self.ty().emit_code()));
        }
        code
    }
}

impl CodeGenerator for Assignment {
    fn emit_code_lines(&self) -> Vec<String> {
        let mut code = vec![format!("{} =", self.lhs.emit_code(),)];
        append_block(&mut code, self.rhs.emit_code_lines(), 0);
        code
    }
}

impl CodeGenerator for Variable {
    fn emit_code_lines(&self) -> Vec<String> {
        match self {
            Variable::SingleVariable(v) => v.emit_code_lines(),
            Variable::DotVariable(v) => v.emit_code_lines(),
        }
    }
}

impl CodeGenerator for SingleVariable {
    fn emit_code_lines(&self) -> Vec<String> {
        let mut code = format!("{}", self.name);
        if self.show_type {
            code.push_str(": ");
            code.push_str(&self.typ.emit_code());
        }
        vec![code]
    }
}

impl CodeGenerator for DotVariable {
    fn emit_code_lines(&self) -> Vec<String> {
        let ids = self
            .vars
            .iter()
            .map(|(id, _)| id.emit_code())
            .collect::<Vec<String>>();
        vec![ids.join(".")]
    }
}

impl CodeGenerator for NumberLiteral {
    fn emit_code_lines(&self) -> Vec<String> {
        vec![format!("{}{}", self.value, self.typ.emit_code())]
    }
}

impl CodeGenerator for FunctionCall {
    fn emit_code_lines(&self) -> Vec<String> {
        let mut code = vec![format!("{}(", self.name())];

        let mut arg_lines = vec![];
        for arg in &self.arguments {
            arg_lines.push(arg.emit_code_lines());
        }
        let total_lines = arg_lines.iter().map(|l| l.len()).sum::<usize>();
        if total_lines <= self.arguments.len() + 2 {
            // Inline generation
            let args_inline = arg_lines
                .into_iter()
                .map(lines_to_inline)
                .collect::<Vec<String>>();
            code.last_mut().unwrap().push_str(&args_inline.join(", "));
            code.last_mut().unwrap().push(')');
        } else {
            for lines in arg_lines {
                append_code_lines_with_indentation(&mut code, lines, INDENTATION_SIZE);
                code.last_mut().unwrap().push(',');
            }
            code.push(')'.to_string());
        }
        code
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
            G::Enum(e) => e.name.name.clone(),
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
