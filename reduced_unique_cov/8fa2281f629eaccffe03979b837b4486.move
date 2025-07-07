
//# publish
module 0xCAFE::AdvancedTest {
    use std::signer;

    // 1. Test that Move function correctly adds two u8 before returning a specific value.
    public fun add_then_return_specific(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42u8
        } else {
            0u8
        }
    }

    // 2. Define function with lambda expressions
    public fun lambda_test(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    // 3. Function to test implicit fall-through to labels (simulated via blocks and control flow)
    public fun implicit_fallthrough(b_value: u8): u8 {
        let result = 0u8;
        // Label L1 simulated by a block
        {
            result = b_value;
        };
        // No branching instruction preceding this line,
        // thus implicitly fall-through from label L1.
        result + 1u8
    }

    // 4. Utilize binding mechanism to handle optional conversion results
    // For demonstration, try to convert u64 to u8 with binding
    public fun optional_conversion_binding(value: u64): u8 {
        let val_opt = u8::from_u64(value); // returns option<u8>
        match (val_opt) {
            option::Some(v) => v,
            option::None => 0u8,
        }
    }

    // 5. Test outer scope variables shadowed and mutated by closures and verify captures
    public fun outer_var_shadow_mutate(): u8 {
        let outer = 5u8;
        let closure: |()| u8 has copy+drop = || {
            let outer = 10u8; // shadows outer from outer scope
            outer
        };
        let closure_result = closure();
        outer = 7u8; // mutate outer after closure definition
        closure_result + outer
    }
}


//# run 0xCAFE::AdvancedTest::add_then_return_specific --args 5u8 8u8


//# run 0xCAFE::AdvancedTest::lambda_test --args 6u8 7u8


//# run 0xCAFE::AdvancedTest::implicit_fallthrough --args 10u8


//# run 0xCAFE::AdvancedTest::optional_conversion_binding --args 255u64


//# run 0xCAFE::AdvancedTest::optional_conversion_binding --args 256u64


//# run 0xCAFE::AdvancedTest::outer_var_shadow_mutate


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 30200a459a0d35d57c9c2ed06e33f6bd: Allow implicit fall-through to labels when a preceding instruction is not a branching instruction in Move code.
// 28f6378e8f1499a048358d41b4c775c9: Utilize the binding mechanism to handle optional conversion results when translating pattern bindings.
// 7ae320749aa1a3fa69ec63bdd6cf3ca6: Test that variables from the outer scope can be shadowed and mutated by closures passed to functions, verifying correct variable capture and assignment behavior.
