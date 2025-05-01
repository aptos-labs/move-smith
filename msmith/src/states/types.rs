use crate::{
    move_ast::{Pattern, PatternKind, Variable},
    states::{
        ids::{Id, Named},
        IdKind,
    },
};
use std::collections::{BTreeMap, BTreeSet};

pub trait Typed {
    fn ty(&self) -> Type;
}

pub fn get_defined_vars_from_pattern(pattern: &Pattern) -> Vec<(Id, Type)> {
    match &pattern.body {
        PatternKind::Variable(Variable::SingleVariable(sv)) => vec![(sv.name.clone(), sv.ty())],
        PatternKind::Variable(Variable::DotVariable(_)) => vec![], // Dot variable cannot be defined
        PatternKind::Positional(fields) => fields
            .iter()
            .flat_map(|f| {
                if let Some(p) = f {
                    get_defined_vars_from_pattern(p)
                } else {
                    vec![]
                }
            })
            .collect(),
        PatternKind::Named(pairs, _) => {
            let top_level = pairs
                .iter()
                .map(|(id, pat)| (id.clone(), pat.ty()))
                .collect::<Vec<(Id, Type)>>();
            let nested = pairs
                .iter()
                .flat_map(|(_, pat)| get_defined_vars_from_pattern(pat))
                .collect::<Vec<(Id, Type)>>();
            top_level.into_iter().chain(nested).collect()
        },
        PatternKind::Wildcard => vec![],
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Ord, PartialOrd)]
pub enum Type {
    Unit,
    Generic(GenericType),
    Primitive(Primitive),
    TypeParameter(TypeParameter),
    Concrete(ConcreteType),
}

impl Type {
    pub fn is_unit(&self) -> bool {
        self == &Type::Unit
    }

    pub fn is_generic(&self) -> bool {
        matches!(self, Type::Generic(_))
    }

    pub fn is_primitive(&self) -> bool {
        matches!(self, Type::Primitive(_))
    }

    pub fn is_type_parameter(&self) -> bool {
        matches!(self, Type::TypeParameter(_))
    }

    pub fn is_concrete(&self) -> bool {
        matches!(self, Type::Concrete(_))
    }

    pub fn is_generic_struct(&self) -> bool {
        matches!(self, Type::Generic(GenericType::Struct(_)))
    }

    pub fn is_concrete_struct(&self) -> bool {
        matches!(self, Type::Concrete(ConcreteType { typ, .. }) if typ.is_generic_struct())
    }

    pub fn is_struct(&self) -> bool {
        self.is_generic_struct() || self.is_concrete_struct()
    }

    pub fn as_struct(&self) -> Option<&StructType> {
        match self {
            Type::Generic(GenericType::Struct(s)) => Some(s),
            Type::Concrete(ConcreteType { typ, .. }) => typ.as_struct(),
            _ => None,
        }
    }

    pub fn is_generic_enum(&self) -> bool {
        matches!(self, Type::Generic(GenericType::Enum(_)))
    }

    pub fn is_concrete_enum(&self) -> bool {
        matches!(self, Type::Concrete(ConcreteType { typ, .. }) if typ.is_generic_enum())
    }

    pub fn is_enum(&self) -> bool {
        self.is_generic_enum() || self.is_concrete_enum()
    }

    pub fn is_generic_tuple(&self) -> bool {
        matches!(self, Type::Generic(GenericType::Tuple(_)))
    }

    pub fn is_concrete_tuple(&self) -> bool {
        matches!(self, Type::Concrete(ConcreteType { typ, .. }) if typ.is_generic_tuple())
    }

    pub fn is_tuple(&self) -> bool {
        self.is_generic_tuple() || self.is_concrete_tuple()
    }

    pub fn is_generic_function(&self) -> bool {
        matches!(self, Type::Generic(GenericType::Function(_)))
    }

    pub fn is_concrete_function(&self) -> bool {
        matches!(self, Type::Concrete(ConcreteType { typ, .. }) if typ.is_generic_function())
    }

    pub fn is_function(&self) -> bool {
        self.is_generic_function() || self.is_concrete_function()
    }

    pub fn as_function(&self) -> Option<&FunctionType> {
        if !self.is_function() {
            return None;
        }

        match self {
            Type::Generic(GenericType::Function(f)) => Some(f),
            Type::Concrete(ConcreteType { typ, .. }) => typ.as_function(),
            _ => None,
        }
    }

    /// Return whether the `other` type is included in `self`
    ///     - If `other` is the same as `self`, return true
    ///     - If `self` is a tuple or a function return type, check if `other` in the tuple
    pub fn include(&self, other: &Self) -> bool {
        if self == other {
            return true;
        }
        match self {
            Type::Generic(GenericType::Tuple(t)) => {
                for ty in &t.types {
                    if ty.include(other) {
                        return true;
                    }
                }
                false
            },
            Type::Generic(GenericType::Function(f)) => {
                (f.return_type.as_ref() == other) || f.return_type.include(other)
            },
            _ => false,
        }
    }
}

impl Named for Type {
    fn name(&self) -> Id {
        match self {
            Type::Generic(GenericType::Struct(s)) => s.name(),
            Type::Generic(GenericType::Enum(e)) => e.name(),
            Type::Concrete(c) => c.name(),
            _ => Id::new_without_scopes("TypeNamePlaceholder", IdKind::Var),
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Ord, PartialOrd)]
pub struct ConcreteType {
    pub mapping: BTreeMap<TypeParameter, Type>,
    pub typ: Box<Type>,
}

impl Named for ConcreteType {
    fn name(&self) -> Id {
        self.typ.name()
    }
}

impl ConcreteType {
    /// TODO: actually concretize types once type param is implemented
    pub fn get_concretized_type(&self) -> Type {
        self.typ.as_ref().clone()
    }

