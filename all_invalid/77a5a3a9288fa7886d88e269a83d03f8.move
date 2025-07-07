// SPDX-License-Identifier: Apache-2.0
address 0x1 {

    module StructCopyTest {
        /// A simple struct with the `copy` ability
        struct CopyStruct has copy, drop, store {
            x: u64,
            y: u64,
        }

        /// A function to create a new CopyStruct
        public fun create(x: u64, y: u64): CopyStruct {
            CopyStruct { x, y }
        }

        /// Test function that reassigns a CopyStruct through multiple sequential let bindings
        /// and verifies it keeps original values.
        #[test]
        public fun test_copy_struct_reassignment() {
            let s1 = create(42, 24);
            let s2 = s1; // copy semantics, s1 remains usable if typed accordingly
            // reassign s3 from s2
            let s3 = s2;
            // reassign s4 from s3
            let s4 = s3;

            // Assert all have the same values
            assert!(s1.x == 42, 1);
            assert!(s1.y == 24, 2);

            assert!(s2.x == 42, 3);
            assert!(s2.y == 24, 4);

            assert!(s3.x == 42, 5);
            assert!(s3.y == 24, 6);

            assert!(s4.x == 42, 7);
            assert!(s4.y == 24, 8);
        }
    }
}

// Featurres:
// 48cab55f3e05916b57173fcd3516d703: Test that a struct with copy semantics can be safely reassigned through multiple sequential let bindings and still retain its original values.
// f37fe173f9d4b68fdd3a281e139f9295: Organize module members with proper syntax and attributes.
// 8883a1af851e0808c0c68c507b57c614: Write names (identifiers) as simple names (e.g., MyStruct) in your code to refer to types or functions directly.
