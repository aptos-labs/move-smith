
//# publish
address 0xDEED {
    module 0xDEED::LoopAndAccess {
        use std::vector;

        // Struct for nested field demonstration
        struct NestedContainer has store, key {
            inner: InnerStruct,
        }

        struct InnerStruct has store {
            value: u64,
        }

        // Function to test for-loops with break and continue
        public fun test_loop_control() {
            let sum: u64 = 0;
            let i: u64 = 0;

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
        public fun run_nested_access() {
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

// Featurres:
// 4449dcffb07284a60f55e227a05c8659: Test the interaction of for-loops with break and continue statements within a Move script.
// 379517f1344308eeee004d118d4000bc: Access nested fields or properties using dot notation (e.g., `object.field` or `object.property`).
// 3a979246d73d638ae602541c01e69ff2: Define an 'address' block with associated modules in Move code.
