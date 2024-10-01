// Copyright (c) Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

use crate::{
    ast::*,
    names::{Identifier, IdentifierKind as IDKind},
    types::{Ability, StructTypeConcrete, Type, TypeArgs, TypeParameter, TypeParameters},
};
use std::{collections::BTreeSet, vec};

static PROLOGUE: &str = include_str!("prologue.move");
static EPILOGUE: &str = include_str!("epilogue.move");

/// Generates Move source code from an AST.
/// `emit_code_lines` should be implemented for each AST node.
pub trait CodeGenerator {
    /// Generate Move source code.
    fn emit_code(&self) -> String {
        self.emit_code_lines().join("\n")
    }

    /// Generate a single line for subtree.
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

/// The number of spaces to use for indentation.
const INDENTATION_SIZE: usize = 4;

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

impl CodeGenerator for Identifier {
    fn emit_code_lines(&self) -> Vec<String> {
        vec![self.name.clone()]
    }
}

/// To follow the transactional test format, we output module code first, then script code.
impl CodeGenerator for CompileUnit {
    fn emit_code_lines(&self) -> Vec<String> {
        let mut code = Vec::new();
        code.push(PROLOGUE.to_string());
        code.push('\n'.to_string());
        for m in &self.modules {
            code.extend(m.emit_code_lines());
        }

        for s in &self.scripts {
            code.extend(s.emit_code_lines());
        }

        for r in &self.runs {
            code.push(format!(
                "//# run {} --signers 0xBEEF --gas-budget 100000\n",
                r.name
            ));
        }
        code.push(EPILOGUE.to_string());
        code
    }
}

impl CodeGenerator for Script {
    fn emit_code_lines(&self) -> Vec<String> {
        // The `//# run` is for the transactional test
        let mut code = vec!["//# run".to_string(), "script {".to_string()];
        let main = Function {
            signature: FunctionSignature {
                inline: false,
                name: Identifier::new_str("main", IDKind::Function),
                parameters: Vec::new(),
                type_parameters: TypeParameters::default(),
                return_type: None,
                acquires: BTreeSet::new(),
            },
            visibility: Visibility { public: false },
            // Hardcode one function to simplify the output
            body: Some(Block {
                name: Identifier::new_str("_block_script", IDKind::Block),
                stmts: self
                    .main
                    .iter()
                    .map(|f| Statement::Expr(Expression::FunctionCall(f.clone())))
                    .collect(),
                return_expr: None,
            }),
        };
        let main_code = main.emit_code_lines();
        append_code_lines_with_indentation(&mut code, main_code, INDENTATION_SIZE);
        code.push("}\n".to_string());
        code
    }
}

/// Output struct definitions and then function definitions in a module.
impl CodeGenerator for Module {
    fn emit_code_lines(&self) -> Vec<String> {
        // The `//# publish` is for the transactional test
        let mut code = vec![
            "//# publish".to_string(),
            format!("module 0xCAFE::{} {{", self.name.emit_code()),
        ];

        for u in &self.uses {
            append_code_lines_with_indentation(&mut code, u.emit_code_lines(), INDENTATION_SIZE);
        }

        for c in &self.constants {
            append_code_lines_with_indentation(&mut code, c.emit_code_lines(), INDENTATION_SIZE);
        }

        for s in &self.structs {
            append_code_lines_with_indentation(
                &mut code,
                s.borrow().emit_code_lines(),
                INDENTATION_SIZE,
            )
        }

        for f in &self.functions {
            append_code_lines_with_indentation(
                &mut code,
                f.borrow().emit_code_lines(),
                INDENTATION_SIZE,
            )
        }

        code.push("}\n".to_string());
        code
    }
}

impl CodeGenerator for Use {
    fn emit_code_lines(&self) -> Vec<String> {
        vec![format!("use {}::{};", self.address, self.module.inline())]
    }
}

impl CodeGenerator for StructDefinition {
    fn emit_code_lines(&self) -> Vec<String> {
        let type_params = self.type_parameters.inline();
        let abilities = match self.abilities.len() {
            0 => "".to_string(),
            _ => {
                let abilities = self
                    .abilities
                    .iter()
                    .map(|ability| ability.emit_code())
                    .collect::<Vec<String>>()
                    .join(", ")
                    .to_string();
                format!("has {} ", abilities)
            },
        };
        let mut code = vec![format!(
            "struct {}{} {}{{",
            self.name.emit_code(),
            type_params,
            abilities
        )];

        let mut fields_code = Vec::new();
        for (field_name, field_type) in &self.fields {
            fields_code.push(format!(
                "{}: {},",
                field_name.emit_code(),
                field_type.emit_code(),
            ));
        }
        append_code_lines_with_indentation(&mut code, fields_code, INDENTATION_SIZE);
        code.push("}\n".to_string());
        code
    }
}

impl CodeGenerator for Ability {
    fn emit_code_lines(&self) -> Vec<String> {
        match self {
            Ability::Copy => vec!["copy".to_string()],
            Ability::Drop => vec!["drop".to_string()],
            Ability::Store => vec!["store".to_string()],
            Ability::Key => vec!["key".to_string()],
        }
    }
}

impl CodeGenerator for TypeParameter {
    fn emit_code_lines(&self) -> Vec<String> {
        let phantom = match self.is_phantom {
            true => "phantom ",
            false => "",
        };
        let name = self.name.emit_code();
        let abilities = match self.abilities.is_empty() {
            true => "".to_string(),
            false => {
                format!(
                    ": {}",
                    self.abilities
                        .iter()
                        .map(|ability| ability.inline())
                        .collect::<Vec<String>>()
                        .join(" + ")
                )
            },
        };
        vec![format!("{}{}{}", phantom, name, abilities)]
    }
}

/// The logic to generate function signature is implemented here.
impl CodeGenerator for Function {
    fn emit_code_lines(&self) -> Vec<String> {
        let parameters = match self.signature.parameters.is_empty() {
            true => "".to_string(),
            false => {
                let params: Vec<String> = self
                    .signature
                    .parameters
                    .iter()
                    .map(|(ident, typ)| format!("{}: {}", ident.emit_code(), typ.emit_code()))
                    .collect();
                params.join(", ").to_string()
            },
        };

        let return_type = match self.signature.return_type {
            Some(ref typ) => format!(": {}", typ.emit_code()),
            None => "".to_string(),
        };

        let visibility = if self.visibility.public {
            "public "
        } else {
            ""
        };

        let inline = if self.signature.inline { "inline " } else { "" };

        let type_params = self.signature.type_parameters.inline();

        let acquires = match self.signature.acquires.is_empty() {
            true => "".to_string(),
            false => {
                let acquires: Vec<String> = self
                    .signature
                    .acquires
                    .iter()
                    .map(|st| st.inline())
                    .collect();
                format!(" acquires {}", acquires.join(", "))
            },
        };

        let mut code = vec![format!(
            "{}{}fun {}{}({}){}{}",
            visibility,
            inline,
            self.signature.name.emit_code(),
            type_params,
            parameters,
            return_type,
            acquires,
        )];
        let body = match self.body {
            Some(ref body) => body.emit_code_lines(),
            None => vec!["{}".to_string()],
        };
        append_block(&mut code, body, 0);
        code
    }
}

impl CodeGenerator for Block {
    fn emit_code_lines(&self) -> Vec<String> {
        if self.stmts.is_empty() && self.return_expr.is_none() {
            return vec!["{}".to_string()];
        }
        let mut code = vec![format!("{{ /* {} */", self.name.inline())];

        let mut body = Vec::new();
        for stmt in &self.stmts {
            body.extend(stmt.emit_code_lines());
        }

        if let Some(ref expr) = self.return_expr {
            body.extend(expr.emit_code_lines());
        }

        append_code_lines_with_indentation(&mut code, body, INDENTATION_SIZE);

        code.push("}".to_string());
        code
    }
}

impl CodeGenerator for Statement {
    fn emit_code_lines(&self) -> Vec<String> {
        match self {
            Statement::Decl(decl) => decl.emit_code_lines(),
            Statement::Expr(expr) => {
                let mut code = expr.emit_code_lines();
                if !code.is_empty() {
                    code.last_mut().unwrap().push(';');
                }
                code
            },
        }
    }
}

impl CodeGenerator for ResourceOperation {
    fn emit_code_lines(&self) -> Vec<String> {
        use ResourceOperationKind::*;

        let call = match self.kind {
            MoveTo => "move_to",
            MoveFrom => "move_from",
            BorrowGlobal => "borrow_global",
            BorrowGlobalMut => "borrow_global_mut",
            Exists => "exists",
        };

        let typ = self.typ.emit_code();

        let args = self
            .args
            .iter()
            .map(|arg| arg.inline())
            .collect::<Vec<String>>()
            .join(", ");

        vec![format!("{}<{}>({})", call, typ, args)]
    }
}

impl CodeGenerator for Declaration {
    fn emit_code_lines(&self) -> Vec<String> {
        let vars = match self.names.len() {
            1 => self.names[0].emit_code(),
            _ => {
                let vars: Vec<String> = self.names.iter().map(|id| id.emit_code()).collect();
                format!("({})", vars.join(", "))
            },
        };

        let type_anno = match self.emit_type {
            true => match self.typs.len() {
                1 => format!(": {}", self.typs[0].emit_code()),
                _ => {
                    let types: Vec<String> = self.typs.iter().map(|t| t.emit_code()).collect();
                    format!(": ({})", types.join(", "))
                },
            },
            false => "".to_string(),
        };

        let mut code = vec![format!("let {}{}", vars, type_anno)];

        if let Some(ref expr) = self.value {
            code[0].push_str(" = ");
            let rhs = expr.emit_code_lines();
            append_block(&mut code, rhs, 0);
        }
        code.last_mut().unwrap().push(';');
        code
    }
}

impl CodeGenerator for Expression {
    fn emit_code_lines(&self) -> Vec<String> {
        match self {
            Expression::AddressLiteral(addr) => vec![addr.clone()],
            Expression::NumberLiteral(n) => n.emit_code_lines(),
            Expression::Variable(ident) => ident.emit_code_lines(),
            Expression::Boolean(b) => vec![b.to_string()],
            Expression::FunctionCall(c) => c.emit_code_lines(),
            Expression::StructPack(s) => s.emit_code_lines(),
            Expression::Block(block) => block.emit_code_lines(),
            Expression::Assign(assignment) => assignment.emit_code_lines(),
            Expression::BinaryOperation(binop) => binop.emit_code_lines(),
            Expression::UnaryOperation(uop) => uop.emit_code_lines(),
            Expression::IfElse(if_expr) => if_expr.emit_code_lines(),
            Expression::Reference(expr) => vec![format!("&({})", expr.inline())],
            Expression::Dereference(expr) => vec![format!("*({})", expr.inline())],
            Expression::MutReference(expr) => vec![format!("&mut ({})", expr.inline())],
            Expression::Resource(rop) => rop.emit_code_lines(),
            Expression::VectorOperation(vop) => vop.emit_code_lines(),
            Expression::VectorLiteral(vlit) => vlit.emit_code_lines(),
            Expression::Return(e) => match e {
                Some(expr) => vec![format!("(return {})", expr.inline())],
                None => vec!["(return)".to_string()],
            },
            Expression::Abort(e) => vec![format!("(abort {})", e.inline())],
        }
    }
}

impl CodeGenerator for UnaryOperation {
    fn emit_code_lines(&self) -> Vec<String> {
        match self {
            UnaryOperation::Not(e) => vec![format!("!({})", e.inline())],
        }
    }
}

impl CodeGenerator for VectorLiteral {
    fn emit_code_lines(&self) -> Vec<String> {
        match self {
            VectorLiteral::Empty(t) => {
                vec![format!("vector<{}>[]", t.inline())]
            },
            VectorLiteral::Multiple(_, elems) => {
                let mut code = vec!["vector[".to_string()];
                for elem in elems {
                    append_code_lines_with_indentation(
                        &mut code,
                        elem.emit_code_lines(),
                        INDENTATION_SIZE,
                    );
                    code.last_mut().unwrap().push(',');
                }
                code.push(']'.to_string());
                code
            },
            VectorLiteral::ByteString(s) => {
                vec![format!("b\"{}\"", s)]
            },
            VectorLiteral::HexString(s) => {
                vec![format!("x\"{}\"", s)]
            },
        }
    }
}

impl CodeGenerator for VectorOperation {
    fn emit_code_lines(&self) -> Vec<String> {
        use VectorOperationKind::*;

        let call = match self.op {
            Empty => "empty",
            Singleton => "singleton",
            Length => "length",
            Borrow => "borrow",
            BorrowMut => "borrow_mut",
            PushBack => "push_back",
            PopBack => "pop_back",
            DestroyEmpty => "destroy_empty",
            Swap => "swap",
            Reverse => "reverse",
            Append => "append",
            IsEmpty => "is_empty",
            Contains => "contains",
            IndexOf => "index_of",
            Remove => "remove",
            SwapRemove => "swap_remove",
        };

        let args = self
            .args
            .iter()
            .map(|arg| arg.inline())
            .collect::<Vec<String>>()
            .join(", ");

        let typ = self.elem_typ.inline();

        vec![format!("vector::{}<{}>({})", call, typ, args)]
    }
}

impl CodeGenerator for VariableAccess {
    fn emit_code_lines(&self) -> Vec<String> {
        let copy = match self.copy {
            true => "copy ",
            false => "",
        };
        vec![format!("{}{}", copy, self.name.emit_code())]
    }
}

impl CodeGenerator for IfExpr {
    fn emit_code_lines(&self) -> Vec<String> {
        let mut code = vec![format!("if ({}) ", self.condition.inline())];
        let body = self.body.emit_code_lines();
        append_block(&mut code, body, 0);

        if let Some(else_expr) = &self.else_expr {
            let else_code = else_expr.emit_code_lines();
            append_block(&mut code, else_code, 0);
        }
        code
    }
}

impl CodeGenerator for ElseExpr {
    fn emit_code_lines(&self) -> Vec<String> {
        let mut code = vec!["else".to_string()];
        let body = self.body.emit_code_lines();
        append_block(&mut code, body, 0);
        code
    }
}

impl CodeGenerator for BinaryOperation {
    fn emit_code_lines(&self) -> Vec<String> {
        vec![format!(
            "({} {} {})",
            self.lhs.inline(),
            self.op.emit_code(),
            self.rhs.inline()
        )]
    }
}

impl CodeGenerator for Assignment {
    fn emit_code_lines(&self) -> Vec<String> {
        let mut code = vec![format!("{} =", self.lhs.emit_code(),)];
        let value = self.rhs.emit_code_lines();
        append_block(&mut code, value, 0);
        code
    }
}

impl CodeGenerator for StructPack {
    fn emit_code_lines(&self) -> Vec<String> {
        let type_args = self.type_args.inline();
        let mut code = vec![format!("{}{}", self.name.emit_code(), type_args)];
        if self.fields.is_empty() {
            code.last_mut().unwrap().push_str(" {}");
            return code;
        }

        let mut body = vec!["{".to_string()];

        let mut field_inside = Vec::new();
        for (field, expr) in &self.fields {
            let mut curr_field = vec![format!("{}:", field.emit_code())];
            let rhs = expr.emit_code_lines();
            append_block(&mut curr_field, rhs, 0);
            field_inside.extend(curr_field);
            field_inside.last_mut().unwrap().push(',');
        }
        append_code_lines_with_indentation(&mut body, field_inside, 0);
        body.push("}".to_string());

        append_block(&mut code, body, INDENTATION_SIZE);
        code
    }
}

impl CodeGenerator for FunctionCall {
    fn emit_code_lines(&self) -> Vec<String> {
        let type_args = self.type_args.inline();
        let mut code = vec![format!("{}{}(", self.name.emit_code(), type_args)];
        if self.args.is_empty() {
            code.last_mut().unwrap().push(')');
            return code;
        }
        let mut args = Vec::new();
        for arg in &self.args {
            let mut arg_lines = arg.emit_code_lines();
            arg_lines.last_mut().unwrap().push(',');
            args.extend(arg_lines);
        }
        append_code_lines_with_indentation(&mut code, args, INDENTATION_SIZE);
        code.push(")".to_string());
        code
    }
}

impl CodeGenerator for TypeParameters {
    fn emit_code_lines(&self) -> Vec<String> {
        if self.type_parameters.is_empty() {
            return vec!["".to_string()];
        }

        let params = self
            .type_parameters
            .iter()
            .map(|tp| tp.inline())
            .collect::<Vec<String>>()
            .join(", ");
        vec![format!("<{}>", params)]
    }
}

impl CodeGenerator for TypeArgs {
    fn emit_code_lines(&self) -> Vec<String> {
        if self.type_args.is_empty() {
            return vec!["".to_string()];
        }

        let args = self
            .type_args
            .iter()
            .map(|t| t.inline())
            .collect::<Vec<String>>()
            .join(", ");
        vec![format!("<{}>", args)]
    }
}

impl CodeGenerator for NumberLiteral {
    fn emit_code_lines(&self) -> Vec<String> {
        vec![format!("{}{}", self.value, self.typ.emit_code())]
    }
}

impl CodeGenerator for BinaryOperator {
    fn emit_code_lines(&self) -> Vec<String> {
        match self {
            BinaryOperator::Numerical(op) => op.emit_code_lines(),
            BinaryOperator::Boolean(op) => op.emit_code_lines(),
            BinaryOperator::Equality(op) => op.emit_code_lines(),
        }
    }
}

impl CodeGenerator for NumericalBinaryOperator {
    fn emit_code_lines(&self) -> Vec<String> {
        use NumericalBinaryOperator as OP;
        vec![match self {
            OP::Add => "+".to_string(),
            OP::Sub => "-".to_string(),
            OP::Mul => "*".to_string(),
            OP::Mod => "%".to_string(),
            OP::Div => "/".to_string(),
            OP::BitAnd => "&".to_string(),
            OP::BitOr => "|".to_string(),
            OP::BitXor => "^".to_string(),
            OP::Shl => "<<".to_string(),
            OP::Shr => ">>".to_string(),
            OP::Le => "<".to_string(),
            OP::Ge => ">".to_string(),
            OP::Leq => "<=".to_string(),
            OP::Geq => ">=".to_string(),
        }]
    }
}

impl CodeGenerator for BooleanBinaryOperator {
    fn emit_code_lines(&self) -> Vec<String> {
        vec![match self {
            BooleanBinaryOperator::And => "&&".to_string(),
            BooleanBinaryOperator::Or => "||".to_string(),
        }]
    }
}

impl CodeGenerator for EqualityBinaryOperator {
    fn emit_code_lines(&self) -> Vec<String> {
        vec![match self {
            EqualityBinaryOperator::Eq => "==".to_string(),
            EqualityBinaryOperator::Neq => "!=".to_string(),
        }]
    }
}

impl CodeGenerator for Type {
    fn emit_code_lines(&self) -> Vec<String> {
        use Type as T;
        vec![match self {
            T::U8 => "u8".to_string(),
            T::U16 => "u16".to_string(),
            T::U32 => "u32".to_string(),
            T::U64 => "u64".to_string(),
            T::U128 => "u128".to_string(),
            T::U256 => "u256".to_string(),
            T::Bool => "bool".to_string(),
            T::Ref(t) => format!("&{}", t.inline()),
            T::MutRef(t) => format!("&mut {}", t.inline()),
            T::Tuple(ts) => {
                let types = ts
                    .iter()
                    .map(|t| t.inline())
                    .collect::<Vec<String>>()
                    .join(", ");
                format!("({})", types)
            },
            T::Struct(st) => st.name.inline(),
            T::StructConcrete(st) => st.inline(),
            T::TypeParameter(tp) => tp.name.inline(),
            T::Address => "address".to_string(),
            T::Signer => "signer".to_string(),
            T::Vector(t) => format!("vector<{}>", t.inline()),
            _ => unimplemented!(),
        }]
    }
}

impl CodeGenerator for StructTypeConcrete {
    fn emit_code_lines(&self) -> Vec<String> {
        let type_args = self.type_args.inline();
        vec![format!("{}{}", self.name.emit_code(), type_args)]
    }
}

impl CodeGenerator for Constant {
    fn emit_code_lines(&self) -> Vec<String> {
        vec![format!(
            "const {}: {} = {};",
            self.name.emit_code(),
            self.typ.emit_code(),
            self.value.inline()
        )]
    }
}
