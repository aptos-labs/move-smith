
//# publish
module 0xCAFE::ScopedFunctions {
    use std::signer;

    // 1. Function with explicit parameter and return types,
    // including inline function parameter accepting references.
    public fun apply_ref_lambda(x: &u8, f: |&u8, &u8| u8): u8 {
        // Apply lambda f on two references, both referring to x.
        f(x, x)
    }

    // 2. Function that invokes apply_ref_lambda with addition lambda for references.
    public fun test_add_refs(x: &u8, y: &u8): u8 {
        let add_refs: |&u8, &u8| u8 has copy+drop = |a: &u8, b: &u8| {
            *a + *b
        };
        apply_ref_lambda(x, add_refs) + *y
    }

    // 3. Nested pattern matching with inner scope bindings.
    public fun nested_match_test(flag: bool): u8 {
        let outer_var = 10u8;
        let result = match (flag) {
            true => {
                let inner_var = 5u8;
                let val = match (inner_var) {
                    5u8 => 20u8,
                    _ => 0u8,
                };
                val
            },
            false => 0u8,
        };
        // outer_var must remain 10 and unaffected by inner pattern matches.
        outer_var + result
    }

    // 4. Combined function testing inline ref lambda param and nested matches.
    public fun combined_test(x: &u8, y: &u8, flag: bool, f: |&u8, &u8| u8): u8 {
        let v_outer = 100u8;

        // Nested pattern match inside combined_test
        let intermediate = match (flag) {
            true => {
                let inner_val = 40u8;
                match (inner_val) {
                    40u8 => 1u8,
                    _ => 0u8,
                }
            },
            false => 0u8,
        };

        let applied = f(x, y);

        // outer variable v_outer must stay unchanged
        v_outer + intermediate + applied
    }

    // Runner function to trigger all tests without arguments
    public fun run_all_tests(): u8 {
        // 1 & 2 combined test
        let a = 4u8;
        let b = 6u8;
        let sum = test_add_refs(&a, &b);

        // 3. nested_match_test with true and false
        let nested_true = nested_match_test(true);
        let nested_false = nested_match_test(false);

        // 4. combined_test with addition lambda
        let add_lambda: |&u8, &u8| u8 has copy+drop = |p: &u8, q: &u8| {
            *p + *q
        };
        let combined = combined_test(&a, &b, true, add_lambda);

        // Return combined sum of results to produce u8 output
        sum + nested_true + nested_false + combined
    }
}


//# run 0xCAFE::ScopedFunctions::apply_ref_lambda --args 7u8  --signers 0xCAFE


//# run 0xCAFE::ScopedFunctions::test_add_refs --args 4u8 6u8


//# run 0xCAFE::ScopedFunctions::nested_match_test --args true


//# run 0xCAFE::ScopedFunctions::nested_match_test --args false


//# run 0xCAFE::ScopedFunctions::combined_test --args 3u8 5u8 true 0xCAFE::ScopedFunctions::apply_ref_lambda


//# run 0xCAFE::ScopedFunctions::run_all_tests


// Featurres:
// dd9e07f90e31992b3dbccf1579768cad: Declare function parameters and return types with proper syntax in function signatures.
// 5337a444a490888ba09bdef5995dc51b: Test that inline function parameters accepting references can be called with lambda functions and correctly perform addition on provided values.
// 7243deaa06ec1f8386be9e48903cc283: Test that pattern matching inside nested scopes does not leak or shadow variables, ensuring the outer variable value is preserved after the inner match expression.
