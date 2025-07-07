address 0x1 {
    module TestModule {
        // 3: Declare module attributes and access modifiers
        // Using `address 0x1` to declare constants as module attributes (no #[attributes] as such in Move yet)
        const MAX_LIMIT: u64 = 100;
        const MODULE_NAME: &str = "TestModule";

        // Public struct with private field to test access modifiers
        struct Resource has key {
            // private field
            value: u64,
        }

        // Public constructor function
        public fun create_resource(initial: u64): Resource {
            assert!(initial <= MAX_LIMIT, 1);
            Resource { value: initial }
        }

        // Public function that modifies the resource - tests "variables modified in scope"
        public fun increment_resource(r: &mut Resource, delta: u64) {
            let old_value = r.value;
            // Variable possibly modified
            let new_value = old_value + delta;
            if (new_value > MAX_LIMIT) {
                r.value = MAX_LIMIT;
            } else {
                r.value = new_value;
            }
        }

        // 2: Support specification functions for both native and non-native Move functions

        // Spec function for non-native Move function increment_resource
        spec fun increment_spec(old_val: u64, delta: u64): u64 {
            let sum = old_val + delta;
            if (sum > MAX_LIMIT) {
                MAX_LIMIT
            } else {
                sum
            }
        }

        // Native function declaration
        native fun native_add(a: u64, b: u64): u64;

        // Spec function for native function - to integrate with native handling
        spec native fun native_add_spec(a: u64, b: u64): u64;

        // Non-native wrapper that calls native function
        public fun add_using_native(a: u64, b: u64): u64 {
            native_add(a, b)
        }

        // Test function exercising all features in a transaction
        #[test]
        public fun transactional_test_case() {
            // 1: Identify variables possibly modified within scope
            let mut r = create_resource(90);
            increment_resource(&mut r, 15);
            // after increment_resource, r.value should be MAX_LIMIT = 100
            assert!(r.value == MAX_LIMIT, 100);

            // 2: Call non-native function and check spec function equivalence
            let old_val = 20;
            let delta = 30;
            let result = increment_spec(old_val, delta);
            assert!(result == 50, 101);

            // Exercise native function and their spec
            let a = 40;
            let b = 10;
            let native_result = add_using_native(a, b);
            let spec_result = native_add_spec(a,b);
            // For testing purpose, assume native_add == native_add_spec
            assert!(native_result == spec_result, 102);

            // 3: Access module level attributes
            assert!(MODULE_NAME == "TestModule", 103);
            assert!(MAX_LIMIT == 100, 104);
        }
    }
}

// Featurres:
// 22d822f16140247516b77e9ba11bc63f: Identify variables that are possibly modified within a scope.
// aa114eeafd2809fc2a1dda9239d7374d: Support specification functions for both native and non-native Move functions, integrating with native function handling.
// 13b0a129fb397975e6a66241b40caab1: Declare module attributes and access modifiers.
