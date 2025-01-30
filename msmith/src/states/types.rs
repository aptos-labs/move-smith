use crate::{
    move_ast::MoveAST,
    states::ids::Id,
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{GenLabel, Label, Labelled, Register, State, StateEntry, StateLabel};
use std::collections::BTreeMap;

pub trait Typed {
    fn ty(&self) -> Type;
}

#[derive(Debug, Default)]
pub struct TypePool {
    /// The defined Structs, Enums, and Type Parameters
    defined_types: BTreeMap<Id, Type>,

    /// The mapping from variable to type
    variable_types: BTreeMap<Id, Type>,
}

impl TypePool {
    pub fn random_defined_type(&self, u: &mut Unstructured) -> Result<Type> {
        let keys = self.defined_types.keys().cloned().collect::<Vec<_>>();
        let id = u.choose(&keys)?;
        Ok(self.defined_types.get(id).unwrap().clone())
    }

    pub fn random_primitive_type(&self, u: &mut Unstructured) -> Result<Type> {
        let ty = u.choose(&[
            Type::Primitive(Primitive::Bool),
            Type::Primitive(Primitive::U8),
            Type::Primitive(Primitive::U16),
            Type::Primitive(Primitive::U32),
            Type::Primitive(Primitive::U64),
            Type::Primitive(Primitive::U128),
            Type::Primitive(Primitive::U256),
        ])?;
        Ok(ty.clone())
    }
}

impl Labelled for TypePool {
    fn label() -> Label {
        StateLabel::new("TypePool").into()
    }
}

impl Register<StateEntry> for TypePool {
    fn register(&self) -> StateEntry {
        StateEntry {
            label: Self::label().try_into().unwrap(),
            generators: vec![
                // TODO
            ],
        }
    }
}

impl State<MoveAST> for TypePool {
    fn update_pre(&mut self, _u: &mut Unstructured, _generator: &GenLabel) {}

    fn update_post(&mut self, _u: &mut Unstructured, new_ast: &MoveAST, generator: &GenLabel) {
        if generator == &GenLabel::new_module_member_level("StructDef") {
            if let MoveAST::Struct(s) = new_ast {
                let ty = s.ty();
                self.defined_types.insert(s.name.clone(), ty);
            }
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum Type {
    Generic(GenericType),
    Primitive(Primitive),
    TypeParameter(TypeParameter),
    Concrete(ConcreteType),
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ConcreteType {
    pub mapping: BTreeMap<TypeParameter, Type>,
    pub ty: Box<Type>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum GenericType {
    Struct(StructType),
    Vector(VectorType),
    Tuple(TupleType),
    Reference(ReferenceType),
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum Primitive {
    Address,
    Bool,
    U8,
    U16,
    U32,
    U64,
    U128,
    U256,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct TypeParameter {
    pub name: Id,
    pub abilities: Vec<Ability>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct StructType {
    pub type_params: Vec<TypeParameter>, // Must be Type::TypeParameter
    pub fields: Vec<(Id, Type)>,
    pub abilities: Vec<Ability>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct TupleType {
    pub types: Vec<Type>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct VectorType {
    pub ty: Box<Type>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum ReferenceType {
    Immutable(Box<Type>),
    Mutable(Box<Type>),
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum Ability {
    Copy,
    Drop,
    Store,
    Key,
}
