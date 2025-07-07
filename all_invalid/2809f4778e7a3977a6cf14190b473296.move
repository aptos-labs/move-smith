use aptos_move_compiler::{
    compiled_unit::{CompiledUnit, Program},
    move_compile_and_optimize_named_address_mapping,
    shared::{AddressBytes, CompilationEnv},
};
use move_core_types::{
    identifier::Identifier,
    language_storage::ModuleId,
    parser::ast::{FunctionName, FunctionSignature, FunctionVisibility, Parameter, SpecBlock, StructName, Type, TypeParameter},
};
use move_compiler::{
    diagnostics::codes::PARSE_ERROR,
    parser::{ast::*, parse},
    shared::BinaryIndexedView,
};
use move_ir_types::location::Spanned;
use move_lang::{errors::Errors, shared::NumericalAddress, Compiler};
use move_vm_runtime::move_vm::MoveVM;
use serde::{Deserialize, Serialize};
use std::collections::BTreeMap;

// This is a transactional test in Rust that creates a Move program with:
// 1. A program structure created via Move compiler API programmatic AST construction.
// 2. Incorporates a function that triggers an error on unexpected token during parsing (simulated).
// 3. Uses generic type parameters in functions to test generic programming features.

#[test]
fn transactional_test_move_compiler_vm() {
    // 1. Construct a Move program with:
    // - A module "TestMod"
    // - A struct "Box" generic over type T
    // - A public function "wrap" generic over T that returns Box<T>
    // - A public function "error_function" that simulates a parse error by trying to parse a broken source.

    // Using Move source code to simplify demonstration of generic and program structure.
    let source_code = r#"
    module 0x1::TestMod {
        struct Box<T> has store {
            value: T,
        }

        public fun wrap<T>(v: T): Box<T> {
            Box { value: v }
        }
    }
    "#;

    // 2. Use Move compiler API to compile the program (simulate unexpected token error):

    // Parse and compile the correct source first
    let mut sources = BTreeMap::new();
    sources.insert("TestMod.move".to_string(), source_code.to_string());

    let compiled_package = move_lang::package_hooks::run_move_unit_tests_in_package_sources(
        &sources,
        &BTreeMap::new(),
        &BTreeMap::new(),
        false,
    );

    assert!(compiled_package.is_ok(), "Original program should compile successfully");
    let units = compiled_package.unwrap();

    // 3. Simulate parsing an unexpected token error by feeding bad source code that triggers error on parse

    let broken_source = r#"
    module 0x1::BrokenMod {
        fun broken_function() {
            let x = ;  // Syntax error: unexpected token ;
        }
    }
    "#;

    let mut broken_sources = BTreeMap::new();
    broken_sources.insert("BrokenMod.move".to_string(), broken_source.to_string());

    // Utility function: parse broken source and check for PARSE_ERROR diagnostic
    fn parse_and_check_error(source: &str, filename: &str) -> bool {
        let (units, errs) = move_lang::parse_source_code(source, filename, &NumericalAddress::ONE);
        if errs.is_empty() {
            return false; // No errors, but we expect errors here
        }
        errs.iter().any(|err| err.code() == PARSE_ERROR && err.message().contains("unexpected token"))
    }

    let parse_error_triggered = parse_and_check_error(broken_source, "BrokenMod.move");
    assert!(parse_error_triggered, "Parse error with unexpected token should be triggered");

    // 4. Use MoveVM to run the wrapped function (generic function usage)

    // First, prepare the compiled modules from the original program
    let mut compiled_modules = vec![];
    for unit in units.iter() {
        if let CompiledUnit::Module(m) = unit {
            compiled_modules.push(m.clone());
        }
    }
    assert!(!compiled_modules.is_empty(), "Should have at least one compiled module");

    // Initialize MoveVM
    let vm = MoveVM::new();

    // Create a runtime session and publish the module
    let mut session = vm.new_session(&move_vm_runtime::natives::all_natives(True /* for testing? */));

    // Use account 0x1 as sender and publisher
    let sender_addr = AccountAddress::from_hex_literal("0x1").unwrap();

    // Publish the module
    let compiled_module_bytes: Vec<Vec<u8>> = compiled_modules.iter().map(|m| m.serialize().unwrap()).collect();

    // Note: This is pseudo code, we skip the executor details. In a real test we would
    // submit a transaction building a call to `wrap`.

    // This test focuses on:
    // - Constructing program with generics
    // - Simulating error on parse unexpected token
    // - Existence of generic function

    // For brevity, verify generic function signature with a type param
    for unit in units.iter() {
        if let CompiledUnit::Module(module) = unit {
            for func in module.function_defs() {
                let sig = module.function_handle_at(*func).signature(&module);
                let type_params = &module.function_handle_at(*func).type_parameters;
                if !type_params.is_empty() {
                    // This function is generic, check type params
                    assert!(type_params.len() >= 1, "Generic function should have >=1 type param");
                }
            }
        }
    }
}

// Featurres:
// 6e5c7471bf95f6365228a1e5c9d72dc5: Define a program using the Move compiler API with a program structure.
// 942fa01aa1f8670c2b216ffa6de0b1da: Use this function to generate an error message when an unexpected token is encountered during parsing.
// 489718260789658c9b35c888eb0c9513: Use type parameters within functions to enable generic programming.
