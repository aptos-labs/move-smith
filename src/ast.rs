// Copyright (c) Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

//! An abstract syntax tree for the Move language used by the MoveSmith fuzzer.
//! The AST is taken mostly from `third_party/move/move-compiler/src/parser/ast.rs`.
//! Ideally when the fuzzer becomes more mature, this AST will converge to the
//! parser's AST and we might be able to reuse the parser's AST directly.

use crate::{
    names::{Identifier, IdentifierKind as IDKind},
    types::{Ability, HasType, Type, TypeArgs, TypeParameters},
    CodeGenerator,
};
use arbitrary::Arbitrary;
use num_bigint::BigUint;
use std::{cell::RefCell, collections::BTreeSet};

/// The collection of modules and scripts that make up a Move program.
/// This is the final output of the MoveSmith fuzzer.
/// This should be runnable as a transactional test.
#[derive(Debug, Clone)]
pub struct CompileUnit {
    pub modules: Vec<Module>,
    pub scripts: Vec<Script>,
    pub runs: Vec<Identifier>,
}

/// A Move module.
#[derive(Debug, Clone)]
pub struct Module {
    // pub attributes: Vec<Attributes>,
    // pub address: Option<LeadingNameAccess>,
    pub uses: Vec<Use>,
    pub name: Identifier,
    pub functions: Vec<RefCell<Function>>,
    pub structs: Vec<RefCell<StructDefinition>>,
    pub constants: Vec<Constant>,
}

#[derive(Debug, Clone)]
pub struct Use {
    pub address: String,
    pub module: Identifier,
}

/// A simplified Move Script.
/// The script only contains a `main` function.
/// The `main` function only consists of a sequence of function calls.
#[derive(Debug, Clone)]
pub struct Script {
    pub main: Vec<FunctionCall>,
}

/// A function definition.
/// The return statement is separated from the body to simplify verifying the
/// generated function has a valid return.
#[derive(Debug, Clone)]
pub struct Function {
    pub visibility: Visibility,
    pub signature: FunctionSignature,
    pub body: Option<Block>,
}

/// The Visibility
#[derive(Debug, Clone)]
pub struct Visibility {
    pub public: bool,
}

/// A function signature.
#[derive(Debug, Clone)]
pub struct FunctionSignature {
    pub inline: bool,
    pub type_parameters: TypeParameters,
    pub name: Identifier,
    pub parameters: Vec<(Identifier, Type)>,
    pub return_type: Option<Type>,
    /// Keep track of what types a function needs to acquire
    /// Maps name of a struct to a block scope
    /// e.g. `Struct2 -> _block1` means while generating `_block1`, the `Struct2`
    /// was acquired.
    /// Block information is needed to remove unnecessary acquires.
    /// We only keep track of the struct name instead of the
    /// full type instantiation with parameters
    pub acquires: BTreeSet<Identifier>,
}

/// An expression block
#[derive(Debug, Clone)]
pub struct Block {
    pub name: Identifier,
    pub stmts: Vec<Statement>,
    pub return_expr: Option<Expression>,
}

/// The definition of a struct.
/// Cyclic data is not allowed.
/// Struct used in fields must have the all the abilities of the parent struct.
#[derive(Debug, Clone)]
pub struct StructDefinition {
    pub name: Identifier,
    pub abilities: Vec<Ability>,
    pub type_parameters: TypeParameters,
    pub fields: Vec<(Identifier, Type)>,
}

impl HasType for StructDefinition {
    fn get_type(&self) -> Type {
        Type::new_struct(&self.name, Some(&self.type_parameters))
    }
}

/// A statement in a function body.
#[derive(Debug, Clone)]
pub enum Statement {
    // While(While),
    // For(For),
    // Break,
    // Continue,
    Decl(Declaration),
    Expr(Expression),
}

