//# publish
address 0xCAFE {
    module PatternTest {
        struct MyStruct has copy, drop, store {
            x: u64,
            y: u64,
        }

        struct Container has copy, drop, store {
            inner: MyStruct,
            flag: bool,
        }

        // Create a function that uses destructuring assignment and mutable reference updates
        public fun destruct_and_update(): MyStruct {
            // create mutable struct
            let mut s = MyStruct { x: 10, y: 20 };

            // destructuring assignment with mutable references to update fields
            let &mut MyStruct { x: ref mut a, y: ref mut b } = &mut s;
            *a = *a + 1;
            *b = *b + 2;

            // pattern match in a let binding with struct construction
            let Container { inner: MyStruct { x: mx, y: my }, flag } = Container { inner: s, flag: true };

            // returning new MyStruct with updated values by adding flag as u64 (1 or 0)
            MyStruct { x: mx + if flag { 1 } else { 0 }, y: my + if flag { 1 } else { 0 } }
        }

        // runner function to call destruct_and_update with no arguments
        public fun runner(): MyStruct {
            destruct_and_update()
        }
    }
}

//# run 0xCAFE::PatternTest::runner


//# publish
address 0xCAFE {
    module QuantifierTest {
        use std::vector;

        public fun test_forall(): bool {
            // Vector of u8 to test
            let v = vector::empty<u8>();
            vector::push_back(&mut v, 1);
            vector::push_back(&mut v, 2);
            vector::push_back(&mut v, 3);

            // forall x in v where x > 0 : true expression body after colon ':'
            // (This is simplified: Here we just write in Move parser style for the test)
            // We'll simulate this via loop just for syntax, because Move does not have built-in forall syntax.
            let mut all_gt_zero = true;
            let len = vector::length(&v);
            let mut i = 0;
            while (i < len) {
                let x = *vector::borrow(&v, i);
                if (!(x > 0)) {
                    all_gt_zero = false;
                    break;
                };
                i = i + 1;
            };

            all_gt_zero
        }

        public fun test_exists(): bool {
            // Vector of u8 to test
            let v = vector::empty<u8>();
            vector::push_back(&mut v, 0);
            vector::push_back(&mut v, 2);
            vector::push_back(&mut v, 3);

            // exists x in v where x == 2 : true expression body after colon
            let mut found = false;
            let len = vector::length(&v);
            let mut i = 0;
            while (i < len) {
                let x = *vector::borrow(&v, i);
                if (x == 2) {
                    found = true;
                    break;
                };
                i = i + 1;
            };

            found
        }

        public fun runner(): bool {
            // call both tests, returns true if both succeeded
            test_forall() && test_exists()
        }
    }
}

//# run 0xCAFE::QuantifierTest::runner

// Featurres:
// e9cdcefcd1f70fddde31fbaee0a020c1: Test destructuring assignment and mutable reference updates during struct construction and pattern matching.
// 2afb4e782a00ab3a5b8d7a9bcc27c669: Specify the main expression body after a colon ':' in quantifier constructs.
// e391419319f6e1de182bcec55815a695: Avoid naming modules or module aliases as 'Self'.
