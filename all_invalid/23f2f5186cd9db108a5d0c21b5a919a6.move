
//# publish
address 0xDEED {
    module LoopAndAccess { // Remove redundant address from module declaration
        use std::vector;

        // Struct for nested field demonstration
        struct NestedContainer has store, key {
            inner: InnerStruct,
        }

        struct InnerStruct has store {
            value: u64,
        }

        // Function to test for-loops with break and continue
        public fun test_loop_control(): u64 { // Specify return type explicitly
            let sum: u64 = 0; // Mutable variables need 'mut'
            let i: u64 = 0;     // Use 'mut' for mutable variables

            while (i < 10) {
                if (i == 5) {
                    break;
                };
                if (i % 2 == 0) {
                    i = i + 1;
                    continue;
                };
                sum = sum + i;
                i = i + 1;
            };
            // sum should be sum of odd numbers less than 5: 1 + 3 = 4
            assert!(sum == 4, 999);
            sum
        }

        // Function to access nested fields using dot notation
        public fun access_nested_field(container: &NestedContainer): u64 {
            container.inner.value
        }

        // Runner function to demonstrate nested field access
        public fun run_nested_access(): u64 { // Specify return type explicitly
            let inner = InnerStruct { value: 42 };
            let container = NestedContainer { inner };
            let val = access_nested_field(&container);
            // Validate nested access
            assert!(val == 42, 888);
            val
        }
    }
}



//# run 0xDEED::LoopAndAccess::test_loop_control



//# run 0xDEED::LoopAndAccess::run_nested_access