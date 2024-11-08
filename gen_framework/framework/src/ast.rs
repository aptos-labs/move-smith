use crate::{
    ids::{IDKind, ID},
    types::Type,
};

#[derive(Debug, Clone)]
pub struct Program {
    pub structs: Vec<ASTNode>,
    pub functions: Vec<ASTNode>,
}

impl Program {
    pub fn new() -> Self {
        Program {
            structs: vec![],
            functions: vec![],
        }
    }
}

#[derive(Debug, Clone)]
pub enum ASTNode {
    Struct(Struct),
    StructField(StructField),
    Function(Function),
    Block(Block),
    Statement(Statement),
    Declaration(Declaration),
    Expression(Expression),
    BinOp(BinOp),
    Conditional(Conditional),
}

impl ASTNode {
    pub fn empty() -> Self {
        ASTNode::Function(Function {
            name: ID::new_str("Empty", IDKind::Function),
            body: Box::new(ASTNode::Block(Block {
                body: vec![Statement::Expression(Expression::Variable)],
                ret: None,
            })),
        })
    }
}

#[derive(Debug, Clone)]
pub struct Struct {
    pub name: ID,
    pub fields: Vec<StructField>,
}

#[derive(Debug, Clone)]
pub struct StructField {
    pub name: ID,
    pub ty: Type,
}

#[derive(Debug, Clone)]
pub struct Function {
    pub name: ID,
    pub body: Box<ASTNode>,
}

#[derive(Debug, Clone)]
pub struct Block {
    pub body: Vec<Statement>,
    pub ret: Option<Box<Expression>>,
}

#[derive(Debug, Clone)]
pub enum Statement {
    Declaration(Declaration),
    Expression(Expression),
}

#[derive(Debug, Clone)]
pub struct Declaration {
    pub name: String,
    pub ty: Type,
}

#[derive(Debug, Clone)]
pub enum Expression {
    Variable,
    MemberAccess(MemberAccess),
    BinOp(BinOp),
    Conditional(Conditional),
}

#[derive(Debug, Clone)]
pub struct MemberAccess {
    pub parent: Box<Expression>,
    // Use Expression::Variable to represent a field access
    // TODO: maybe use ID
    pub field: Box<Expression>,
}

#[derive(Debug, Clone)]
pub struct BinOp {
    pub lhs: Box<Expression>,
    pub rhs: Box<Expression>,
    pub op: BinOpType,
}

#[derive(Debug, Clone)]
pub enum BinOpType {
    Add,
    Sub,
    Mul,
    Div,
    Mod,
    And,
    Or,
    Xor,
    Shl,
    Shr,
    Eq,
    Ne,
    Lt,
    Le,
    Gt,
    Ge,
}

#[derive(Debug, Clone)]
pub struct Conditional {
    pub condition: Box<Expression>,
    pub then_branch: Block,
    pub else_branch: Option<Block>,
}
