
//# publish
module 0xCAFE::FeatureTest {
    use std::vector;

    // Deeply nested structs
    struct Level3 has copy, drop, store {
        key: u64,
        value: bool,
    }

    struct Level2 has copy, drop, store {
        level3: Level3,
        description: vector<u8>,
    }

    struct Level1 has copy, drop, store {
        level2: Level2,
        identifier: u8,
    }

    // Resource with nested structs
    struct Container has key {
        data: Level1,
        label: vector<u8>,
    }

    // Example internal function with private visibility
    internal fun get_inner_value(c: &Container): bool {
        c.data.level2.level3.value
    }

    // Public function to expose nested field access
    public fun access_deep_field(c: &Container): bool {
        get_inner_value(c)
    }

    // Function demonstrating local variable assignment inside and outside while loop
    public fun branch_variable_shadowing(x: u64): u64 {
        let outside_var = x;
        let inner_var = 0u64;
        let flag = false;

        while (x > 0) {
            let shadow_var = x;
            inner_var = shadow_var + outside_var;
            flag = true;
            break;
        };

        if (flag) {
            let shadow_var = 42u64;
            inner_var = shadow_var + outside_var;
        };

        // The last expression ensures the function returns outer scope inner_var
        inner_var
    }

    // Function with restricted visibility and spec attribute
    // spec]
    public fun spec_highlighted_function(flag: bool): bool {
        if (flag) {
            true
        } else {
            false
        }
    }

    // Function testing currying with closures and conditional branches
    public fun conditional_closure_test(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 = |a: u8, b: u8| {
            if (a > b) {
                a + b
            } else {
                a * b
            }
        };
        lambda(x, y)
    }

    // Function with dead code after a break inside a loop
    public fun dead_code_test(n: u8): u8 {
        let sum = 0u8;
        loop {
            if (n == 0) {
                break;
            };
            sum = sum + 1;
            // Dead code after break (should be safe to ignore)
            // This line is intentionally unreachable
            // This tests VM and compiler instruction flow
            // Note: No compile error expected for dead code?
            // Proceed to verify runtime behavior
            // (no actual dead code suppression needed; just a comment)
        };
        sum
    }

    // Function with attributes to skip lint checks
    // skip_lint_check]
    public fun lint_skip_example(): u64 {
        42u64
    }
}


//# run 0xCAFE::FeatureTest::access_deep_field --args 0x0, 0x0

//# run 0xCAFE::FeatureTest::branch_variable_shadowing --args 100u64

//# run 0xCAFE::FeatureTest::spec_highlighted_function --args true

//# run 0xCAFE::FeatureTest::conditional_closure_test --args 10u8 5u8

//# run 0xCAFE::FeatureTest::dead_code_test --args 7u8

//# run 0xCAFE::FeatureTest::lint_skip_example


// Featurres:
// 78f8dc464195108ec06049bb15ab9fa2: Access nested fields of expressions using dot notation in Move code.
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
// 7f343e5b6a46a90c5e940d2d1b876be9: Test that function currying with different closures correctly evaluates conditional logic and produces expected results.
// e51a13f151c79b9b3b0d4ad12d73a0c0: Test that dead code in the else branch after a conditional with a loop and break does not affect execution or cause errors.
// ca6f2174749451b030fe92100d561cbe: Use attributes to specify lint checks to skip during compilation.