/// Kinds of global resource storage operations
#[derive(Debug, Clone, Arbitrary)]
pub enum ResourceOperationKind {
    MoveTo,
    MoveFrom,
    BorrowGlobal,
    BorrowGlobalMut,
    Exists,
}

/// A global storage operation.
/// Each storage operation is generated as a declaration.
/// Any return value will be stored in a variable.
#[derive(Debug, Clone)]
pub struct ResourceOperation {
    pub kind: ResourceOperationKind,
    pub typ: Type,
    pub args: Vec<Expression>,
}

/// An inline struct initialization.
#[derive(Debug, Clone)]
pub struct StructPack {
    pub name: Identifier,
    pub type_args: TypeArgs,
    pub fields: Vec<(Identifier, Expression)>,
}

impl HasType for StructPack {
    fn get_type(&self) -> Type {
        let name = format!("{}{}", self.name.inline(), self.type_args.inline());
        let kind = IDKind::StructConcrete;
        Type::new_concrete_struct(&Identifier::new(name, kind), Some(&self.type_args))
    }
}

/// Declare a new variable.
/// Optionally initialize the variable with an expression.
/// Currently type annotations will always be generated.
#[derive(Debug, Clone)]
pub struct Declaration {
    pub typs: Vec<Type>,
    pub names: Vec<Identifier>,
    pub value: Option<Expression>,
    pub emit_type: bool,
}

/// An expression.
#[derive(Debug, Clone)]
pub enum Expression {
    AddressLiteral(String),
    NumberLiteral(NumberLiteral),
    Variable(VariableAccess),
    Boolean(bool),
    FunctionCall(FunctionCall),
    StructPack(StructPack),
    Block(Box<Block>),
    Assign(Box<Assignment>),
    BinaryOperation(Box<BinaryOperation>),
    UnaryOperation(UnaryOperation),
    IfElse(Box<IfExpr>),
    Reference(Box<Expression>),
    Dereference(Box<Expression>),
    MutReference(Box<Expression>),
    Return(Option<Box<Expression>>),
    Abort(Box<Expression>),

    // The following three are expressions but may contain let bindings
    Resource(ResourceOperation),
    VectorOperation(VectorOperation),
    VectorLiteral(VectorLiteral),
}

/// An expression.
#[derive(Debug, Clone)]
pub enum UnaryOperation {
    Not(Box<Expression>),
}

#[derive(Debug, Clone)]
pub enum VectorLiteral {
    Empty(Type),
    Multiple(Type, Vec<Expression>),
    ByteString(String), // Must be ASCII
    HexString(String),
}

#[derive(Debug, Clone)]
pub struct VectorOperation {
    // Type of the underlying elements
    pub elem_typ: Type,
    // The operation kind
    pub op: VectorOperationKind,
    // The arguments to the operation, if needed
    pub args: Vec<Expression>,
}

#[derive(Debug, Clone)]
pub enum VectorOperationKind {
    Empty,
    Singleton,
    Length,
    Borrow,
    BorrowMut,
    PushBack,
    PopBack,
    DestroyEmpty,
    Swap,
    Reverse,
    Append,
    IsEmpty,
    Contains,
    IndexOf,
    Remove,
    SwapRemove,
    // The following requires lambda
    // ForEach,
    // ForEachRef,
    // ForEachMut,
    // Fold
    // Map
    // Filter
}

/// Represent the type of vector an operation requires i.e. the type of the first argument
pub enum VecOpVecType {
    Ref,
    MutRef,
    Own,
    None,
}

impl VectorOperationKind {
    /// Return the type of the vector required for the operation
    /// This is kept separately from the arguments to avoid generating random expressions
    /// for the first argument (if any)
    pub fn op_use_vec_type(&self) -> VecOpVecType {
        use VecOpVecType::*;
        use VectorOperationKind::*;
        match self {
            Empty => None,
            Singleton => None,
            Length => Ref,
            Borrow => Ref,
            BorrowMut => MutRef,
            PushBack => MutRef,
            PopBack => MutRef,
            DestroyEmpty => Own,
            Swap => MutRef,
            Reverse => MutRef,
            Append => MutRef,
            IsEmpty => Ref,
            Contains => Ref,
            IndexOf => Ref,
            Remove => MutRef,
            SwapRemove => MutRef,
        }
    }

