use crate::states::{
    ids::{Id, IdKind},
    types::{
        Ability, EnumVariantType, GenericType, Primitive, StructType, Type, TypeParameter, Typed,
    },
    ConcreteType, EnumType, FunctionType, Named, Scope, TupleType,
};
use enuminto::EnumInto;
use framework::ASTNode;
use num_bigint::BigUint;

/// The flattened AST where each variant is a different type of Move AST node
/// This is created so that we can have a single type that all generators can compose
/// The VariantConversions implements
///     - TryInto from MoveAST to each variant
///     - From from each variant to MoveAST
#[derive(EnumInto, Debug, Clone, PartialEq, Eq)]
pub enum MoveAST {
    Program(Program),
    MoveModule(MoveModule),
    Script(Script),
    Function(Function),
    Signature(Signature),
    Block(Block),
    Sequence(Sequence),
    Statement(Statement),
    Expression(Expression),
    Variable(Variable),
    Assignment(Assignment),
    NumberLiteral(NumberLiteral),
    Bool(Bool),
    BinOp(BinOp),
    UnOp(UnOp),
    Tuple(Tuple),
    Struct(Struct),
    StructInstantiation(StructInstantiation),
    Enum(Enum),
    EnumVariant(EnumVariant),
    EnumInstantiation(EnumInstantiation),
    Pattern(Pattern),
    EnumMatch(EnumMatch),
    MatchArm(MatchArm),
    FunctionValue(FunctionValue),
    Callable(Callable),
    CallArguments(CallArguments),
    FunctionCall(FunctionCall),
    Runners(Runners),
    Producers(Producers),
    Reference(Reference),
    Dereference(Dereference),
    IfElse(IfElse),
    Branch(Branch),
}

impl ASTNode for MoveAST {}

impl MoveAST {
    pub fn empty() -> Self {
        MoveAST::Program(Program {
            modules: vec![],
            scripts: vec![],
        })
    }
}

/// A program is a collection of modules, scripts, and transactional test runner commands
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Program {
    pub modules: Vec<MoveModule>,
    pub scripts: Vec<Script>,
}

