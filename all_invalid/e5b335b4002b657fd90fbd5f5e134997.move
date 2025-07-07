use aptos_framework::{move_stdlib, aptos_framework};
use aptos_move_compiler::{Compiler, Flags};
use aptos_move_core_types::{
    language_storage::ModuleId,
    value::{MoveStruct, MoveValue},
};
use aptos_types::{
    account_address::AccountAddress,
    transaction::{Module, Transaction, Script},
};
use aptos_vm::{AptosVM, VMExecutor};
use move_binary_format::{file_format::CompiledModule};
use move_core_types::account_address::AccountAddress as MoveAccountAddress;
use std::fs;
use std::path::PathBuf;
use anyhow::Result;

pub fn transactional_test() -> anyhow::Result<()> {
    //
    // 1. Define struct variants with named attributes, names, and fields
    //
    // For Move, struct variants are typically enums in other languages, so in Move, 
    // we can define structs with ability to hold different data via structs with different fields.
    // Here, we'll define a Move module source with multiple named structs.
    //
    let source = r#"
    module 0x1::TestStructs {
        struct VariantA has store {
            x: u64,
            y: bool
        }
    
        struct VariantB has store {
            name: vector<u8>,
            value: u8
        }
    }
    "#;

    // Compile with aptos_move_compiler
    let mut compiler = Compiler::new(&Flags::testing());
    let compilation_result = compiler.build(source, "0x1::TestStructs.move")?;
    assert!(compilation_result.files.is_some());

    // Ensure compilation succeeded and that the module has the two structs
    // Struct names expected: VariantA and VariantB
    let modules = compilation_result
        .files
        .unwrap()
        .into_iter()
        .flat_map(|(_, m)| m.as_inner_modules().into_iter())
        .collect::<Vec<_>>();
    // Alternatively: 
    // The compilation_result.modules is available, each is a CompiledModule or Script

    let compiled_modules = compilation_result.modules;
    assert!(!compiled_modules.is_empty(), "No compiled modules found");

    let test_module = compiled_modules.iter()
        .find(|m| m.self_id().name().as_str() == "TestStructs")
        .expect("TestStructs module not found");

    // Check there are structs VariantA and VariantB
    let struct_names: Vec<_> = test_module.struct_defs()
        .iter()
        .map(|s| test_module.identifier_at(s.struct_handle.0).as_str())
        .collect();

    assert!(struct_names.contains(&"VariantA"), "VariantA struct not found");
    assert!(struct_names.contains(&"VariantB"), "VariantB struct not found");

    //
    // 2. Validate that the address assignment string is correctly formatted with exactly one '=' character.
    // For example: "0x1=TestAddress"
    //
    let valid_assignments = vec![
        "0x1=TestAddress",
        "0xABCDEF12345=MyModule",
    ];
    let invalid_assignments = vec![
        "0x1TestAddress",     // no '='
        "0x1==TestAddress",   // two '='
        "0x1=Test=Address",   // two '=' (multiple)
        "=TestAddress",       // starts with '=' but no address left
        "0x1=",               // empty right side
    ];

    fn validate_assignment(assign: &str) -> bool {
        let parts: Vec<_> = assign.split('=').collect();
        parts.len() == 2 && !parts[0].is_empty() && !parts[1].is_empty()
    }

    for assign in valid_assignments {
        assert!(validate_assignment(assign), "Valid assignment failed validation: {}", assign);
    }
    for assign in invalid_assignments {
        assert!(!validate_assignment(assign), "Invalid assignment passed validation: {}", assign);
    }

    //
    // 3. Deserialize a compiled Move module from a file.
    //
    // To test deserialization, first write out compiled module bytecode to a temp file and read.

    let out_dir = std::env::temp_dir();
    let module_path: PathBuf = out_dir.join("test_module.mv");

    // Serialize the compiled module bytes
    let module_bytes = test_module.serialize();

    // Write bytes to a file
    fs::write(&module_path, &module_bytes)?;

    // Read bytes from the file
    let read_bytes = fs::read(&module_path)?;

    // Deserialize module
    let deserialized_module = CompiledModule::deserialize(&read_bytes)
        .map_err(|e| anyhow::anyhow!("Failed to deserialize module: {:?}", e))?;

    assert_eq!(
        test_module.self_id(),
        deserialized_module.self_id(),
        "Deserialized module ID does not match"
    );

    //
    // Additionally, try running the compiled module on the VM - this validates compiled module and VM compatibility.
    //
    // Setup a VM and executor
    let aptos_vm = AptosVM::new();

    // Create a fake transaction publishing the module from 0x1
    let sender = AccountAddress::from_hex_literal("0x1").unwrap();

    let module_transaction = Transaction::Module(Module::new(module_bytes, None));
    let txn_data = module_transaction.clone().into_raw_transaction(sender);

    let mut state_view = aptos_vm.new_state_view();

    let execution_result = aptos_vm.execute_block(
        vec![txn_data.clone()],
        &mut state_view,
        &[],
    );

    assert!(
        execution_result.iter().all(|result| result.status().is_success()),
        "Module publishing transaction failed: {:?}",
        execution_result
    );

    // Done
    Ok(())
}

#[test]
fn test_transactional_test() {
    transactional_test().unwrap();
}

// Featurres:
// 0d49697b7af45dcb92e4c3f355a6c4cb: Define struct variants with named attributes, names, and fields.
// 38c8fed9c8f68f65a6ce8f0a9b4bc138:  Validate that the address assignment string is correctly formatted with exactly one '=' character.
// 2b30b1d02d5a7dd1436a0503aacee40a: Deserialize a compiled Move module from a file.