    pub fn new_with_empty_mapping(typ: &Type) -> Self {
        Self {
            mapping: BTreeMap::new(),
            typ: Box::new(typ.clone()),
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Ord, PartialOrd)]
pub enum GenericType {
    Struct(StructType),
    Enum(EnumType),
    EnumVariant(EnumVariantType),
    Vector(VectorType),
    Tuple(TupleType),
    Function(FunctionType),
    Reference(ReferenceType),
}

#[derive(Debug, Clone, PartialEq, Eq, Ord, PartialOrd)]
pub enum Primitive {
    Address,
    Bool,
    Number(NumberType),
}

#[derive(Debug, Clone, PartialEq, Eq, Ord, PartialOrd)]
pub enum NumberType {
    U8,
    U16,
    U32,
    U64,
    U128,
    U256,
}

#[derive(Debug, Clone, PartialEq, Eq, Ord, PartialOrd)]
pub struct TypeParameter {
    pub name: Id,
    pub abilities: Vec<Ability>,
}

#[derive(Debug, Clone, PartialEq, Eq, Ord, PartialOrd)]
pub struct StructType {
    pub name: Id,
    pub type_params: Vec<TypeParameter>,
    pub fields: Vec<(Id, Type)>,
    pub abilities: Vec<Ability>,
    pub positional: bool,
}

impl Named for StructType {
    fn name(&self) -> Id {
        self.name.clone()
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Ord, PartialOrd)]
pub struct EnumType {
    pub name: Id,
    pub type_params: Vec<TypeParameter>,
    pub variants: Vec<(Id, EnumVariantType)>,
    pub abilities: Vec<Ability>,
    /// For a type definition or declaration, this should be None to indicate that any variant is possible.
    /// e.g. if the enum type if used in function argument
    /// For an instantiate where the variant is known, the index of the variant should be set.
    pub variant_pos: Option<usize>,
}

impl EnumType {
    pub fn get_possible_variants(&self) -> Vec<(Id, EnumVariantType)> {
        match self.variant_pos {
            Some(idx) => vec![self.variants[idx].clone()],
            None => self.variants.clone(),
        }
    }

    /// Return a SET of all possible fields
    pub fn get_possible_named_fields(&self) -> Vec<(Id, Type)> {
        self.get_possible_variants()
            .iter()
            .flat_map(|(_, variant)| variant.get_all_named_fields())
            .collect::<BTreeSet<(Id, Type)>>()
            .into_iter()
            .collect()
    }

    /// Return a SET of valid fields that exists in all possible variants
    pub fn get_valid_named_fields(&self) -> Vec<(Id, Type)> {
        if self.variant_pos.is_some() {
            return self.get_possible_named_fields();
        }
        let mut counter = BTreeMap::new();
        for (_, variant) in &self.variants {
            for field in &variant.fields {
                let count = counter.entry(field.clone()).or_insert(0);
                *count += 1;
            }
        }

        let total_variants = self.variants.len();
        counter
            .into_iter()
            .filter_map(|(field, count)| {
                if count == total_variants {
                    Some(field)
                } else {
                    None
                }
            })
            .collect()
    }
}

impl Named for EnumType {
    fn name(&self) -> Id {
        if self.variant_pos.is_some() {
            let variant = self.variants[self.variant_pos.unwrap()].0.clone();
            let name = format!("{}::{}", self.name, variant);
            Id::new_without_scopes(&name, IdKind::Var)
        } else {
            self.name.clone()
        }
    }
}
#[derive(Debug, Clone, PartialEq, Eq, Ord, PartialOrd)]
pub struct EnumVariantType {
    pub name: Id,
    pub fields: Vec<(Id, Type)>,
    pub positional: bool,
}

impl EnumVariantType {
    pub fn get_all_named_fields(&self) -> Vec<(Id, Type)> {
        match self.positional {
            true => vec![],
            false => self.fields.clone(),
        }
    }

    pub fn wildcard_variant() -> Self {
        Self {
            name: Id::new_without_scopes("_", IdKind::Var),
            fields: vec![],
            positional: false,
        }
    }
}

impl Named for EnumVariantType {
    fn name(&self) -> Id {
        self.name.clone()
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Ord, PartialOrd)]
pub struct FunctionType {
    pub name: Id,
    pub type_params: Vec<TypeParameter>,
    pub params: Vec<Type>,
    pub return_type: Box<Type>,
    pub abilities: Vec<Ability>,
    pub is_func_value: bool,
}

impl Named for FunctionType {
    fn name(&self) -> Id {
        self.name.clone()
    }
}

impl FunctionType {
    pub fn has_return(&self) -> bool {
        !self.return_type.is_unit()
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Ord, PartialOrd)]
pub struct TupleType {
    pub types: Vec<Type>,
}

#[derive(Debug, Clone, PartialEq, Eq, Ord, PartialOrd)]
pub struct VectorType {
    pub ty: Box<Type>,
}

#[derive(Debug, Clone, PartialEq, Eq, Ord, PartialOrd)]
pub enum ReferenceType {
    Immutable(Box<Type>),
    Mutable(Box<Type>),
}

#[derive(Debug, Clone, PartialEq, Eq, Ord, PartialOrd)]
pub enum Ability {
    Copy,
    Drop,
    Store,
    Key,
}

impl Ability {
    pub fn all() -> Vec<Ability> {
        vec![Ability::Copy, Ability::Drop, Ability::Store, Ability::Key]
    }

    pub fn copy_drop() -> Vec<Ability> {
        vec![Ability::Copy, Ability::Drop]
    }
}
