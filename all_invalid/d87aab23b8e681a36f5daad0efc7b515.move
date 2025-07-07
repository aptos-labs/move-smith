//# publish
module 0xCAFE::AdvancedFeaturesTest {
    use std::vector;
    use std::signer;

    // A nested struct with multiple layers to test dot notation and nested field access
    struct Outer has copy, drop, store {
        inner: Inner,
        flag: bool,
    }

    struct Inner has copy, drop, store {
        value: u64,
        details: Details,
    }

    struct Details has copy, drop, store {
        description: vector<u8>,
        code: u32,
    }

    // A private function to test internal visibility
    fun internal_check(value: u64): bool {
        value % 2 == 0
    }

    // Public function for external calls that uses internal functions
    public fun check_nested_fields(x: Outer): bool {
        // Access nested fields via dot notation
        let Outer { inner: Inner { value: v, details: Details { description, code } }, flag: f } = &x;
        // Check nested values
        let is_even = internal_check(*v);
        // Perform additional checks
        is_even && *f && vector::length(description) > 0 && *code > 100u32
    }

    // Function to test local variable shadowing inside loops
    public fun shadowing_test(s: signer): bool {
        let flag: bool = false;
        let shadow_var: u8 = 0;
        let i: u8 = 0; // 'mut' needed for mutation
        // Loop with variable shadowing and cross-use
        while (i < 5) {
            let shadow_var: u8 = i; // shadow outside variable
            if (shadow_var == i) {
                let shadow_var: u8 = shadow_var; // shadowing inner var for mutation
                shadow_var = i + 1;
            };
            i = i + 1;
        };
        // Verify that outer shadow_var hasn't changed
        // and inner shadowing does not affect outer
        let outer_var = shadow_var;
        // Final check
        outer_var == 0
    }

    // Function to test spec functions with predicate correctness
    public fun spec_predicate(x: u64): bool ensures x % 2 == 0 {
        // Using if-else with pure computation
        if (internal_check(x)) {
            true
        } else {
            false
        }
    }

    // Function using closure / lambda with different paths to test efficiency and correctness
    public fun evaluate_with_closures(y: u8): u8 {
        let double = |a: u8| -> u8 {
            a * 2
        };
        let triple = |a: u8| -> u8 {
            if (a > 5) {
                a * 3
            } else {
                a * 2
            }
        };
        let val1 = double(y);
        let val2 = triple(y);
        val1 + val2
    }

    // Explicitly specify return type for a spec function with complex logic
    public fun complex_spec(val: u128): u128: u128 ensures val > 0 {
        let result = if (val > 1000) {
            val - 1000
        } else {
            val + 1000
        };
        result
    }

    // Function to test local variable post annotations
    public fun variable_post_test(s: signer): bool {
        let x: u64;
        let y: u64;
        // assign with post
        x = 10;
        y = x + 5;
        // variable shadowing
        let x: u64 = y * 2;
        // check post-conditions
        y == 15 && x == 30
    }

    // Function to test references (immutable & mutable)
    public fun reference_test(): (u64, u64) {
        let value: u64 = 42;
        let ref_value: &u64 = &value;
        // mutable reference
        let mutable_value: u64 = 55;
        let ref_mut_value: &mut u64 = &mut mutable_value;
        *ref_mut_value = *ref_value + 10;
        (*ref_value, *ref_mut_value)
    }
}

// Corrected run command with proper argument formatting
// No extra '//' comment inside the command
// Example:
/// run 0xCAFE::AdvancedFeaturesTest::check_nested_fields --args
/// run 0xCAFE::AdvancedFeaturesTest::shadowing_test --signers 0xBADD
/// run 0xCAFE::AdvancedFeaturesTest::spec_predicate --args 200u64
/// run 0xCAFE::AdvancedFeaturesTest::evaluate_with_closures --args 4u8
/// run 0xCAFE::AdvancedFeaturesTest::complex_spec --args 1500u128
/// run 0xCAFE::AdvancedFeaturesTest::variable_post_test --signers 0xFACE
/// run 0xCAFE::AdvancedFeaturesTest::reference_test
