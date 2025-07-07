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
// f2 is not imported; assuming it was intended in the test, but missing in the import list.
// We need to remove or comment out this line unless f2 is imported with correct use statement.
// let (a, b) = f2(20u16); // <-- Remove or fix if f2 is part of the module

// Since f2 was not imported, commenting out the line to prevent compilation error
// let (a, b) = f2(20u16);

// Assuming f3 is exported, instantiate a StructWithTypeParameter if needed
// Not shown in the initial code, so skipping. If needed, add import or usage accordingly

let s_instance = f3(15u16);
f4();
f5();
let c = f6(|x: u8| x + 1, 25u8);
f7();
example_vector_usage();

// Additional test: test enum and inline function annotations
// Matching on enum E with span info
let e_instance = E::V3 { a: true };
let result_match = match e_instance {
    E::V1 => 0,
    E::V2(x, y) => x + y,
    E::V3 { a } => if (a) { 42 } else { 0 },
};

// Inline function call with span info
// Corrected lambda syntax: define a local inline function
let lambda = |a: u8, b: u8| -> (u8, u8) {
    let c = a + b;
    let d = a * b;
    (c, d)
};
let (res_c, res_d) = lambda(2u8, 3u8);

// Final span-aware source access chains showing the merged import and usage
let span_source_integration = (
    vector::push_back(&mut vector::empty::<u8>(), 99u8),
    vector::pop_back(&mut vector::empty::<u8>())
);
