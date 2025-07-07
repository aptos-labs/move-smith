
// Also test member imports, usage of pragma, and span information in access chains.

/// Importing everything from 0xCAFE::MyModule with member imports
use 0xCAFE::MyModule::{
    f1,
    f3,
    f4,
    f5,
    f6,
    f7,
    example_vector_usage,
    S,
    StructWithTypeParameter,
    E,
    MODULE_MAGIC,
    // pragma and span annotations are to be tested at usage points
};
use 0xCAFE::StorageUsage::{
    store_at_signer_address,
    inspect_value,
    update_value,
    remove_at_signer_address,
    cross_module_call,
    several_args,
};
use std::signer;
use std::vector;

// Test the use of pragma annotations for spec and member attributes
// The span info should be traceable through the source locations in access chains

// Create signer variables for testing
let signer_b = signer::spec_from_address(@0xBEEF);
let signer_a = signer::spec_from_address(@0xAA01);

// Call store_at_signer_address, check span info
store_at_signer_address(signer_b, 5u8, 6u8);
// Call inspect_value, check span info
let (val_x, val_y) = inspect_value(signer_b);
// Call update_value, check span info
update_value(signer_b, 7u8, 8u8);
// Call inspect_value again to verify update
let (val_x2, val_y2) = inspect_value(signer_b);
// Call remove_at_signer_address, check span info
remove_at_signer_address(signer_b);

// Call cross_module_call function with span info
cross_module_call();

// Call several_args with different signers
let result_sum = several_args(signer_b, signer_a, 10u8, 11u8);

// Usage of imported functions from MyModule
let val_f1 = f1(3u8, true);
let (a, b) = f2(20u16);
let s_instance = f3(15u16);
f4();
f5();
let c = f6(|x: u8| x + 1, 25u8);
f7();
example_vector_usage();

// Additional test: test enum and inline function annotations
// Matching on enum E with span info
let e_instance = E::V3 { a: true };
let result_match = match (e_instance) {
    E::V1 => 0,
    E::V2(x, y) => x + y,
    E::V3 { a } => if (a) { 42 } else { 0 },
};
// Inline function call with span info
let (res_c, res_d) = lambda: |u8, u8| (u8, u8) = |a, b| {
    let c = a + b;
    let d = a * b;
    (c, d)
};
let (res_c2, res_d2) = lambda(2u8, 3u8);

// Final span-aware source access chains showing the merged import and usage
let span_source_integration = (vector::push_back(&mut vector::empty<u8>(), 99u8),
    vector::pop_back(&mut vector::empty<u8>()));


// Featurres:
// e0f723b44afdc4c1f59c12350179c24a: Import all public functions, structs, and constants from another module using member imports in the 'use' statement.
// afa4237eee3de0f7590f7d3a63c5656f: Annotate spec blocks and members with pragma properties for meta-information or tool directives.
// 260006ae11579981288fc0e379429921: Automatically tag and span name access chains with source location information.