    pub fn has_return(&self) -> bool {
        self.ret_type(&Type::U8).is_some()
    }

    pub fn ret_type(&self, elem_typ: &Type) -> Option<Type> {
        use VectorOperationKind::*;
        let vec_typ = Type::Vector(Box::new(elem_typ.clone()));
        let elem_ref = Type::Ref(Box::new(elem_typ.clone()));
        let elem_mutref = Type::MutRef(Box::new(elem_typ.clone()));
        match self {
            Empty => Some(vec_typ),
            Singleton => Some(vec_typ),
            Length => Some(Type::U64),
            Borrow => Some(elem_ref),
            BorrowMut => Some(elem_mutref),
            PushBack => None,
            PopBack => Some(elem_typ.clone()),
            DestroyEmpty => None,
            Swap => None,
            Reverse => None,
            Append => None,
            IsEmpty => Some(Type::Bool),
            Contains => Some(Type::Bool),
            IndexOf => Some(Type::Tuple(vec![Type::Bool, Type::U64])),
            Remove => Some(elem_typ.clone()),
            SwapRemove => Some(elem_typ.clone()),
        }
    }

    /// Return the list of argument types required for the vector operation
    pub fn args_types(&self, elem_typ: &Type) -> Vec<Type> {
        use VectorOperationKind::*;
        match self {
            Empty => vec![],
            Singleton => vec![elem_typ.clone()],
            Length => vec![],
            Borrow => vec![Type::U64],
            BorrowMut => vec![Type::U64],
            PushBack => vec![elem_typ.clone()],
            PopBack => vec![],
            DestroyEmpty => vec![],
            Swap => vec![Type::U64, Type::U64],
            Reverse => vec![],
            // Append requires another vector so we need to handle it specially
            // during generaton to avoid get a random vector that doesn't type check
            Append => vec![],
            IsEmpty => vec![],
            Contains => vec![Type::Ref(Box::new(elem_typ.clone()))],
            IndexOf => vec![Type::Ref(Box::new(elem_typ.clone()))],
            Remove => vec![Type::U64],
            SwapRemove => vec![Type::U64],
        }
    }
}

/// Represents a variable access
#[derive(Debug, Clone)]
pub struct VariableAccess {
    pub name: Identifier,
    pub copy: bool,
}

// If Expression
#[derive(Debug, Clone)]
pub struct IfExpr {
    pub condition: Expression,
    pub body: Block,
    pub else_expr: Option<ElseExpr>,
}

// Else Expression
// Should only be contained in an IfExpr
#[derive(Debug, Clone)]
pub struct ElseExpr {
    pub typ: Option<Type>,
    pub body: Block,
}

#[derive(Debug, Clone)]
pub struct BinaryOperation {
    pub op: BinaryOperator,
    pub lhs: Expression,
    pub rhs: Expression,
}

#[derive(Debug, Clone)]
pub enum BinaryOperator {
    Numerical(NumericalBinaryOperator),
    Boolean(BooleanBinaryOperator),
    Equality(EqualityBinaryOperator),
}

#[derive(Debug, Clone, Arbitrary)]
pub enum NumericalBinaryOperator {
    Add,
    Sub,
    Mul,
    Mod,
    Div,
    BitAnd,
    BitOr,
    BitXor,
    Shl,
    Shr,
    Le,
    Ge,
    Leq,
    Geq,
}

#[derive(Debug, Clone, Arbitrary)]
pub enum BooleanBinaryOperator {
    And,
    Or,
}

#[derive(Debug, Clone, Arbitrary)]
pub enum EqualityBinaryOperator {
    Eq,
    Neq,
}

