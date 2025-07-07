

// Import standard vector module
use std::vector;

// Define a generic struct with ability constraints for testing
// This struct will be used as a type parameter in functions
struct TestStruct<A: copy + drop + store> has copy, drop, store {
    value: u64,
}

// Higher-order function that accepts a lambda (inline function) and an argument
// It applies the lambda to the argument and returns the result
public fun apply_lambda<A: copy, B>(lambda: |A| -> B, arg: A): B {
    lambda(arg)
}

// Function that returns a lambda which adds 10 to its input
public fun get_adder_lambda(): |u64| -> u64 {
    |x: u64| { x + 10 }
}

// Function that produces a lambda operating on TestStruct with specific abilities
public fun get_struct_modifier(): |TestStruct<copy + drop + store>| -> TestStruct<copy + drop + store> {
    |t: TestStruct<copy + drop + store>| { TestStruct { value: t.value + 100 } }
}

// Test function that combines import, higher-order functions, and ability constraints
public fun test_combined_functionality(signer_addr: address) {
    // Instantiate a TestStruct with abilities
    let struct_instance = TestStruct { value: 42 };

    // Apply a lambda that adds 5 to a u64
    let result1 = apply_lambda(|x: u64| { x + 5 }, 15u64);
    assert!(result1 == 20, 101);

    // Get a lambda that adds 10
    let adder = get_adder_lambda();
    let result2 = adder(30);
    assert!(result2 == 40, 102);

    // Use higher-order to apply struct modifier lambda
    let struct_lambda = get_struct_modifier();
    let modified_struct = apply_lambda(struct_lambda, struct_instance);
    // Verify the modification
    assert!(modified_struct.value == 142, 103);

    // Test passing struct as a type parameter to a function, verifying abilities
    // Create a vector of the struct type
    let vec_structs = vector::empty<TestStruct<copy + drop + store>>();
    vector::push_back(&mut vec_structs, TestStruct { value: 200 });
    let first_struct = *vector::borrow(&vec_structs, 0);
    assert!(first_struct.value == 200, 104);
}


//# run 0xDEAD::test_combined_functionality --args 0xdeadbeef


// Featurres:
// b734fce120b912d4adf3ea9b0f3ca979: Include 'use' declarations inside your script to import modules or symbols.
// 91cc7e7428dc741e1a77399d225956a6: Test that higher-order functions with inline lambdas can be used as arguments and return values within other higher-order function calls.
// 8212f57517317a04d52ee13b80e49762: Apply ability constraints (like 'copy', 'drop', etc.) to struct type parameters in Move.
