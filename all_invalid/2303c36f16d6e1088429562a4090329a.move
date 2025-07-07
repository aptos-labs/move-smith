
//# publish
module 0xCAFE::AdvancedFeaturesTest {
    use std::signer;
    use std::vector;

    // Complex resource with nested fields to test dot notation access
    struct OuterResource has key {
        inner: InnerResource,
        status: u8,
        metadata: Metadata,
    }

    struct InnerResource has key {
        value1: u64,
        value2: bool,
    }

    struct Metadata {
        creator: address,
        description: vector<u8>,
        nested_meta: NestedMeta,
    }

    struct NestedMeta {
        version: u32,
        tags: vector<vector<u8>>,
    }

    // Internal function that should not be accessible outside the module
    fun internal_helper(x: u8): u8 {
        x + 1
    }

    // Public function with pre- and post-conditions
    public fun process_data(input: u8): u8
        /* @pre input <= 100 */
        /* @post result >= input */
    {
        // Perform some processing
        let result = input + 10;
        // ensure post-condition manually (assuming specification checks are enforced)
        assert!(result >= input, 999);
        result
    }

    // Function to test nested field access
    public fun get_nested_value(addr: address): u64 {
        let outer_ref: &OuterResource = borrow_global<OuterResource>(addr);
        let value: u64 = outer_ref.inner.value1;
        value
    }

    // Local variable shadowing test inside and outside loop
    public fun variable_shadowing_test() {
        let x = 5u8;
        let _ = if (x > 3) {
            let x = 10u8; // shadow outer x
            x
        } else {
            x
        };
        // After the if, x should still be 5
        assert!(x == 5u8, 1000);

        let counter = 0u8;
        loop {
            let counter = counter; // shadow mutable variable
            if (counter >= 3) {
                break;
            };
            counter = counter + 1;
            // Shadowed `counter` is local, outer remains same
        };
        // Outer counter remains unchanged
        assert!(counter == 0u8, 1001);
    }

    // Function with specification that should be valid
    public fun spec_function(x: u8): u8
        /* @pre x <= 50 */
        /* @post result >= x */
    {
        x + 20
    }

    // Currying-like functions: closure calls with conditional logic
    public fun curry_fn(flag: bool): |u8|u8 {
        if (flag) {
            |a: u8| a + 1
        } else {
            |a: u8| a * 2
        }
    }

    // Function that applies the closure
    public fun apply_closure(f: |u8|u8, value: u8): u8 {
        f(value)
    }

    // Address mapping: to test name resolution
    static ADDRESS_ALIAS: address = 0x100;
}


//# run 0xCAFE::AdvancedFeaturesTest::get_nested_value --args 0xCAFE

//# run 0xCAFE::AdvancedFeaturesTest::variable_shadowing_test

//# run 0xCAFE::AdvancedFeaturesTest::process_data --args 42u8

//# run 0xCAFE::AdvancedFeaturesTest::spec_function --args 25u8

//# run 0xCAFE::AdvancedFeaturesTest::apply_closure --args 0xCAFE::AdvancedFeaturesTest::curry_fn::true --args 7u8

//# run 0xCAFE::AdvancedFeaturesTest::apply_closure --args 0xCAFE::AdvancedFeaturesTest::curry_fn::false --args 7u8


// Featurres:
// 78f8dc464195108ec06049bb15ab9fa2: Access nested fields of expressions using dot notation in Move code.
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
// 7f343e5b6a46a90c5e940d2d1b876be9: Test that function currying with different closures correctly evaluates conditional logic and produces expected results.
// ab30c100cc87c3b942d32a1ee4b281bb: Use named address mapping to refer to addresses in your Move code
