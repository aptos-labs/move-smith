// Copyright (c) Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

use crate::{
    move_ast::*,
    states::{
        ids::{Id, Named, Scope, ROOT_SCOPE},
        types::{Type, Typed},
        Ability, FunctionType, GenericType, NumberType, Primitive, ReferenceType,
    },
};
use num_bigint::BigInt;
use num_traits::cast::ToPrimitive;
use std::cell::RefCell;

/// The code put before each generated Move source code.
static PROLOGUE: &str = include_str!("prologue.move");
/// The code put after each generated Move source code.
static EPILOGUE: &str = include_str!("epilogue.move");

/// The number of spaces to use for indentation.
const NO_INDENTATION: usize = 0;
const INDENTATION_SIZE: usize = 4;
const LINE_WRAP_LIMIT: usize = 120;

thread_local! {
    static CURRENT_MODULE: RefCell<Scope> = RefCell::new(ROOT_SCOPE.clone());
    static IGNORE_MODULE: RefCell<bool> = RefCell::new(false);
}

fn set_ignore_module(ignore: bool) {
    IGNORE_MODULE.with(|flag| {
        *flag.borrow_mut() = ignore;
    });
}

fn is_cross_module(name: &Id) -> bool {
    IGNORE_MODULE.with(|ignore_flag| {
        if *ignore_flag.borrow() {
            return false;
        }

        CURRENT_MODULE.with(|current_scope| {
            !current_scope
                .borrow()
                .is_from_same_module(&name.get_self_scope())
        })
    })
}

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
    if block.is_empty() {
        return;
    }

    if program.is_empty() {
        program.extend(block);
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

/// For the given lines, if concatenating them will not exceed the wrap limit, they will be inlined into one line.
/// Otherwise, they are treated as separate lines.
///
/// If `concat_first_line` is true, the function will behave the same as `append_block`, else the same as `append_code_lines_with_indentation`.
///
/// If lines are inlined and concatenated, the indentation will be ignored. One space wil be used.
fn adaptive_append_inline(
    program: &mut Vec<String>,
    lines: Vec<String>,
    indentation: usize,
    wrap_limit: usize,
    concat_first_line: bool,
) {
    let lines_length = lines.iter().map(|line| line.len()).sum::<usize>();
    let existing_length = match concat_first_line {
        true => program.last().map_or(0, |line| line.trim().len()),
        false => 0,
    } + 1;
    let total_length = existing_length + lines_length;

    let lines = match total_length <= wrap_limit {
        true => {
            vec![lines_to_inline(lines)]
        },
        false => lines,
    };
    if concat_first_line {
        append_block(program, lines, indentation);
    } else {
        append_code_lines_with_indentation(program, lines, indentation);
    }
}

fn lines_to_inline(lines: Vec<String>) -> String {
    if lines.is_empty() {
        return String::new();
    }
    if lines.len() == 1 {
        return lines.into_iter().next().unwrap();
    }
    let mut oneliner = String::new();
    for i in 0..lines.len() {
        let trimmed = lines.get(i).unwrap().trim();
        if trimmed.starts_with('}') || trimmed.starts_with(')') || trimmed == "," {
            while oneliner.ends_with(' ') {
                oneliner.pop(); // Remove the trailing space before closing brace or comma
            }
        }

        oneliner.push_str(trimmed);
        if trimmed.ends_with('{') || trimmed.ends_with('(') {
            continue;
        }
        if i != lines.len() - 1 {
            oneliner.push(' ');
        }
    }
    oneliner
}

fn put_inside_pair_of(
    left: &str,
    right: &str,
    mut lines: Vec<String>,
    indentation: usize,
) -> Vec<String> {
    let mut wrapped = vec![left.to_string()];
    lines.push(right.to_string());
    adaptive_append_inline(&mut wrapped, lines, indentation, LINE_WRAP_LIMIT, true);
    wrapped
}

fn add_comma_for_lines(lines: &mut [String], ignore_last_line: bool) {
    let len = lines.len();
    lines.iter_mut().enumerate().for_each(|(i, line)| {
        if line.trim().is_empty() {
            return;
        }
        if i == len - 1 && ignore_last_line {
            return;
        }
        line.push(',');
    });
}

fn add_comma_for_blocks(blocks: &mut [Vec<String>], ignore_last_block: bool) {
    let len = blocks.len();
    for (i, block) in blocks.iter_mut().enumerate() {
        if block.is_empty() {
            continue;
        }
        if i == len - 1 && ignore_last_block {
            continue;
        }
        block.last_mut().unwrap().push(',');
    }
}

impl CodeGenerator for MoveAST {
    fn emit_code_lines(&self) -> Vec<String> {
        match self {
            MoveAST::Program(p) => p.emit_code_lines(),
            MoveAST::Block(b) => b.emit_code_lines(),
            MoveAST::Expression(e) => e.emit_code_lines(),
            _ => unimplemented!(),
        }
    }
}

impl CodeGenerator for Id {
    fn emit_code_lines(&self) -> Vec<String> {
        if is_cross_module(self) {
            vec![self.full_name()]
        } else {
            vec![self.name.clone()]
        }
    }
}

impl CodeGenerator for Program {
    fn emit_code_lines(&self) -> Vec<String> {
        let mut code = vec![PROLOGUE.to_string()];
        for m in &self.modules {
            code.extend(m.emit_code_lines());
        }

        for s in &self.scripts {
            code.extend(s.emit_code_lines());
        }

        code.push(EPILOGUE.to_string());
        code
    }
}

impl CodeGenerator for MoveModule {
    fn emit_code_lines(&self) -> Vec<String> {
        CURRENT_MODULE.with(|current| {
            *current.borrow_mut() = self.name.get_self_scope();
        });

        // The `//# publish` is for the transactional test
        let mut code = vec![
            "//# publish".to_string(),
            format!(
                "module {}::{} {{",
                self.address.emit_code(),
                self.name.emit_code()
            ),
        ];
        for u in &self.uses {
            append_code_lines_with_indentation(&mut code, u.emit_code_lines(), INDENTATION_SIZE);
        }

        for s in &self.structs {
            append_code_lines_with_indentation(&mut code, s.emit_code_lines(), INDENTATION_SIZE);
        }

        for e in &self.enums {
            append_code_lines_with_indentation(&mut code, e.emit_code_lines(), INDENTATION_SIZE);
        }

        for f in &self.functions {
            append_code_lines_with_indentation(&mut code, f.emit_code_lines(), INDENTATION_SIZE);
        }

        for spec in &self.function_specs {
            append_code_lines_with_indentation(&mut code, spec.emit_code_lines(), INDENTATION_SIZE);
        }

        code.push("}\n".to_string());

        for c in &self.cmds {
            append_code_lines_with_indentation(&mut code, c.emit_code_lines(), NO_INDENTATION);
            code.push('\n'.to_string());
        }

        code
    }
}

impl CodeGenerator for Script {
    fn emit_code_lines(&self) -> Vec<String> {
        CURRENT_MODULE.with(|current| {
            *current.borrow_mut() = Scope(Some("NOT_A_MODULE_SCOPE".to_string()));
        });
        let mut code = vec!["//# run".to_string(), "script {".to_string()];
        let func_lines = self.main.emit_code_lines();
        append_code_lines_with_indentation(&mut code, func_lines, INDENTATION_SIZE);
        code.push("}\n".to_string());
        code
    }
}

impl CodeGenerator for Address {
    fn emit_code_lines(&self) -> Vec<String> {
        vec![self.0.clone()]
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
        if self.positional {
            let types = self
                .fields
                .iter()
                .map(|f| f.typ.inline())
                .collect::<Vec<String>>()
                .join(", ");
            vec![format!("struct {}({}){};", self.name, types, abilities)]
        } else {
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
}

impl CodeGenerator for StructInstantiation {
    fn emit_code_lines(&self) -> Vec<String> {
        let ty = self.ty();
        let struct_type = ty.as_struct().unwrap();

        let mut code = if struct_type.positional {
            vec![format!("{} (", self.struct_type.name())]
        } else {
            vec![format!("{} {{", self.struct_type.name())]
        };
        let mut fields = vec![];
        for (var, expr) in &self.fields {
            if !struct_type.positional {
                fields.push(format!("{}: ", var.name()));
            }
            if fields.is_empty() {
                fields.push("".to_string());
            }

            let expr_liens = expr.emit_code_lines();
            if expr_liens.len() == 1 {
                fields.last_mut().unwrap().push_str(&expr_liens[0]);
            } else {
                append_block(&mut fields, expr_liens, INDENTATION_SIZE);
            }
            fields.last_mut().unwrap().push(',');
        }
        append_code_lines_with_indentation(&mut code, fields, INDENTATION_SIZE);
        if struct_type.positional {
            code.push(')'.to_string());
        } else {
            code.push('}'.to_string());
        }
        code
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
        let mut code = vec![self.enum_type.name().inline()];

        let mut field_blocks = vec![];
        for (var, expr) in &self.fields {
            let expr_lines = expr.emit_code_lines();
            if variant_type.positional {
                field_blocks.push(expr_lines);
            } else {
                let mut block = vec![format!("{}:", var.name())];
                append_block(&mut block, expr_lines, INDENTATION_SIZE);
                field_blocks.push(block);
            }
        }
        add_comma_for_blocks(&mut field_blocks, true);
        let field_lines = field_blocks.into_iter().flatten().collect();
        let field_lines = if variant_type.positional {
            put_inside_pair_of("(", ")", field_lines, INDENTATION_SIZE)
        } else {
            put_inside_pair_of("{", "}", field_lines, INDENTATION_SIZE)
        };
        adaptive_append_inline(
            &mut code,
            field_lines,
            NO_INDENTATION,
            LINE_WRAP_LIMIT,
            true,
        );
        code
    }
}

impl CodeGenerator for EnumMatch {
    fn emit_code_lines(&self) -> Vec<String> {
        let mut code = vec!["match".to_string()];
        let expr_lines = self.expr.emit_code_lines();
        let expr_lines = put_inside_pair_of("(", ")", expr_lines, NO_INDENTATION);
        adaptive_append_inline(
            &mut code,
            expr_lines,
            INDENTATION_SIZE,
            LINE_WRAP_LIMIT,
            true,
        );
        adaptive_append_inline(
            &mut code,
            vec!['{'.to_string()],
            NO_INDENTATION,
            LINE_WRAP_LIMIT,
            true,
        );
        let name: String = format!("{}::", self.enum_type.name_without_variant().inline());
        let mut arm_blocks = vec![];
        for arm in &self.arms {
            let mut arm_lines = arm.emit_code_lines();
            if !arm_lines.is_empty() {
                if !arm_lines.first().unwrap().starts_with('_') {
                    arm_lines.first_mut().unwrap().insert_str(0, &name);
                }
                arm_blocks.push(arm_lines);
            }
        }
        add_comma_for_blocks(&mut arm_blocks, true);
        let arm_lines = arm_blocks.into_iter().flatten().collect();
        append_code_lines_with_indentation(&mut code, arm_lines, INDENTATION_SIZE);
        code.push("}".to_string());
        code
    }
}

impl CodeGenerator for MatchArm {
    fn emit_code_lines(&self) -> Vec<String> {
        let mut code = vec![];
        set_ignore_module(true);
        if !self.pattern.is_wildcard() {
            code.push(self.variant_type.name().inline());
        }
        set_ignore_module(false);
        let pat_lines = self.pattern.emit_code_lines();
        adaptive_append_inline(&mut code, pat_lines, NO_INDENTATION, LINE_WRAP_LIMIT, true);
        code.last_mut().unwrap().push_str(" =>");
        let body = self.body.emit_code_lines();
        adaptive_append_inline(&mut code, body, INDENTATION_SIZE, LINE_WRAP_LIMIT, true);
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
        let inline_code = match self.inline {
            true => "inline ".to_string(),
            false => "".to_string(),
        };
        let mut code = vec![format!(
            "{}{}{}",
            self.visibility.emit_code(),
            inline_code,
            self.signature.emit_code()
        )];
        append_block(&mut code, self.body.emit_code_lines(), 0);
        code
    }
}

impl CodeGenerator for Visibility {
    fn emit_code_lines(&self) -> Vec<String> {
        use Visibility as V;
        vec![match self {
            V::Private => "".to_string(),
            V::Public => "public ".to_string(),
            V::PublicFriend => "public(friend) ".to_string(),
            V::Package => "package ".to_string(),
        }]
    }
}

impl CodeGenerator for Signature {
    fn emit_code_lines(&self) -> Vec<String> {
        let mut code = match self.is_func_value {
            true => "".to_string(),
            false => format!("fun {}", self.name),
        };

        let mut params = self
            .parameters
            .iter()
            .map(|p| p.emit_code())
            .collect::<Vec<String>>();
        add_comma_for_lines(&mut params, true);

        let lines = match self.is_func_value {
            true => put_inside_pair_of("|", "|", params, NO_INDENTATION),
            false => put_inside_pair_of("(", ")", params, NO_INDENTATION),
        };
        code.push_str(&lines_to_inline(lines));

        if self.has_return() && !self.is_func_value {
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
                        .map(|v| {
                            let mut vp = v.clone();
                            vp.show_type = false;
                            vp.inline()
                        })
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
            Statement::Spec(spec) => spec.emit_code_lines(),
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
            E::EnumInstantiation(e) => e.emit_code_lines(),
            E::Assignment(a) => a.emit_code_lines(),
            E::Variable(v) => v.emit_code_lines(),
            E::NumberLiteral(n) => n.emit_code_lines(),
            E::Bool(b) => b.emit_code_lines(),
            E::Tuple(t) => t.emit_code_lines(),
            E::FunctionCall(f) => f.emit_code_lines(),
            E::EnumMatch(m) => m.emit_code_lines(),
            E::BinOp(b) => b.emit_code_lines(),
            E::UnOp(u) => u.emit_code_lines(),
            E::FunctionValue(f) => f.emit_code_lines(),
            E::Unit(u) => u.emit_code_lines(),
            E::Reference(r) => r.emit_code_lines(),
            E::Dereference(d) => d.emit_code_lines(),
            E::Block(b) => b.emit_code_lines(),
            E::IfElse(ite) => ite.emit_code_lines(),
        }
    }
}

impl CodeGenerator for Tuple {
    fn emit_code_lines(&self) -> Vec<String> {
        let mut elem_lines = vec![];
        for expr in &self.expressions {
            elem_lines.extend(expr.emit_code_lines());
            elem_lines.last_mut().unwrap().push(',');
        }

        let elems = put_inside_pair_of("(", ")", elem_lines, INDENTATION_SIZE);
        let mut code = vec![];
        adaptive_append_inline(&mut code, elems, NO_INDENTATION, LINE_WRAP_LIMIT, false);
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
        match self {
            Assignment::AssignPattern(pat, expr) => {
                let lhs = pat.inline();
                let type_hint = if matches!(pat.typ, Type::Generic(GenericType::Function(_))) {
                    format!(": {}", pat.typ.emit_code())
                } else {
                    "".to_string()
                };
                let mut code = vec![format!("{}{} =", lhs, type_hint)];
                append_block(&mut code, expr.emit_code_lines(), 0);
                code
            },
            Assignment::AssignDeref(lhs, rhs) => {
                let mut code = lhs.emit_code_lines();
                code.last_mut().unwrap().push_str(" =");
                let rhs_lines = rhs.emit_code_lines();
                adaptive_append_inline(&mut code, rhs_lines, NO_INDENTATION, LINE_WRAP_LIMIT, true);
                code
            },
        }
    }
}

impl CodeGenerator for Pattern {
    fn emit_code_lines(&self) -> Vec<String> {
        let typ_name = self.typ.name().inline();
        match &self.body {
            PatternKind::Variable(v) => vec![v.inline()],
            PatternKind::Positional(pats) => {
                let mut code = if self.typ.is_struct() {
                    format!("{typ_name}(")
                } else {
                    '('.to_string()
                };
                let mut elems = vec![];
                let mut adding_dot = false;
                for pat in pats {
                    match pat {
                        Some(p) => elems.push(p.inline()),
                        None => {
                            if adding_dot {
                                continue;
                            }
                            elems.push("..".to_string());
                            adding_dot = true;
                        },
                    }
                }
                code.push_str(&elems.join(", "));
                code.push(')');
                vec![code]
            },
            PatternKind::Named(pats, num_total_fields) => {
                let mut code = if self.typ.is_tuple() || self.typ.is_struct() {
                    vec![format!("{}{{", typ_name)]
                } else {
                    vec!['{'.to_string()]
                };
                for (id, pat) in pats {
                    code.push(format!("{}: {},", id.inline(), pat.inline()));
                }
                if pats.len() != *num_total_fields {
                    code.push("..".to_string());
                }
                code.push('}'.to_string());
                code
            },
            PatternKind::Wildcard => vec!['_'.to_string()],
            PatternKind::Unit => vec!["()".to_string()],
        }
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
        let mut code = if self.name.is_func() || self.name.is_struct() || self.name.is_enum() {
            self.name.emit_code()
        } else {
            self.name.name.clone()
        };
        if self.show_type {
            code.push_str(": ");
            code.push_str(&self.typ.emit_code());
        }
        vec![code]
    }
}

impl CodeGenerator for DotVariable {
    fn emit_code_lines(&self) -> Vec<String> {
        set_ignore_module(true);
        let ids = self
            .vars
            .iter()
            .map(|(id, _)| id.emit_code())
            .collect::<Vec<String>>();
        set_ignore_module(false);
        vec![ids.join(".")]
    }
}

impl CodeGenerator for NumberLiteral {
    fn emit_code_lines(&self) -> Vec<String> {
        // For signed integers, interpret the BigUint as two's complement and convert to signed representation
        let formatted_value = match &self.typ {
            Type::Primitive(Primitive::Number(NumberType::I8)) => {
                let byte = self.value.to_u8().unwrap_or(0);
                let signed = byte as i8;
                signed.to_string()
            },
            Type::Primitive(Primitive::Number(NumberType::I16)) => {
                let bytes = self.value.to_u16().unwrap_or(0);
                let signed = bytes as i16;
                signed.to_string()
            },
            Type::Primitive(Primitive::Number(NumberType::I32)) => {
                let bytes = self.value.to_u32().unwrap_or(0);
                let signed = bytes as i32;
                signed.to_string()
            },
            Type::Primitive(Primitive::Number(NumberType::I64)) => {
                let bytes = self.value.to_u64().unwrap_or(0);
                let signed = bytes as i64;
                signed.to_string()
            },
            Type::Primitive(Primitive::Number(NumberType::I128)) => {
                let bytes = self.value.to_u128().unwrap_or(0);
                let signed = bytes as i128;
                signed.to_string()
            },
            Type::Primitive(Primitive::Number(NumberType::I256)) => {
                // Convert BigUint to BigInt, interpreting as two's complement
                let bit_value = BigInt::from_biguint(num_bigint::Sign::Plus, self.value.clone());
                // Check if the high bit is set (negative in two's complement)
                let max_positive: BigInt = BigInt::from(1) << 255;
                if bit_value >= max_positive {
                    // Subtract 2^256 to get the negative value
                    let modulus: BigInt = BigInt::from(1) << 256;
                    let result: BigInt = bit_value - modulus;
                    result.to_string()
                } else {
                    bit_value.to_string()
                }
            },
            _ => self.value.to_string(),
        };

        vec![format!("{}{}", formatted_value, self.typ.emit_code())]
    }
}

impl CodeGenerator for Bool {
    fn emit_code_lines(&self) -> Vec<String> {
        vec![
            if self.value {
                "true".to_string()
            } else {
                "false".to_string()
            },
        ]
    }
}

impl CodeGenerator for BinOp {
    fn emit_code_lines(&self) -> Vec<String> {
        let mut code = vec![];
        let lhs = self.left.as_ref().emit_code_lines();
        adaptive_append_inline(&mut code, lhs, NO_INDENTATION, LINE_WRAP_LIMIT, true);
        let mut rest = vec![self.op.emit_code()];
        let rhs = self.right.as_ref().emit_code_lines();
        rest.extend(rhs);
        adaptive_append_inline(&mut code, rest, NO_INDENTATION, LINE_WRAP_LIMIT, true);
        put_inside_pair_of("(", ")", code, INDENTATION_SIZE)
    }
}

impl CodeGenerator for UnOp {
    fn emit_code_lines(&self) -> Vec<String> {
        let mut code = vec![self.op.emit_code()];
        let expr = self.expr.as_ref().emit_code_lines();
        let expr = put_inside_pair_of("(", ")", expr, NO_INDENTATION);
        adaptive_append_inline(&mut code, expr, NO_INDENTATION, LINE_WRAP_LIMIT, true);
        code
    }
}

impl CodeGenerator for BinOperator {
    fn emit_code_lines(&self) -> Vec<String> {
        use BinOperator as BOP;
        vec![match self {
            BOP::Add => "+".to_string(),
            BOP::Sub => "-".to_string(),
            BOP::Mul => "*".to_string(),
            BOP::Mod => "%".to_string(),
            BOP::Div => "/".to_string(),
            BOP::BitAnd => "&".to_string(),
            BOP::BitOr => "|".to_string(),
            BOP::BitXor => "^".to_string(),
            BOP::Shl => "<<".to_string(),
            BOP::Shr => ">>".to_string(),
            BOP::Lt => "<".to_string(),
            BOP::Gt => ">".to_string(),
            BOP::Leq => "<=".to_string(),
            BOP::Geq => ">=".to_string(),
            BOP::And => "&&".to_string(),
            BOP::Or => "||".to_string(),
            BOP::Eq => "==".to_string(),
            BOP::Neq => "!=".to_string(),
        }]
    }
}

impl CodeGenerator for UnOperator {
    fn emit_code_lines(&self) -> Vec<String> {
        vec![match self {
            UnOperator::Not => "!".to_string(),
        }]
    }
}

impl CodeGenerator for Callable {
    fn emit_code_lines(&self) -> Vec<String> {
        let expr_lines = self.expr.as_ref().emit_code_lines();
        put_inside_pair_of("(", ")", expr_lines, NO_INDENTATION)
    }
}

impl CodeGenerator for FunctionCall {
    fn emit_code_lines(&self) -> Vec<String> {
        let mut code = self.callable.emit_code_lines();

        let mut arg_blocks = vec![];
        for arg in &self.args.0 {
            arg_blocks.push(arg.emit_code_lines());
        }

        add_comma_for_blocks(&mut arg_blocks, true);
        let arg_lines = arg_blocks.into_iter().flatten().collect();
        let args = put_inside_pair_of("(", ")", arg_lines, INDENTATION_SIZE);
        adaptive_append_inline(&mut code, args, NO_INDENTATION, LINE_WRAP_LIMIT, true);
        code
    }
}

impl CodeGenerator for FunctionValue {
    fn emit_code_lines(&self) -> Vec<String> {
        let mut code = vec![self.signature.inline()];
        let body = self.body.emit_code_lines();
        adaptive_append_inline(&mut code, body, INDENTATION_SIZE, LINE_WRAP_LIMIT, true);
        code
    }
}

impl CodeGenerator for Type {
    fn emit_code_lines(&self) -> Vec<String> {
        use Type as T;
        vec![match self {
            T::Generic(g) => g.inline(),
            T::Primitive(p) => p.inline(),
            T::Unit => "()".to_string(),
            _ => unimplemented!(),
        }]
    }
}

impl CodeGenerator for GenericType {
    fn emit_code_lines(&self) -> Vec<String> {
        use GenericType as G;
        vec![match self {
            G::Struct(st) => st.name().emit_code(),
            G::Tuple(t) => {
                let mut code = vec![];
                for ty in &t.types {
                    code.push(ty.inline());
                }
                format!("({})", code.join(", "))
            },
            G::Enum(e) => e.name.emit_code(),
            G::Function(f) => f.emit_code(),
            G::Reference(r) => r.emit_code(),
            _ => unimplemented!(),
        }]
    }
}

impl CodeGenerator for ReferenceType {
    fn emit_code_lines(&self) -> Vec<String> {
        vec![match self {
            ReferenceType::Mutable(t) => format!("&mut {}", t.inline()),
            ReferenceType::Immutable(t) => format!("&{}", t.inline()),
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
            N::I8 => "i8".to_string(),
            N::I16 => "i16".to_string(),
            N::I32 => "i32".to_string(),
            N::I64 => "i64".to_string(),
            N::I128 => "i128".to_string(),
            N::I256 => "i256".to_string(),
        }]
    }
}

impl CodeGenerator for FunctionType {
    fn emit_code_lines(&self) -> Vec<String> {
        let mut params = self
            .params
            .iter()
            .map(|p| {
                let type_s = p.inline();
                if p.is_function() {
                    format!("({type_s})")
                } else {
                    type_s
                }
            })
            .collect::<Vec<String>>();
        add_comma_for_lines(&mut params, true);
        params = match self.is_func_value {
            true => put_inside_pair_of("|", "|", params, NO_INDENTATION),
            false => put_inside_pair_of("(", ")", params, NO_INDENTATION),
        };
        let mut code = lines_to_inline(params);

        // TODO: do not hardcode
        if self.has_return() {
            code.push_str(" (");
            code.push_str(&self.return_type.emit_code());
            code.push_str(" )");
        }

        if self.is_func_value && !self.abilities.is_empty() {
            let abilities = self
                .abilities
                .iter()
                .map(|a| a.emit_code())
                .collect::<Vec<String>>()
                .join("+");
            code.push_str(&format!(" has {abilities}"));
        }

        vec![code]
    }
}

impl CodeGenerator for Unit {
    fn emit_code_lines(&self) -> Vec<String> {
        vec!["()".to_string()]
    }
}

impl CodeGenerator for Command {
    fn emit_code_lines(&self) -> Vec<String> {
        vec![format!("//# run {}", self.full_name.get_name())]
    }
}

impl CodeGenerator for Reference {
    fn emit_code_lines(&self) -> Vec<String> {
        let left_op = match self {
            Reference::Mutable(_) => "&mut (",
            Reference::Immutable(_) => "&(",
        };
        let expr_lines = self.get_expr().emit_code_lines();
        put_inside_pair_of(left_op, ")", expr_lines, NO_INDENTATION)
    }
}

impl CodeGenerator for Dereference {
    fn emit_code_lines(&self) -> Vec<String> {
        let expr_lines = self.get_expr().emit_code_lines();
        put_inside_pair_of("*(", ")", expr_lines, NO_INDENTATION)
    }
}

impl CodeGenerator for Use {
    fn emit_code_lines(&self) -> Vec<String> {
        vec![format!("use {};", self.name.full_name())]
    }
}

impl CodeGenerator for Branch {
    fn emit_code_lines(&self) -> Vec<String> {
        self.body.emit_code_lines()
    }
}

impl CodeGenerator for IfElse {
    fn emit_code_lines(&self) -> Vec<String> {
        let mut code = vec!["if".to_string()];
        let condition_lines =
            put_inside_pair_of("(", ")", self.condition.emit_code_lines(), INDENTATION_SIZE);
        adaptive_append_inline(
            &mut code,
            condition_lines,
            INDENTATION_SIZE,
            LINE_WRAP_LIMIT,
            true,
        );
        adaptive_append_inline(
            &mut code,
            self.branches.first().unwrap().emit_code_lines(),
            INDENTATION_SIZE,
            LINE_WRAP_LIMIT,
            true,
        );

        if let Some(else_branch) = self.branches.get(1) {
            code.last_mut().unwrap().push_str(" else");
            adaptive_append_inline(
                &mut code,
                else_branch.emit_code_lines(),
                INDENTATION_SIZE,
                LINE_WRAP_LIMIT,
                true,
            );
        }
        put_inside_pair_of("(", ")", code, NO_INDENTATION)
    }
}

impl CodeGenerator for SpecBlock {
    fn emit_code_lines(&self) -> Vec<String> {
        let mut code = if let SpecContext::FunctionSpec { target_function } = &self.context {
            vec![format!("spec {} ", &target_function.name.name)]
        } else {
            vec!["spec ".to_string()]
        };

        let mut body_lines = Vec::new();

        // Add spec statements
        for stmt in &self.statements {
            body_lines.extend(stmt.emit_code_lines());
        }

        let body = put_inside_pair_of("{", "}", body_lines, INDENTATION_SIZE);
        append_block(&mut code, body, INDENTATION_SIZE);
        code
    }
}

impl CodeGenerator for SpecStatement {
    fn emit_code_lines(&self) -> Vec<String> {
        let (keyword, predicate) = match self {
            SpecStatement::Assert(pred) => ("assert", pred),
            SpecStatement::Assume(pred) => ("assume", pred),
            SpecStatement::Requires(pred) => ("requires", pred),
            SpecStatement::Ensures(pred) => ("ensures", pred),
        };

        // Create the statement on one line: "keyword predicate;"
        let mut code = vec![format!("{} ", keyword)];
        adaptive_append_inline(
            &mut code,
            predicate.emit_code_lines(),
            NO_INDENTATION,
            LINE_WRAP_LIMIT,
            true,
        );

        // Add semicolon to the last line
        if let Some(last_line) = code.last_mut() {
            last_line.push(';');
        }

        code
    }
}

impl CodeGenerator for SpecPredicate {
    fn emit_code_lines(&self) -> Vec<String> {
        match self {
            SpecPredicate::Expression(expr) => expr.emit_code_lines(),
            // Future: add forall, exists, etc.
        }
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
