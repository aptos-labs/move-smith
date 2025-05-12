use crate::{
    generators::{
        EnumGenerator, FunctionGenerator, ProducersGenerator, RunnersGenerator, StructGenerator,
    },
    move_ast::{Address, Command, MoveAST, MoveModule},
    states::{get_config, get_id_pool_mut, new_id_and_push_scope, pop_scope, Id, IdKind, Named},
};
use anyhow::{anyhow, Result};
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};
use hex;

#[derive(Default)]
pub struct ModuleGenerator;

impl LabelledGenerator for ModuleGenerator {
    fn label() -> GenLabel {
        GenLabel::new_top_level("ModuleGenerator")
    }
}

impl Register<GeneratorEntry> for ModuleGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>()
    }
}

impl Generator<MoveAST, AnyConstraint> for ModuleGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, _constraint: &AnyConstraint) -> bool {
        true
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        _constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let random_bytes: [u8; 32] = u.arbitrary()?;
        let hex_string = if random_bytes.iter().all(|&b| b == 0xFF) {
            "0xCAFE".to_string()
        } else {
            format!("0x{}", hex::encode(random_bytes).to_uppercase())
        };
        let (_, addr_scope) = get_id_pool_mut(env).new_address(&hex_string);
        let (name, _) = new_id_and_push_scope(env, IdKind::Module, &addr_scope);
        let address = Address(hex_string);

        let mut subtrees = vec![];

        let config = get_config(env);
        let num_structs = config.num_structs_in_module.select(u)?;
        let num_enums = config.num_structs_in_module.select(u)?;
        let num_funcs = config.num_functions_in_module.select(u)?;

        for _ in 0..num_structs {
            subtrees.push(Subtree::new_generator_subtree(
                StructGenerator::label(),
                AnyConstraint::new(),
            ));
        }

        for _ in 0..num_enums {
            subtrees.push(Subtree::new_generator_subtree(
                EnumGenerator::label(),
                AnyConstraint::new(),
            ));
        }

        for _ in 0..num_funcs {
            subtrees.push(Subtree::new_generator_subtree(
                FunctionGenerator::label(),
                AnyConstraint::new(),
            ));
        }

        subtrees.push(Subtree::new_generator_subtree(
            RunnersGenerator::label(),
            AnyConstraint::new(),
        ));

        subtrees.push(Subtree::new_generator_subtree(
            ProducersGenerator::label(),
            AnyConstraint::new(),
        ));

        let compose_constraint = AnyConstraint::new()
            .with("name", name)
            .with("address", address);

        Ok((subtrees, compose_constraint))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        pop_scope(env);
        let mut structs = vec![];
        let mut enums = vec![];
        let mut functions = vec![];
        let mut runners = vec![];
        for node in asts {
            match node {
                MoveAST::Struct(s) => structs.push(s),
                MoveAST::Enum(e) => enums.push(e),
                MoveAST::Function(f) => functions.push(f),
                MoveAST::Runners(rs) => {
                    runners.extend(rs.0);
                },
                MoveAST::Producers(ps) => {
                    functions.extend(ps.0);
                },
                _ => return Err(anyhow!("Unexpected AST node")),
            }
        }

        let runner_cmds = runners
            .iter()
            .map(|r| Command {
                full_name: r.full_name(),
            })
            .collect::<Vec<Command>>();
        functions.extend(runners);

        Ok(MoveModule {
            address: constraint.get::<Address>("address").unwrap().clone(),
            name: constraint.get::<Id>("name").unwrap().clone(),
            structs,
            enums,
            functions,
            cmds: runner_cmds,
        }
        .into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_movemodule().is_some()
    }
}
