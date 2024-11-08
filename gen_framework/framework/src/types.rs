use crate::{
    ast::{ASTNode, Program},
    env::{State, StateT, STATES},
    ids::{IDKind, ID},
    label::{GenLabel, Label, Labelled, StateLabel},
};
use anyhow::Result;
use arbitrary::Unstructured;
use linkme::distributed_slice;
use std::collections::BTreeMap;

#[derive(Debug)]
pub struct TypePool {
    /// The defined Structs, Enums, and Type Parameters
    defined_types: BTreeMap<ID, Type>,

    /// The mapping from variable to type
    variable_types: BTreeMap<ID, Type>,
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
        Label::State(StateLabel::new("TypePool"))
    }
}

impl State for TypePool {
    fn update_pre(&mut self, _u: &mut Unstructured, _prog: &Program, _generator: &GenLabel) {}

    fn update_post(
        &mut self,
        u: &mut Unstructured,
        _prog: &Program,
        new_ast: &ASTNode,
        generator: &GenLabel,
    ) {
        if generator == &GenLabel::new_type_def("StructDef") {
            if let ASTNode::Struct(s) = new_ast {
                let mut fields = Vec::new();
                for field in &s.fields {
                    fields.push((field.name.clone(), field.ty.clone()));
                }
                self.defined_types.insert(
                    s.name.clone(),
                    Type::Compound(CompoundType::Struct(StructType {
                        type_params: vec![],
                        fields,
                        abilities: vec![],
                    })),
                );
            }
        }
    }

    fn as_any(&self) -> &dyn std::any::Any {
        self
    }

    fn as_any_mut(&mut self) -> &mut dyn std::any::Any {
        self
    }
}

#[distributed_slice(STATES)]
fn register_state() -> (StateLabel, StateT, Vec<GenLabel>) {
    (
        StateLabel::new("TypePool"),
        Box::new(TypePool {
            defined_types: BTreeMap::new(),
            variable_types: BTreeMap::new(),
        }),
        vec![GenLabel::new_type_def("StructDef")],
        // TODO: add higher level labels e.g. ALL_TYPE_DEF
    )
}

#[derive(Debug, Clone)]
pub enum Type {
    Compound(CompoundType),
    Primitive(Primitive),
    TypeParameter(ID),
}

#[derive(Debug, Clone)]
pub enum CompoundType {
    Struct(StructType),
    Vector(VectorType),
    Tuple(TupleType),
    Reference(ReferenceType),
}

#[derive(Debug, Clone)]
pub enum Primitive {
    Bool,
    U8,
    U16,
    U32,
    U64,
    U128,
    U256,
}

#[derive(Debug, Clone)]
pub struct StructType {
    pub type_params: Vec<Type>, // Must be Type::TypeParameter
    pub fields: Vec<(ID, Type)>,
    pub abilities: Vec<Ability>,
}

#[derive(Debug, Clone)]
pub struct TupleType {
    pub types: Vec<Type>,
}

#[derive(Debug, Clone)]
pub struct VectorType {
    pub ty: Box<Type>,
}

#[derive(Debug, Clone)]
pub enum ReferenceType {
    Immutable(Box<Type>),
    Mutable(Box<Type>),
}

#[derive(Debug, Clone)]
pub enum Ability {
    Copy,
    Drop,
    Store,
    Key,
}