/// An assignment expression
#[derive(Debug, Clone)]
pub struct Assignment {
    pub name: Identifier,
    pub value: Expression,
    pub deref: bool,
}

/// A number literal.
/// Currently the number literal will always have the type suffix.
#[derive(Debug, Clone)]
pub struct NumberLiteral {
    pub value: BigUint,
    pub typ: Type,
}

/// A function call.
/// Currently the generated doesn't allow the argument to be another function call.
#[derive(Debug, Clone)]
pub struct FunctionCall {
    pub name: Identifier,
    pub type_args: TypeArgs,
    pub args: Vec<Expression>,
}
/// A constant
#[derive(Debug, Clone)]
pub struct Constant {
    pub typ: Type,
    pub name: Identifier,
    pub value: Expression,
}

type ExprFilter = fn(&Expression) -> bool;

#[derive(Debug, Clone, Default)]
struct ExprCollector<'a> {
    exprs: Vec<&'a Expression>,
    filter: Option<ExprFilter>,
}

impl<'a> ExprCollector<'a> {
    fn new(filter: Option<ExprFilter>) -> Self {
        Self {
            exprs: Vec::new(),
            filter,
        }
    }

    fn visit_function(&mut self, function: &'a Function) {
        if let Some(body) = &function.body {
            self.visit_block(body);
        }
    }

    fn visit_block(&mut self, block: &'a Block) {
        for stmt in &block.stmts {
            self.visit_statement(stmt);
        }
        if let Some(expr) = &block.return_expr {
            self.visit_expr(expr);
        }
    }

    fn visit_statement(&mut self, stmt: &'a Statement) {
        match stmt {
            Statement::Decl(decl) => {
                if let Some(value) = &decl.value {
                    self.visit_expr(value);
                }
            },
            Statement::Expr(e) => {
                self.visit_expr(e);
            },
        }
    }

    fn visit_expr(&mut self, expr: &'a Expression) {
        if let Some(filter) = self.filter {
            if filter(expr) {
                self.exprs.push(expr);
            }
        } else {
            self.exprs.push(expr);
        }

        match expr {
            Expression::FunctionCall(call) => {
                for arg in &call.args {
                    self.visit_expr(arg);
                }
            },
            Expression::StructPack(pack) => {
                for (_, expr) in &pack.fields {
                    self.visit_expr(expr);
                }
            },
            Expression::Block(block) => {
                self.visit_block(block);
            },
            Expression::Assign(assign) => {
                self.visit_expr(&assign.value);
            },
            Expression::BinaryOperation(binop) => {
                self.visit_expr(&binop.lhs);
                self.visit_expr(&binop.rhs);
            },
            Expression::IfElse(if_expr) => {
                self.visit_expr(&if_expr.condition);
                self.visit_block(&if_expr.body);
                if let Some(else_expr) = &if_expr.else_expr {
                    self.visit_block(&else_expr.body);
                }
            },
            Expression::Reference(e) => {
                self.visit_expr(e);
            },
            Expression::Dereference(e) => {
                self.visit_expr(e);
            },
            Expression::MutReference(e) => {
                self.visit_expr(e);
            },
            Expression::Resource(rop) => {
                for e in rop.args.iter() {
                    self.visit_expr(e);
                }
            },
            Expression::VectorOperation(vop) => {
                for arg in &vop.args {
                    self.visit_expr(arg);
                }
            },
            Expression::VectorLiteral(VectorLiteral::Multiple(_, exprs)) => {
                for e in exprs {
                    self.visit_expr(e);
                }
            },
            Expression::Return(Some(e)) => {
                self.visit_expr(e);
            },
            Expression::Abort(e) => {
                self.visit_expr(e);
            },
            _ => (),
        }
    }
}

impl Function {
    pub fn all_exprs(&self, filter: Option<ExprFilter>) -> Vec<&Expression> {
        let mut collector = ExprCollector::new(filter);
        collector.visit_function(self);
        collector.exprs
    }
}
