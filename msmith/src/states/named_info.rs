use crate::{
    generators::{
        AssignmentGenerator, EnumGenerator, LetAssignGenerator, LetDeclGenerator,
        SignatureGenerator, StructGenerator,
    },
    move_ast::{
        Assignment, DotVariable, MatchArm, MoveAST, Pattern, PatternKind, SingleVariable,
        Statement, Variable,
    },
    states::{get_defined_vars_from_pattern, GenericType, Id, Named, Scope, Type, Typed},
};
use arbitrary::Unstructured;
use framework::{
    GenLabel, LabelledGenerator, LabelledState, Register, State, StateEntry, StateLabel,
};
use id_arena::Arena;
use std::collections::BTreeMap;

type NamedInfoIdx = id_arena::Id<NamedInfo>;

/// A NamedInfo could represent:
/// - Module level:
///     - Struct/Enum
///     - Constant (TODO)
///     - Function
/// - Variable
#[derive(Debug)]
pub struct NamedInfo {
    name: Id,
    typ: Type,

    dot_vars: Vec<DotVariable>,
    initialized: bool,
    moved: bool,
}

impl Typed for NamedInfo {
    fn ty(&self) -> Type {
        self.typ.clone()
    }
}

impl Named for NamedInfo {
    fn name(&self) -> Id {
        self.name.clone()
    }
}

impl NamedInfo {
    pub fn new(name: Id, typ: Type) -> Self {
        Self {
            name,
            typ,
            dot_vars: vec![],
            initialized: false,
            moved: false,
        }
    }

    pub fn new_with_dot_vars(name: Id, typ: Type, dot_vars: Vec<DotVariable>) -> Self {
        Self {
            name,
            typ,
            dot_vars,
            initialized: false,
            moved: false,
        }
    }

    pub fn set_initialized(&mut self) {
        self.initialized = true;
    }

    pub fn set_moved(&mut self) {
        self.moved = true;
    }
}

#[derive(Debug, Default)]
pub struct NamedInfoPool {
    map: BTreeMap<Id, NamedInfoIdx>,
    arena: Arena<NamedInfo>,
}

impl NamedInfoPool {
    pub fn add_new_uninitialized_variable(&mut self, name: Id, typ: Type) {
        self.add_new_variable(name, typ, false);
    }

    pub fn add_new_initialized_variable(&mut self, name: Id, typ: Type) {
        self.add_new_variable(name, typ, true);
    }

    pub fn add_new_variable(&mut self, name: Id, typ: Type, initialized: bool) {
        let dot_vars = self.get_all_dot_vars_from(&name, &typ);
        let mut info = NamedInfo::new_with_dot_vars(name.clone(), typ, dot_vars);
        if initialized {
            info.set_initialized();
        }
        let idx = self.arena.alloc(info);
        self.map.insert(name, idx);
    }

    pub fn add_new_type(&mut self, name: Id, typ: Type) {
        let info = NamedInfo::new(name.clone(), typ);
        let idx = self.arena.alloc(info);
        self.map.insert(name, idx);
    }

    pub fn get_info(&self, name: &Id) -> Option<&NamedInfo> {
        self.map.get(name).and_then(|idx| self.arena.get(*idx))
    }

    pub fn get_info_mut(&mut self, name: &Id) -> Option<&mut NamedInfo> {
        self.map.get(name).and_then(|idx| self.arena.get_mut(*idx))
    }

    /// Return all defined struct types that is accessible with in `scope`
    pub fn get_all_struct_types(&self, scope: &Scope) -> Vec<Type> {
        self.arena
            .iter()
            .filter_map(|(_, info)| {
                if !info.name.is_struct() {
                    return None;
                }

                if !scope.is_in_scope(&info.parent_scope()) {
                    return None;
                }

                Some(info.typ.clone())
            })
            .collect()
    }

    /// Return all defined struct types that is accessible with in `scope`
    pub fn get_all_enum_types(&self, scope: &Scope) -> Vec<Type> {
        self.arena
            .iter()
            .filter_map(|(_, info)| {
                if !info.name.is_enum() {
                    return None;
                }

                if scope.is_in_scope(&info.parent_scope()) {
                    return None;
                }

                Some(info.typ.clone())
            })
            .collect()
    }

    pub fn get_initialized_vars_of_type(&self, scope: &Scope, wanted: &Type) -> Vec<Variable> {
        self.arena
            .iter()
            .filter_map(|(_, info)| {
                if !info.name.is_var() {
                    return None;
                }

                if !scope.is_in_scope(&info.parent_scope()) {
                    return None;
                }

                if !info.initialized {
                    return None;
                }

                let mut vars = vec![];

                if info.ty() != *wanted {
                    return None;
                }

                vars.push(SingleVariable::new(&info.name(), &info.ty()).into());
                if matches!(
                    info.ty(),
                    Type::Generic(GenericType::Enum(_)) | Type::Generic(GenericType::Struct(_))
                ) {
                    for dot_var in &info.dot_vars {
                        if dot_var.ty() == *wanted {
                            vars.push(dot_var.clone().into());
                        }
                    }
                }

                Some(vars)
            })
            .flatten()
            .collect::<Vec<Variable>>()
    }

