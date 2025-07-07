
//# publish
module 0xCAFE::AdvancedFeaturesTest {
    use std::vector;
    use std::signer;

    // Deep nested structs
    struct Outer has store {
        inner: Inner,
        value: u64,
    }

    struct Inner has store {
        deep_field: Deep,
        flag: bool,
    }

    struct Deep has store {
        level1: Level1,
        level2: u8,
    }

    struct Level1 has store {
        inner_most: InnerMost,
    }

    struct InnerMost has store {
        data: vector<u8>,
        counter: u32,
    }

    // Internal function with restricted visibility
    internal fun internal_modify_deep_field(o: &mut Outer, new_value: u8) {
        o.inner.deep_field.level1.inner_most.data = vector::empty<u8>();
        vector::push_back(&mut o.inner.deep_field.level1.inner_most.data, new_value);
    }

    // Public function to create nested structure and modify deep field
    public fun create_and_modify() {
        let deep = Deep {
            level1: Level1 {
                inner_most: InnerMost {
                    data: vector::empty<u8>(),
                    counter: 0,
                },
            },
            level2: 42,
        };
        let inner_most = InnerMost {
            data: vector::empty<u8>(),
            counter: 0,
        };
        let inner = Inner {
            deep_field: deep,
            flag: true,
        };
        let outer = Outer {
            inner,
            value: 100,
        };

        // Modify deep nested field
        internal_modify_deep_field(&mut outer, 99);
        // Return the modified deep field data for validation
        let deep_field_data = &outer.inner.deep_field.level1.inner_most.data;
        deep_field_data
    }

    // Function with variable shadowing and nested loops
    public fun variable_shadowing_loop(flag_init: bool): u64 {
        let (mut x, mut y) = (0u64, 5u64);
        let y_shadow = 10u64;

        // Shadow 'y' inside while loop
        while (x < 3) {
            let y = x + y_shadow; // Shadow y
            // x = x + 1; // error: reassignment is illegal in this pattern (no mut)
            x = x + 1;
        };
        // The outer y remains unchanged, inner y is shadowed
        // Final x value
        x + y + y_shadow
    }

    // Function to test visibility restrictions (should produce compile error if uncommented)
    // public fun illegal_access() {
    //     internal_modify_deep_field(&mut Outer {...}, 1); // Should fail: internal function not accessible outside module
    // }

    // Specification: validate purity (simulate via a pure function)
    public fun pure_function_example(a: u64): u64 {
        a + 1
    }

    // Assume spec: pure functions should return consistent results
    public fun check_pure_consistency(x: u64): bool {
        let res1 = pure_function_example(x);
        let res2 = pure_function_example(x);
        res1 == res2
    }

    // Function demonstrating currying with closures
    public fun curry_add(y: u64): |u64| u64 {
        |x: u64| x + y
    }

    // Function with conditional evaluation involving variable shadowing
    public fun conditional_shadowed(x: u64, condition: bool): u64 {
        let result = if (condition) {
            let x = x + 1; // shadow outer x
            x * 2
        } else {
            x / 2
        };
        result
    }

    // Function calling nested functions, testing scope and deep access
    public fun complex_interaction(flag: bool): u64 {
        let add_five = curry_add(5);
        let val = if (flag) {
            let intermediate = add_five(10);
            intermediate + 100
        } else {
            let inner_closure = curry_add(2);
            inner_closure(20)
        };
        val
    }
}


//# run 0xCAFE::AdvancedFeaturesTest::create_and_modify


//# run 0xCAFE::AdvancedFeaturesTest::variable_shadowing_loop --args false


//# run 0xCAFE::AdvancedFeaturesTest::check_pure_consistency --args 12345u64


//# run 0xCAFE::AdvancedFeaturesTest::conditional_shadowed --args 4u64 true


//# run 0xCAFE::AdvancedFeaturesTest::conditional_shadowed --args 4u64 false


//# run 0xCAFE::AdvancedFeaturesTest::complex_interaction --args true


//# run 0xCAFE::AdvancedFeaturesTest::complex_interaction --args false


// Featurres:
// 78f8dc464195108ec06049bb15ab9fa2: Access nested fields of expressions using dot notation in Move code.
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
// 7f343e5b6a46a90c5e940d2d1b876be9: Test that function currying with different closures correctly evaluates conditional logic and produces expected results.
