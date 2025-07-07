
//# publish
module 0xDEAD::TestModule {
    // A module to test reference safety, function calls, and advanced constructs
    use std::vector;

    // Constants to test numerical operations
    const MAX_U8: u8 = 255;
    const HALF_U8: u8 = 127;

    // Struct with a reference field to test reference safety
    struct RefHolder has store, key {
        // In actual Move, direct references aren't stored directly, so simulate via vector
        refs: vector<& u8>,
    }

    // Enum with nested vectors to test complex data types
    enum ComplexEnum has copy, drop {
        VariantA,
        VariantB(vector<u8>),
        VariantC {
            flag: bool
        }
    }

    // Function to test minimum version features: if-else, while, match, lambdas, generic structs
    public fun test_conditions_and_loops(x: u8): u8 {
        // Test if-else
        let _ = if (x > (HALF_U8)) {
            1u8
        } else {
            2u8
        };
        // Test while loop
        let result = x;
        while (result < (MAX_U8)) {
            result = result + 1;
        };
        // End with last expression as return value
        result
    }

    // Function to test match expression and generic struct instantiation
    public fun test_match_and_generic(e: ComplexEnum): u64 {
        let res = match (e) {
            ComplexEnum::VariantA => 100u64,
            ComplexEnum::VariantB(vec) => {
                let sum = vector::sum(&vec);
                sum as u64
            },
            ComplexEnum::VariantC { flag } => if (flag) { 1 } else { 0 },
        };
        res
    }

    // Function to test lambda with reference capture (simulate using copy lambda)
    public fun test_lambda_capture(x: u8): u8 {
        let lambda: |u8| -> u8 has copy = |a: u8| {
            let b = a + 1;
            b
        };
        lambda(x)
    }

    // Function to test vector operations and reference safety
    public fun test_vector_operations(): vector<u8> {
        let v = vector::empty<u8>();
        vector::push_back(&v, 10);
        vector::push_back(&v, 20);
        // Borrow and sum
        let sum = vector::borrow(&v, 0) + vector::borrow(&v, 1);
        sum
        // Return vector for further testing
        v
    }

    // Function to test advanced control flow with break and continue in loop
    public fun test_break_continue(): u8 {
        let x = 0u8;
        loop {
            if (x == 10) {
                break;
            };
            x = x + 1;
        };
        x
    }

    // Function to test nested references and mutable borrow safety
    public fun test_reference_safety(s: &mut u8) {
        *s = *s + 5;
    }

    // Run wrapper for a complex sequence
    public fun run_tests() {
        let _ = test_conditions_and_loops(100);
        let e = ComplexEnum::VariantB(vector::from_iter([1u8, 2u8, 3u8]));
        let _ = test_match_and_generic(e);
        let res_lambda = test_lambda_capture(7);
        let v = test_vector_operations();
        let result_break = test_break_continue();
        // Simulate mutable reference
        let mutable_val = 10u8;
        test_reference_safety(&mut mutable_val);
    }
}


//# run 0xDEAD::TestModule::run_tests


// Featurres:
// a9363c0147e2393028a12e3b3ac1a4ca: Fail the compilation process if any errors or diagnostics are encountered.
// c611388e3b33da0d46095b6087db59de: Display results of reference safety analysis directly in the bytecode annotations to spot unsafe reference usage.
// 81d7b796a8282833827611e111ad9db6: Use language constructs that require a minimum Move language version.