    pub fn get_callable_info(_scope: &Scope) -> Vec<NamedInfo> {
        unimplemented!()
    }

    fn get_all_dot_vars_from(&self, name: &Id, typ: &Type) -> Vec<DotVariable> {
        let root = DotVariable::new(vec![(name.clone(), typ.clone())]);
        Self::get_all_dot_vars_from_rec(root)
    }

    fn get_all_dot_vars_from_rec(root: DotVariable) -> Vec<DotVariable> {
        let curr_type = root.ty();
        let fields = match &curr_type {
            Type::Generic(GenericType::Struct(s)) if !s.positional => &s.fields,
            Type::Generic(GenericType::Enum(e)) => &e.get_possible_named_fields(),
            _ => return vec![],
        };

        let mut dot_vars = vec![];
        for (field_name, field_type) in fields {
            let new_dot_var =
                DotVariable::new_with_prefix(&root, (field_name.clone(), field_type.clone()));
            dot_vars.push(new_dot_var.clone());
            dot_vars.extend(Self::get_all_dot_vars_from_rec(new_dot_var));
        }
        dot_vars
    }

    pub fn save_type_info_from_ast(&mut self, new_ast: &MoveAST) {
        use MoveAST as M;
        match &new_ast {
            M::Struct(s) => {
                self.add_new_type(s.name.clone(), s.ty());
            },
            M::Enum(e) => {
                self.add_new_type(e.name.clone(), e.ty());
            },
            M::Signature(s) => {
                self.add_new_type(s.name.clone(), s.ty());

                for p in &s.parameters {
                    self.add_new_initialized_variable(p.name.clone(), p.ty());
                }
            },
            M::Statement(Statement::LetAssign(Assignment::AssignPattern(pat, _))) => {
                let vars = get_defined_vars_from_pattern(pat);
                for (id, ty) in vars {
                    self.add_new_initialized_variable(id, ty);
                }
            },
            M::Statement(Statement::LetDeclare(vars)) => {
                for v in vars {
                    self.add_new_uninitialized_variable(v.name.clone(), v.ty());
                }
            },
            M::MatchArm(MatchArm { pattern, .. }) => {
                let vars = get_defined_vars_from_pattern(pattern);
                for (id, ty) in vars {
                    self.add_new_initialized_variable(id, ty);
                }
            },
            _ => {},
        }
    }

    pub fn save_init_info_from_ast(&mut self, new_ast: &MoveAST) {
        match new_ast {
            MoveAST::Signature(sig) => {
                for param in &sig.parameters {
                    let info = self
                        .get_info_mut(&param.name)
                        .expect("Parameter info should have been created");
                    info.set_initialized();
                }
            },
            MoveAST::Assignment(Assignment::AssignPattern(pat, _)) => {
                let init_vars = get_initialized_vars_from_pattern(pat);
                for var in init_vars {
                    if let Some(info) = self.get_info_mut(&var) {
                        info.set_initialized()
                    }
                }
            },
            MoveAST::EnumMatch(em) => {
                for arm in &em.arms {
                    let vars = get_initialized_vars_from_pattern(&arm.pattern);
                    for var in vars {
                        let info = self
                            .get_info_mut(&var)
                            .expect("Variable info from assignment should have been created");
                        info.set_initialized();
                    }
                }
            },
            _ => {},
        }
    }
}

fn get_initialized_vars_from_pattern(pattern: &Pattern) -> Vec<Id> {
    match &pattern.body {
        PatternKind::Variable(Variable::SingleVariable(sv)) => vec![sv.name.clone()],
        PatternKind::Variable(Variable::DotVariable(_)) => vec![],
        PatternKind::Positional(pats) => pats
            .iter()
            .flat_map(|f| {
                if let Some(p) = f {
                    get_initialized_vars_from_pattern(p)
                } else {
                    vec![]
                }
            })
            .collect(),
        PatternKind::Named(s, _) => s
            .iter()
            .flat_map(|(_, p)| get_initialized_vars_from_pattern(p))
            .collect(),
        PatternKind::Wildcard => vec![],
    }
}

impl LabelledState for NamedInfoPool {
    fn label() -> StateLabel {
        StateLabel::new("NamedInfoPool")
    }
}

impl Register<StateEntry> for NamedInfoPool {
    fn register(&self) -> StateEntry {
        StateEntry {
            label: Self::label(),
            generators: vec![
                StructGenerator::label(),
                EnumGenerator::label(),
                SignatureGenerator::label(),
                LetAssignGenerator::label(),
                LetDeclGenerator::label(),
                AssignmentGenerator::label(),
            ],
        }
    }
}

impl State<MoveAST> for NamedInfoPool {
    fn update_pre(&mut self, _u: &mut Unstructured, _generator: &GenLabel) {}

    fn update_post(&mut self, _u: &mut Unstructured, new_ast: &MoveAST, _generator: &GenLabel) {
        self.save_type_info_from_ast(new_ast);
        self.save_init_info_from_ast(new_ast);
    }
}
