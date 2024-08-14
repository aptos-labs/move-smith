// Copyright (c) Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

//! Custom data structures for Move types.
//! Manages typing information during generation.

use crate::names::{Identifier, IdentifierKind as IDKind};
use std::collections::BTreeMap;

pub trait HasType {
    fn get_type(&self) -> Type;
}

/// Collection of Move types.
#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord)]
pub enum Type {
    // Basic types
    U8,
    U16,
    U32,
    U64,
    U128,
    U256,
    Bool,
    Address,
    Signer,
    // Compound types
    Vector(Box<Type>),
    Ref(Box<Type>),
    MutRef(Box<Type>),
    // Very limited use for tuple for now, only used with vector::index_of
    // TODO: allow all functions to return tuple
    Tuple(Vec<Type>),
    // Custom types
    Struct(StructType),
    StructConcrete(StructTypeConcrete),
    Function(Identifier),

    // Type Parameter
    TypeParameter(TypeParameter),
}

/// The type of a struct
#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord)]
pub struct StructType {
    pub name: Identifier,
    pub type_parameters: TypeParameters,
}

/// The concrete type of a generic struct
#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord)]
pub struct StructTypeConcrete {
    pub name: Identifier,
    pub type_args: TypeArgs,
}
/// A list of type parameters, used at struct or function definitions
#[derive(Debug, Clone, Default, PartialEq, Eq, PartialOrd, Ord)]
pub struct TypeParameters {
    pub type_parameters: Vec<TypeParameter>,
}

impl TypeParameters {
    pub fn find_idx_of_parameter(&self, param: &TypeParameter) -> Option<usize> {
        self.type_parameters
            .iter()
            .position(|x| x.name == param.name)
    }
}

/// A list of type arguments, used at struct initialization or function calls
#[derive(Debug, Clone, Default, PartialEq, Eq, PartialOrd, Ord)]
pub struct TypeArgs {
    pub type_args: Vec<Type>,
}

impl TypeArgs {
    pub fn get_type_arg_at_idx(&self, idx: usize) -> Option<Type> {
        self.type_args.get(idx).cloned()
    }
}

#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord)]
pub struct TypeParameter {
    pub name: Identifier,
    pub abilities: Vec<Ability>,
    pub is_phantom: bool,
}

impl Type {
    pub fn new_struct(name: &Identifier, type_parameters: Option<&TypeParameters>) -> Self {
        Type::Struct(StructType {
            name: name.clone(),
            type_parameters: type_parameters.cloned().unwrap_or_default(),
        })
    }

    pub fn new_concrete_struct(name: &Identifier, type_args: Option<&TypeArgs>) -> Self {
        Type::StructConcrete(StructTypeConcrete {
            name: name.clone(),
            type_args: type_args.cloned().unwrap_or_default(),
        })
    }
}

/// Abilities of a struct.
/// Key requires storage.
#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord)]
pub enum Ability {
    Copy,
    Drop,
    Store,
    Key,
}

impl Ability {
    pub const ALL: [Ability; 4] = [Ability::Copy, Ability::Drop, Ability::Store, Ability::Key];
    pub const NONE: [Ability; 0] = [];
    pub const PRIMITIVES: [Ability; 3] = [Ability::Copy, Ability::Drop, Ability::Store];
    pub const REF: [Ability; 2] = [Ability::Copy, Ability::Drop];
}

impl Type {
    /// Check if the type is numerical.
    pub fn is_numerical(&self) -> bool {
        matches!(
            self,
            Type::U8 | Type::U16 | Type::U32 | Type::U64 | Type::U128 | Type::U256
        )
    }

    /// Check if the type is boolean
    pub fn is_bool(&self) -> bool {
        matches!(self, Type::Bool)
    }

    /// Check if the type is numerical or boolean
    pub fn is_num_or_bool(&self) -> bool {
        self.is_numerical() || self.is_bool()
    }

    /// Check if the type is a reference
    pub fn is_ref(&self) -> bool {
        matches!(self, Type::Ref(_))
    }

    /// Check if the type is a mutable reference
    pub fn is_mut_ref(&self) -> bool {
        matches!(self, Type::MutRef(_))
    }

    /// Check if the type is a mutable or immutable reference
    pub fn is_some_ref(&self) -> bool {
        self.is_ref() || self.is_mut_ref()
    }

    pub fn is_vector(&self) -> bool {
        matches!(self, Type::Vector(_))
    }

    /// Check if the type is a type parameter
    pub fn is_type_parameter(&self) -> bool {
        matches!(self, Type::TypeParameter(_))
    }

    // Check if the type is concrete
    pub fn is_concrete(&self) -> bool {
        if self.is_num_or_bool() {
            return true;
        }

        if let Type::StructConcrete(_) = self {
            return true;
        }

        if let Type::Struct(st) = self {
            return st.type_parameters.type_parameters.is_empty();
        }

        false
    }

