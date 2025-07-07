
//# publish
module 0xCAFE::AdvancedFeatureTest {
    use std::vector;
    use std::signer;

    // Define a nested structure to test nested field access
    struct OuterStruct has store, key {
        inner: InnerStruct,
        count: u64,
    }

    struct InnerStruct has store, key {
        data: vector<u8>,
        info: InfoStruct,
    }

    struct InfoStruct has store {
        flag: bool,
        value: u32,
    }

    // A module invariant (for simulation, just a function)
    public fun check_invariant(s: &OuterStruct): bool {
        s.count > 0 && s.inner.info.value >= 0
    }

    // Pure function for correctness check
    public fun compute_value(x: u16, y: u16): u32 {
        (x as u32) + (y as u32)
    }

    // Function to test nested field access and mutation
    public fun create_and_modify_nested_struct(): OuterStruct {
        let inner = InnerStruct {
            data: vector::empty<u8>(),
            info: InfoStruct { flag: true, value: 42 },
        };
        let outer = OuterStruct { inner, count: 1 };
        // Access nested fields with dot notation and modify
        let _ = outer.inner.info.value + 10;
        outer
    }

    // Function to test multi-level nested field access
    public fun get_deep_field(s: &OuterStruct): bool {
        s.inner.info.flag
    }

    // Function to test local variable shadowing in while loop
    public fun variable_shadowing_test(): u64 {
        let x = 0u64;
        let acc = 0u64;
        while (x < 5) {
            let x_shadow = x + 1; // shadow outer x
            let _ = x_shadow; // to avoid unused warning
            // For accumulation, use shadow variable
            acc = acc + x_shadow;
            // Update x for next iteration
            // x remains unchanged here
            // Since Move variables are immutable, need to reassign
            // But shadowing x won't change outer x
        };
        // After loop, outer x unchanged
        acc
    }

    // Function to test variable scope outside loop
    public fun scope_after_loop(): (u64, u64) {
        let x = 10u64;
        let y = 0u64;
        while (x > 0) {
            let _ = x - 1; // This shadowing x, but doesn't change outer x
        };
        // x and y should remain unchanged
        (x, y)
    }

    // Internal function not accessible outside module
    fun internal_helper(x: u8): u8 {
        x + 1
    }

    // Public interface for internal functions (simulate restriction)
    public fun call_internal_helper(val: u8): u8 {
        internal_helper(val)
    }

    // Function to test spec assertions
    public fun spec_test() {
        // Using spec assertion, in real specs would be @spec
        let a = 5u64;
        let b = 10u64;
        // Confirm sum is correct
        assert!(a + b == 15, 999);
    }

    // Function to test currying and conditional evaluation
    // Move does not support anonymous lambdas with captures directly.
    // To simulate, define two functions, then select based on flag
    public fun conditional_closure(flag: bool): (u8, u8) -> (u8, u8) {
        if (flag) {
            // Closure for true
            move |a: u8, b: u8| -> (u8, u8) {
                (a + 1, b + 1)
            }
        } else {
            // Closure for false
            move |a: u8, b: u8| -> (u8, u8) {
                (a - 1, b - 1)
            }
        }
    }

    // Function to test that byte strings are parsed and stored correctly
    public fun test_byte_strings(): vector<u8> {
        let s1 = b"test\0\xFF";
        let s2 = x"deadbeef";
        // Combine for testing
        let combined = vector::concat(&s1, &s2);
        combined
    }

    // Function to test parsing '<' as delimiter, especially with nested generics
    public fun parse_nested_generic_types(): vector<vector<u8>> {
        // Expect to parse something like vector<vector<u8>> properly
        let v: vector<vector<u8>> = vector::empty();
        vector::push_back(&mut v, b"abc");
        vector::push_back(&mut v, b"def");
        v
    }

    // Function to test that '>>' is treated correctly (not as a single token)
    public fun parse_with_double_arrow(): vector<(u8, u8)> {
        let pairs: vector<(u8, u8)> = vector::empty();
        vector::push_back(&mut pairs, (1, 2));
        vector::push_back(&mut pairs, (3, 4));
        pairs
    }

    // Explicit runner to expose multiple feature tests
    public fun run_all_tests() {
        let nested_struct = create_and_modify_nested_struct();
        let deep_flag = get_deep_field(&nested_struct);
        let shadow_result = variable_shadowing_test();
        let scope_result = scope_after_loop();

        // Call internal helper via public function
        let helper_result = call_internal_helper(10);
        // Spec test should succeed (simulate)
        spec_test();
        // Currying closure
        let curry_true = conditional_closure(true);
        let (a1, b1) = curry_true(10, 20);
        let curry_false = conditional_closure(false);
        let (a2, b2) = curry_false(10, 20);
        // Byte string testing
        let _ = test_byte_strings();
        // Nested generic type parsing
        let _ = parse_nested_generic_types();
        // Double arrow parsing
        let _ = parse_with_double_arrow();

        // Additional checks on nested structures
        assert!(nested_struct.count == 1, 888);
        // Verify nested field access
        assert!(deep_flag, 889);
        // Shadowing adds numbers
        assert!(shadow_result == 15, 890);
        // Scope test: outer x and y unchanged
        assert!(scope_result.0 == 10 && scope_result.1 == 0, 891);
        // Closure results
        assert!(a1 == 11 && b1 == 21, 892);
        assert!(a2 == 9 && b2 == 19, 893);
    }
}



//# run 0xCAFE::AdvancedFeatureTest::run_all_tests
