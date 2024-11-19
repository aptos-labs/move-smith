use crate::states::{
    ids::Id,
    types::{Ability, CompoundType, StructType, Type, Typed},
};
use conversion::VariantConversions;
use framework::ASTNode;

/// The flattened AST where each variant is a different type of Move AST node
/// This is created so that we can have a single type that all generators can compose
/// The VariantConversions implements
///     - TryInto from MoveAST to each variant
///     - From from each variant to MoveAST
#[derive(VariantConversions, Debug, Clone, PartialEq, Eq)]
pub enum MoveAST {
    Program(Program),
    MoveModule(MoveModule),
    StructDef(StructDef),
    Struct(Struct),
    FunctionDef(FunctionDef),
    Function(Function),
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
    pub struct_defs: Vec<StructDef>,
    pub structs: Vec<Struct>,
    pub function_defs: Vec<FunctionDef>,
    pub functions: Vec<Function>,
}

// The skeleton of a struct that contains only the name and abilities.
// Will be generated before the struct bodies for structs to reference each other.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct StructDef {
    pub name: Id,
    pub abilities: Vec<Ability>,
}

/// The definition of a struct
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Struct {
    pub name: Id,
    pub abilities: Vec<Ability>,
    pub fields: Vec<StructField>,
}

impl Typed for Struct {
    fn ty(&self) -> Type {
        Type::Compound(CompoundType::Struct(StructType {
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

/// A field in a struct
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct StructField {
    pub name: Id,
    pub ty: Type,
}

/// A function definition that contains only the function signature.
/// Will be generated before the function bodies for functions to call each other.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct FunctionDef {}

/// The definition of the whole function
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Function {}

// Test the conversion
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_conversions() {
        let program = Program {
            modules: vec![MoveModule {
                struct_defs: vec![],
                structs: vec![],
                function_defs: vec![],
                functions: vec![],
            }],
        };

        let ast: MoveAST = program.clone().into();
        let program2: Program = ast.try_into().unwrap();

        assert_eq!(program, program2);
    }
}

#[cfg(test)]
mod ast_tests {
    use super::*;

    #[test]
    fn test_conversions() {
        let program = Program {
            modules: vec![MoveModule {
                struct_defs: vec![],
                structs: vec![],
                function_defs: vec![],
                functions: vec![],
            }],
        };

        let ast: MoveAST = program.clone().into();
        let program2: Program = ast.try_into().unwrap();

        assert_eq!(program, program2);
    }
}