    /// Get an identifier for the type
    ///
    /// The returned name should be used to find the scope of this type
    /// from the IdentifierPool.
    pub fn get_name(&self) -> Identifier {
        match self {
            Type::U8 => Identifier::new_str("U8", IDKind::Type),
            Type::U16 => Identifier::new_str("U16", IDKind::Type),
            Type::U32 => Identifier::new_str("U32", IDKind::Type),
            Type::U64 => Identifier::new_str("U64", IDKind::Type),
            Type::U128 => Identifier::new_str("U128", IDKind::Type),
            Type::U256 => Identifier::new_str("U256", IDKind::Type),
            Type::Bool => Identifier::new_str("Bool", IDKind::Type),
            Type::Address => Identifier::new_str("Address", IDKind::Type),
            Type::Signer => Identifier::new_str("Signer", IDKind::Type),
            Type::Vector(t) => {
                Identifier::new(format!("Vector<{}>", t.get_name().name), IDKind::Type)
            },
            Type::Ref(t) => Identifier::new(format!("&{}", t.get_name().name), IDKind::Type),
            Type::MutRef(t) => Identifier::new(format!("&mut {}", t.get_name().name), IDKind::Type),
            Type::Tuple(ts) => {
                let mut name = String::from("(");
                for t in ts {
                    name.push_str(&t.get_name().name);
                    name.push_str(", ");
                }
                name.push(')');
                Identifier::new(name, IDKind::Type)
            },
            Type::Struct(st) => st.name.clone(),
            Type::StructConcrete(st) => st.name.clone(),
            Type::Function(id) => id.clone(),
            Type::TypeParameter(tp) => tp.name.clone(),
        }
    }
}

/// The data structure that keeps track of types of things during generation.
/// `mapping` maps identifiers to types.
/// The identifiers could include:
/// - Variables  (e.g. var1, var2)
/// - Function arguments (e.g. fun1::arg1, fun2::arg2)
/// - Struct fields (e.g. Struct1::field1, Struct2::field2)
/// - Type Parameter name
///
/// A key invariant assumed by the mapping is that each identifier is globally unique.
/// This is ensured by the IdentifierPool from the names module.
#[derive(Default, Debug, Clone)]
pub struct TypePool {
    mapping: BTreeMap<Identifier, Type>,

    /// A list of all available types that have been registered.
    /// This can be used to randomly select a type for a let binding.
    /// Currently all basic types are registered by default.
    /// All generated structs and type parameters are also registered.
    all_types: Vec<Type>,

    /// Keeps track of the concrete type for type parameters
    /// Maps type parameter names to a stack of concrete types
    parameter_types: BTreeMap<Identifier, Vec<Type>>,
}

impl TypePool {
    /// Create a new TypePool.
    pub fn new() -> Self {
        Self {
            mapping: BTreeMap::new(),
            all_types: vec![
                Type::U8,
                Type::U16,
                Type::U32,
                Type::U64,
                Type::U128,
                Type::U256,
                Type::Bool,
                // Type::Address,
                // Type::Signer,
            ],
            parameter_types: BTreeMap::new(),
        }
    }

    /// Keep track of the type of an identifier
    pub fn insert_mapping(&mut self, id: &Identifier, typ: &Type) {
        self.mapping.insert(id.clone(), typ.clone());
    }

    /// Register a new type
    pub fn register_type(&mut self, typ: Type) {
        self.all_types.push(typ);
    }

    /// Get the type of an identifier
    /// Returns `None` if the identifier is not in the mapping.
    pub fn get_type(&self, id: &Identifier) -> Option<Type> {
        self.mapping.get(id).cloned()
    }

    /// Get all registered types
    pub fn get_all_types(&self) -> Vec<Type> {
        self.all_types.clone()
    }

    /// Returns the identifiers from the input vector that have the given type.
    pub fn filter_identifier_with_type(&self, typ: &Type, ids: Vec<Identifier>) -> Vec<Identifier> {
        let mut res = Vec::new();
        for id in ids {
            if self.get_type(&id) == Some(typ.clone()) {
                res.push(id);
            }
        }
        res
    }

    pub fn register_concrete_type(&mut self, id: &Identifier, typ: &Type) {
        if self.parameter_types.contains_key(id) {
            self.parameter_types.get_mut(id).unwrap().push(typ.clone());
        } else {
            self.parameter_types.insert(id.clone(), vec![typ.clone()]);
        }
    }

    pub fn unregister_concrete_type(&mut self, id: &Identifier) {
        if let Some(types) = self.parameter_types.get_mut(id) {
            types.pop();
        } else {
            panic!("Cannot unregister type parameter: {:?}", id);
        }
    }

    pub fn get_concrete_type(&self, id: &Identifier) -> Option<Type> {
        if let Some(types) = self.parameter_types.get(id) {
            types.last().cloned()
        } else {
            None
        }
    }

    pub fn get_signer_var(&self) -> Identifier {
        Identifier::new_str("s", IDKind::Var)
    }

    pub fn get_signer_ref_var(&self) -> Identifier {
        Identifier::new_str("sref", IDKind::Var)
    }

    pub fn get_address_var(&self) -> Identifier {
        Identifier::new_str("ADDR", IDKind::Constant)
    }
}
