use crate::states::{
    ids::{Id, IdKind},
    types::{Ability, EnumVariantType, GenericType, StructType, Type, TypeParameter, Typed},
    ConcreteType, EnumType, FunctionType, Named, TupleType,
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
    Function(Function),
    Signature(Signature),
    Block(Block),
    Sequence(Sequence),
    Statement(Statement),
    Expression(Expression),
    Variable(Variable),
    Assignment(Assignment),
    NumberLiteral(NumberLiteral),
    Tuple(Tuple),
    FunctionCall(FunctionCall),
    Struct(Struct),
    StructInstantiation(StructInstantiation),
    StructDestructure(StructDestructure),
    Enum(Enum),
    EnumVariant(EnumVariant),
}

impl ASTNode for MoveAST {}

impl MoveAST {
    pub fn empty() -> Self {
        MoveAST::Program(Program { modules: vec![] })
    }
}

/// A program is a collection of modules, scripts, and transactional test runner commands
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Program {
    pub modules: Vec<MoveModule>,
    // pub scripts: Vec<Script>,
    // pub cmds: Vec<Command>,
}

/// A Move module
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct MoveModule {
    pub address: Address,
    pub name: Id,
    pub structs: Vec<Struct>,
    pub enums: Vec<Enum>,
    pub functions: Vec<Function>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Address {
    // Place holder for now
    pub name: Option<String>,
}

impl Default for Address {
    fn default() -> Self {
        Address {
            name: Some("0xCAFE".to_string()),
        }
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
                })
            })
            .collect();
        Type::Generic(GenericType::Enum(EnumType {
            name: self.name.clone(),
            type_params: vec![],
            variants,
            abilities: self.abilities.clone(),
        }))
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct TypeParameters {
    pub types: Vec<TypeParameter>,
}

impl Default for TypeParameters {
    fn default() -> Self {
        TypeParameters { types: vec![] }
    }
}

/// The definition of the whole function
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Function {
    pub signature: Signature,
    pub body: Block,
}

impl Typed for Function {
    fn ty(&self) -> Type {
        self.signature.ty()
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Signature {
    pub name: Id,
    pub type_params: TypeParameters,
    pub parameters: Vec<SingleVariable>,
    pub return_type: Type,
}

impl Signature {
    pub fn has_return(&self) -> bool {
        !self.return_type.is_unit()
    }
}

impl Typed for Signature {
    fn ty(&self) -> Type {
        Type::Generic(GenericType::Function(FunctionType {
            name: self.name.clone(),
            type_params: self.type_params.types.clone(),
            params: self.parameters.iter().map(|p| p.ty()).collect(),
            return_type: Box::new(self.return_type.clone()),
        }))
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Block {
    pub name: Id,
    pub sequences: Vec<Sequence>,
    pub return_expr: Option<Expression>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Sequence {
    pub statements: Vec<Statement>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum Statement {
    Let(Expression),
    Expression(Expression),
}

#[derive(Debug, Clone, PartialEq, Eq, EnumInto)]
pub enum Expression {
    StructInstantiation(StructInstantiation),
    StructDestructure(StructDestructure),
    Tuple(Tuple),
    Assignment(Assignment),
    Variable(Variable),
    NumberLiteral(NumberLiteral),
    FunctionCall(FunctionCall),
}

impl Typed for Expression {
    fn ty(&self) -> Type {
        match self {
            Expression::StructInstantiation(s) => s.ty(),
            Expression::StructDestructure(s) => s.ty(),
            Expression::Tuple(t) => t.ty(),
            Expression::Assignment(a) => a.ty(),
            Expression::Variable(v) => v.ty(),
            Expression::NumberLiteral(n) => n.ty(),
            Expression::FunctionCall(f) => f.ty(),
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct StructDestructure {
    pub struct_type: ConcreteType,
    pub new_vars: Vec<Option<SingleVariable>>,
}

impl Typed for StructDestructure {
    fn ty(&self) -> Type {
        Type::Concrete(self.struct_type.clone())
    }
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
pub struct Assignment {
    pub lhs: Box<Expression>,
    pub rhs: Box<Expression>,
}

impl Typed for Assignment {
    fn ty(&self) -> Type {
        Type::Unit
    }
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
        }
    }

    pub fn new_declare(name: &Id, typ: &Type) -> Self {
        SingleVariable {
            name: name.clone(),
            typ: typ.clone(),
            declare: true,
            show_type: true,
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
pub struct FunctionCall {
    pub func_type: FunctionType,
    pub arguments: Vec<Expression>,
}

impl Typed for FunctionCall {
    fn ty(&self) -> Type {
        self.func_type.return_type.as_ref().clone()
    }
}

impl Default for Program {
    fn default() -> Self {
        Program {
            modules: vec![MoveModule {
                address: Address::default(),
                name: Id::new_str("Module1", IdKind::Module),
                structs: vec![],
                enums: vec![],
                functions: vec![],
            }],
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
