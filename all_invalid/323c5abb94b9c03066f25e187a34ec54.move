
//# publish
module 0xDEAF::AdvancedFeaturesTest {
    use std::vector;
    use std::signer;

    // Complex data structure for nested dot field access testing
    struct InnerStruct has copy, drop, store {
        a: u8,
        b: u16,
    }

    struct OuterStruct has copy, drop, store {
        inner: InnerStruct,
        label: vector<u8>,
    }

    // Function to get nested field data
    public fun get_inner_b(s: &OuterStruct): u16 {
        s.inner.b
    }

    // Utility to create OuterStruct for testing
    public fun create_outer_struct(a: u8, b: u16, label: vector<u8>): OuterStruct {
        OuterStruct {
            inner: InnerStruct {a, b},
            label,
        }
    }

    // Function with local variables inside and outside loops for variable persistence
    public fun variable_scope_test(): u64 {
        let outside = 10u64;
        let x = outside; // Shadow variable for inner loop
        let y: u64 = 0;
        for (i in 0..3) {
            let inside = i as u64; // Inner scope shadowing
            x = outside + i as u64;
            y = y + inside;
        };
        // verify that outside remains unchanged
        assert!(outside == 10u64, 100);
        // verify the final values
        assert!(x == 10u64 + 2, 101);
        assert!(y == 3u64, 102);
        y
    }

    // Internal function with internal visibility
    internal fun internal_helper(x: u8): u8 {
        x + 1
    }

    // Function to test internal visibility from within module
    public fun call_internal_helper(x: u8): u8 {
        internal_helper(x)
    }

    // Function attempting to call internal helper from outside (should fail if used outside)
    // This function is just for testing internal access; in real tests outside module should not access
    fun external_helper_call(x: u8): u8 {
        internal_helper(x)
    }

    // Specification block to ensure invariants, preconditions, postconditions
    spec {
        fun max_u64(a: u64, b: u64): u64 {
            pre {
                a <= 1000 && b <= 1000;
            }
            body {
                if (a > b) {
                    a
                } else {
                    b
                }
            }
            post {
                result >= a && result >= b;
            }
        }
    }

    // Function to test precondition, invariant, postcondition
    public fun spec_check(x: u64, y: u64): u64 {
        max_u64(x, y)
    }

    // Function demonstrating currying with closures
    public fun conditional_closure(flag: bool): |u8, u8| -> u8 {
        if (flag) {
            |a: u8, b: u8| {
                a + b
            }
        } else {
            |a: u8, b: u8| {
                a * b
            }
        }
    }

    // Function using the closure to evaluate different scenarios
    public fun evaluate_closure(flag: bool, a: u8, b: u8): u8 {
        let f = conditional_closure(flag);
        f(a, b)
    }

    // Function testing nested field access, variable scope, internal call, and currying together for robustness
    public fun integrated_test(): u64 {
        let outer = create_outer_struct(2, 300, b"test".to_vector());
        let nested_b = get_inner_b(&outer);
        let counter: u64 = 0;
        let sum: u64 = 0;
        let flag = true;

        while (counter < 3) {
            let local_var = counter as u8;
            let res = evaluate_closure(flag, local_var, 2);
            // access nested struct field in loop
            if (nested_b > 250) {
                sum = sum + res as u64;
            };
            counter = counter + 1;
        };
        // call internal function
        let check = call_internal_helper(5);
        assert!(check == 6, 200);
        sum
    }
}


//# run 0xDEAF::AdvancedFeaturesTest::variable_scope_test


//# run 0xDEAF::AdvancedFeaturesTest::call_internal_helper --args 42u8


//# run 0xDEAF::AdvancedFeaturesTest::get_inner_b --args 0


//# run 0xDEAF::AdvancedFeaturesTest::spec_check --args 900u64 800u64


//# run 0xDEAF::AdvancedFeaturesTest::evaluate_closure --args true 3u8 4u8


// Featurres:
// 78f8dc464195108ec06049bb15ab9fa2: Access nested fields of expressions using dot notation in Move code.
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
// 7f343e5b6a46a90c5e940d2d1b876be9: Test that function currying with different closures correctly evaluates conditional logic and produces expected results.