/// A Move module
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct MoveModule {
    pub address: Address,
    pub name: Id,
    pub uses: Vec<Use>,
    pub structs: Vec<Struct>,
    pub enums: Vec<Enum>,
    pub functions: Vec<Function>,
    pub cmds: Vec<Command>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Runners(pub Vec<Function>);

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Producers(pub Vec<Function>);

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Use {
    pub name: Id,
    // pub use_all: bool,
    // pub alias: Option<Id>,
    // pub elements: Vec<Id>,
}
/// Currently only support the `//# run` command for a function with no arguments
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Command {
    pub full_name: Scope,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Script {
    pub main: Function,
}

#[derive(Default, Debug, Clone, PartialEq, Eq)]
pub struct Address(pub String);

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Bool {
    pub value: bool,
}

impl Typed for Bool {
    fn ty(&self) -> Type {
        Type::Primitive(Primitive::Bool)
    }
}

/// The definition of a struct
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Struct {
    pub name: Id,
    pub type_params: TypeParameters,
    pub abilities: Vec<Ability>,
    pub fields: Vec<SingleVariable>,
    pub positional: bool,
}

impl Typed for Struct {
    fn ty(&self) -> Type {
        Type::Generic(GenericType::Struct(StructType {
            name: self.name.clone(),
            type_params: vec![],
            fields: self
                .fields
                .iter()
                .map(|f| (f.name.clone(), f.ty().clone()))
                .collect(),
            abilities: self.abilities.clone(),
            positional: self.positional,
        }))
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Enum {
    pub name: Id,
    pub type_params: TypeParameters,
    pub abilities: Vec<Ability>,
    pub variants: Vec<EnumVariant>,
}

impl Named for Enum {
    fn name(&self) -> Id {
        self.name.clone()
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct EnumVariant {
    pub name: Id,
    pub fields: Vec<SingleVariable>,
    pub positional: bool,
}

impl Typed for Enum {
    fn ty(&self) -> Type {
        let variants = self
            .variants
            .iter()
            .map(|v| {
                (v.name.clone(), EnumVariantType {
                    name: v.name.clone(),
                    fields: v
                        .fields
                        .iter()
                        .map(|f| (f.name.clone(), f.ty().clone()))
                        .collect(),
                    positional: v.positional,
                })
            })
            .collect();
        Type::Generic(GenericType::Enum(EnumType {
            name: self.name.clone(),
            type_params: vec![],
            variants,
            abilities: self.abilities.clone(),
            variant_pos: None,
        }))
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct EnumInstantiation {
    pub enum_type: ConcreteType,
    pub variant_pos: usize,
    pub fields: Vec<(SingleVariable, Expression)>,
}

impl EnumInstantiation {
    pub fn get_variant_type(&self) -> &EnumVariantType {
        match self.enum_type.typ.as_ref() {
            Type::Generic(GenericType::Enum(e)) => &e.variants[self.variant_pos].1,
            _ => panic!("Expected Enum type"),
        }
    }
}

impl Named for EnumInstantiation {
    fn name(&self) -> Id {
        self.enum_type.name()
    }
}

impl Typed for EnumInstantiation {
    fn ty(&self) -> Type {
        Type::Concrete(self.enum_type.clone())
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct EnumMatch {
    pub enum_type: EnumType,
    pub expr: Box<Expression>,
    pub arms: Vec<MatchArm>,
    pub typ: Type,
}

impl Typed for EnumMatch {
    fn ty(&self) -> Type {
        self.typ.clone()
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct MatchArm {
    pub variant_type: EnumVariantType,
    pub pattern: Pattern,
    pub condition: Option<Expression>,
    pub body: Box<MoveAST>,
    pub typ: Type,
}

impl Typed for MatchArm {
    fn ty(&self) -> Type {
        self.typ.clone()
    }
}

#[derive(Default, Debug, Clone, PartialEq, Eq)]
pub struct TypeParameters {
    pub types: Vec<TypeParameter>,
}

/// The definition of the whole function
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Function {
    pub visibility: Visibility,
    pub inline: bool,
    pub signature: Signature,
    pub body: Block,
}

impl Named for Function {
    fn name(&self) -> Id {
        self.signature.name()
    }
}

impl Typed for Function {
    fn ty(&self) -> Type {
        self.signature.ty()
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum Visibility {
    Private,
    Public,
    PublicFriend,
    Package,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Signature {
    pub name: Id,
    pub type_params: TypeParameters,
    pub parameters: Vec<SingleVariable>,
    pub return_type: Type,
    pub abilities: Vec<Ability>,
    pub is_func_value: bool,
}

impl Signature {
    pub fn has_return(&self) -> bool {
        !self.return_type.is_unit()
    }
}

impl Named for Signature {
    fn name(&self) -> Id {
        self.name.clone()
    }
}

impl Typed for Signature {
    fn ty(&self) -> Type {
        Type::Generic(GenericType::Function(FunctionType {
            name: self.name.clone(),
            type_params: self.type_params.types.clone(),
            params: self.parameters.iter().map(|p| p.ty()).collect(),
            return_type: Box::new(self.return_type.clone()),
            abilities: self.abilities.clone(),
            is_func_value: self.is_func_value,
        }))
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Block {
    pub name: Id,
    pub sequences: Vec<Sequence>,
    pub return_expr: Option<Box<Expression>>,
}

impl Typed for Block {
    fn ty(&self) -> Type {
        if let Some(expr) = &self.return_expr {
            expr.ty()
        } else {
            Type::Unit
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Sequence {
    pub statements: Vec<Statement>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum Statement {
    LetDeclare(Vec<SingleVariable>),
    LetAssign(Assignment),
    Expression(Expression),
}

#[derive(Debug, Clone, PartialEq, Eq, EnumInto)]
pub enum Expression {
    StructInstantiation(StructInstantiation),
    EnumInstantiation(EnumInstantiation),
    Tuple(Tuple),
    Assignment(Assignment),
    Variable(Variable),
    NumberLiteral(NumberLiteral),
    Bool(Bool),
    FunctionCall(FunctionCall),
    EnumMatch(EnumMatch),
    BinOp(BinOp),
    UnOp(UnOp),
    FunctionValue(FunctionValue),
    Unit(Unit),
    Reference(Reference),
    Dereference(Dereference),
    Block(Block),
    IfElse(IfElse),
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Unit;

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct IfElse {
    pub condition: Box<Expression>,
    pub branches: Vec<Branch>,
    pub typ: Type,
}

impl Typed for IfElse {
    fn ty(&self) -> Type {
        self.typ.clone()
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Branch {
    pub body: Box<Expression>,
}

impl Typed for Branch {
    fn ty(&self) -> Type {
        self.body.ty()
    }
}

impl Typed for Expression {
    fn ty(&self) -> Type {
        match self {
            Expression::StructInstantiation(s) => s.ty(),
            Expression::EnumInstantiation(e) => e.ty(),
            Expression::Tuple(t) => t.ty(),
            Expression::Assignment(a) => a.ty(),
            Expression::Variable(v) => v.ty(),
            Expression::NumberLiteral(n) => n.ty(),
            Expression::Bool(b) => b.ty(),
            Expression::FunctionCall(f) => f.ty(),
            Expression::EnumMatch(m) => m.ty(),
            Expression::BinOp(b) => b.ty(),
            Expression::UnOp(u) => u.ty(),
            Expression::FunctionValue(f) => f.ty(),
            Expression::Unit(_) => Type::Unit,
            Expression::Reference(r) => r.ty(),
            Expression::Dereference(d) => d.ty(),
            Expression::Block(b) => b.ty(),
            Expression::IfElse(i) => i.ty(),
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct BinOp {
    pub op: BinOperator,
    pub typ: Primitive,
    pub left: Box<Expression>,
    pub right: Box<Expression>,
}

impl Typed for BinOp {
    fn ty(&self) -> Type {
        Type::Primitive(self.typ.clone())
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum BinOperator {
    // Numerical
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
    Lt,
    Gt,
    Leq,
    Geq,
    // Logical
    And,
    Or,
    Eq,
    Neq,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct UnOp {
    pub op: UnOperator,
    pub expr: Box<Expression>,
}

impl Typed for UnOp {
    fn ty(&self) -> Type {
        Type::Primitive(Primitive::Bool)
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum UnOperator {
    Not,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct StructInstantiation {
    pub struct_type: ConcreteType,
    pub abilities: Vec<Ability>,
    pub fields: Vec<(SingleVariable, Expression)>,
}

impl Named for StructInstantiation {
    fn name(&self) -> Id {
        self.struct_type.name()
    }
}

impl Typed for StructInstantiation {
    fn ty(&self) -> Type {
        Type::Concrete(self.struct_type.clone())
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Tuple {
    pub expressions: Vec<Expression>,
    pub show_type: bool,
}

impl Typed for Tuple {
    fn ty(&self) -> Type {
        let elem_types = self.expressions.iter().map(|e| e.ty()).collect();
        Type::Generic(GenericType::Tuple(TupleType { types: elem_types }))
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum Assignment {
    // Handles:
    //     - x = ...
    //     - x.y = ...
    //     - S1 { ... } = ...
    //     - (...) = ...
    AssignPattern(Pattern, Box<Expression>),
    // Handles:
    //     - *(...) = ...
    AssignDeref(Box<Expression>, Box<Expression>),
}

impl Typed for Assignment {
    fn ty(&self) -> Type {
        Type::Unit
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Pattern {
    pub typ: Type,
    pub body: PatternKind,
}

impl Typed for Pattern {
    fn ty(&self) -> Type {
        self.typ.clone()
    }
}

impl Pattern {
    pub fn new_single_var(name: &Id, typ: &Type) -> Self {
        Pattern {
            typ: typ.clone(),
            body: PatternKind::Variable(Variable::SingleVariable(SingleVariable::new(name, typ))),
        }
    }

    pub fn new_full_positional(typ: &Type, patterns: Vec<Pattern>) -> Self {
        Pattern {
            typ: typ.clone(),
            body: PatternKind::Positional(patterns.into_iter().map(Some).collect()),
        }
    }

    pub fn new_partial_positional(typ: &Type, patterns: Vec<Option<Pattern>>) -> Self {
        Pattern {
            typ: typ.clone(),
            body: PatternKind::Positional(patterns),
        }
    }

    pub fn new_named(typ: &Type, fields: Vec<(Id, Pattern)>, num_total_fields: usize) -> Self {
        Pattern {
            typ: typ.clone(),
            body: PatternKind::Named(fields, num_total_fields),
        }
    }

    pub fn new_wildcard(typ: &Type) -> Self {
        Pattern {
            typ: typ.clone(),
            body: PatternKind::Wildcard,
        }
    }

    pub fn is_wildcard(&self) -> bool {
        matches!(self.body, PatternKind::Wildcard)
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum PatternKind {
    Variable(Variable),
    Positional(Vec<Option<Pattern>>),
    /// Named fields should appear in the pattern and total number of fields
    /// If number of fields is less than the number of fields, dot dot will be added
    Named(Vec<(Id, Pattern)>, usize),
    Wildcard,
    Unit,
}

#[derive(Debug, Clone, PartialEq, Eq, EnumInto)]
pub enum Variable {
    SingleVariable(SingleVariable),
    DotVariable(DotVariable),
}

impl Typed for Variable {
    fn ty(&self) -> Type {
        match self {
            Variable::SingleVariable(v) => v.ty(),
            Variable::DotVariable(v) => v.ty(),
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct DotVariable {
    pub vars: Vec<(Id, Type)>,
}

impl Named for DotVariable {
    fn name(&self) -> Id {
        let ids = self
            .vars
            .iter()
            .map(|(id, _)| id.clone())
            .collect::<Vec<Id>>();
        Id::merge_into_dot_name(&ids)
    }
}

impl Typed for DotVariable {
    fn ty(&self) -> Type {
        self.vars.last().unwrap().1.clone()
    }
}

impl DotVariable {
    pub fn new(vars: Vec<(Id, Type)>) -> Self {
        DotVariable { vars }
    }

    pub fn new_with_prefix(prefix: &Self, var: (Id, Type)) -> Self {
        let mut vars = prefix.vars.clone();
        vars.push(var);
        DotVariable { vars }
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct SingleVariable {
    pub name: Id,
    pub typ: Type,
    pub declare: bool,
    pub show_type: bool,
    pub is_normal_function: bool,
}

impl Named for SingleVariable {
    fn name(&self) -> Id {
        self.name.clone()
    }
}

impl Typed for SingleVariable {
    fn ty(&self) -> Type {
        self.typ.clone()
    }
}

impl SingleVariable {
    pub fn new(name: &Id, typ: &Type) -> Self {
        SingleVariable {
            name: name.clone(),
            typ: typ.clone(),
            declare: false,
            show_type: false,
            is_normal_function: false,
        }
    }

    pub fn new_declare(name: &Id, typ: &Type) -> Self {
        SingleVariable {
            name: name.clone(),
            typ: typ.clone(),
            declare: true,
            show_type: true,
            is_normal_function: false,
        }
    }

    pub fn new_func_var(name: &Id, typ: &Type) -> Self {
        SingleVariable {
            name: name.clone(),
            typ: typ.clone(),
            declare: true,
            show_type: true,
            is_normal_function: true,
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct NumberLiteral {
    pub value: BigUint,
    pub typ: Type,
}

impl Typed for NumberLiteral {
    fn ty(&self) -> Type {
        self.typ.clone()
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Callable {
    pub expr: Box<Expression>,
    pub func_type: FunctionType,
}

impl Callable {
    pub fn get_arg_types(&self) -> Vec<Type> {
        self.func_type.params.clone()
    }

    pub fn get_func_type(&self) -> FunctionType {
        self.func_type.clone()
    }
}

impl Named for Callable {
    fn name(&self) -> Id {
        self.func_type.name()
    }
}

impl Typed for Callable {
    fn ty(&self) -> Type {
        self.func_type.return_type.as_ref().clone()
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct CallArguments(pub Vec<Expression>);

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct FunctionCall {
    pub callable: Callable,
    pub args: CallArguments,
}

impl Named for FunctionCall {
    fn name(&self) -> Id {
        self.callable.name()
    }
}

impl Typed for FunctionCall {
    fn ty(&self) -> Type {
        self.callable.ty()
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct FunctionValue {
    pub signature: Signature,
    pub body: Box<Block>,
}

impl Typed for FunctionValue {
    fn ty(&self) -> Type {
        self.signature.ty()
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum Reference {
    Mutable(Box<Expression>),
    Immutable(Box<Expression>),
}

impl Reference {
    pub fn get_expr(&self) -> &Expression {
        match self {
            Reference::Mutable(expr) => expr,
            Reference::Immutable(expr) => expr,
        }
    }
}

impl Typed for Reference {
    fn ty(&self) -> Type {
        match self {
            Reference::Mutable(expr) => expr.ty(),
            Reference::Immutable(expr) => expr.ty(),
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Dereference(pub Box<Expression>);

impl Dereference {
    pub fn get_expr(&self) -> &Expression {
        self.0.as_ref()
    }
}

impl Typed for Dereference {
    fn ty(&self) -> Type {
        self.0.ty()
    }
}

impl Default for Program {
    fn default() -> Self {
        Program {
            modules: vec![MoveModule {
                address: Address::default(),
                name: Id::new_str(
                    "Module1",
                    IdKind::Module,
                    Scope::default(),
                    Scope::default(),
                ),
                uses: vec![],
                structs: vec![],
                enums: vec![],
                functions: vec![],
                cmds: vec![],
            }],
            scripts: vec![],
        }
    }
}

// Test the conversion
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_conversions() {
        let program = Program::default();

        let ast: MoveAST = program.clone().into();
        let program2: Program = ast.try_into().unwrap();

        assert_eq!(program, program2);
    }
}
