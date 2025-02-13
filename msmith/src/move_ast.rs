use crate::states::{
    ids::{Id, IdKind},
    types::{Ability, GenericType, StructType, Type, TypeParameter, Typed},
    FunctionType,
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
    Struct(Struct),
    StructField(StructField),
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
    pub fields: Vec<StructField>,
}

impl Typed for Struct {
    fn ty(&self) -> Type {
        Type::Generic(GenericType::Struct(StructType {
            name: self.name.clone(),
            type_params: vec![],
            fields: self
                .fields
                .iter()
                .map(|f| (f.name.clone(), f.ty.clone()))
                .collect(),
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

/// A field in a struct
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct StructField {
    pub name: Id,
    pub ty: Type,
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
    pub parameters: Vec<Variable>,
    pub return_type: Option<Type>,
}

impl Typed for Signature {
    fn ty(&self) -> Type {
        Type::Generic(GenericType::Function(FunctionType {
            name: self.name.clone(),
            type_params: self.type_params.types.clone(),
            params: self.parameters.iter().map(|p| p.ty()).collect(),
            return_type: self.return_type.clone().map(Box::new),
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

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum Expression {
    Tuple(Tuple),
    Assignment(Assignment),
    Variable(Variable),
    NumberLiteral(NumberLiteral),
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Tuple {
    pub expressions: Vec<Expression>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Assignment {
    pub lhs: Box<Expression>,
    pub rhs: Box<Expression>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Variable {
    pub name: Id,
    pub typ: Type,
    pub declare: bool,
    pub show_type: bool,
}

impl Typed for Variable {
    fn ty(&self) -> Type {
        self.typ.clone()
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct NumberLiteral {
    pub value: BigUint,
    pub typ: Type,
}

impl Default for Program {
    fn default() -> Self {
        Program {
            modules: vec![MoveModule {
                address: Address::default(),
                name: Id::new_str("Module1", IdKind::Module),
                structs: vec![],
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
