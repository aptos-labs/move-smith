//# publish
address 0xCAFE {
    module BoolAndAbilityChecks {
        use std::signer;

        // A struct that has copy and drop, store and key, no problem
        struct CopyDropKeyStruct has copy, drop, store, key {
            a: bool,
            b: bool,
        }

        // A struct that has copy and store, but no key
        struct CopyStoreStruct has copy, store {
            c: bool,
        }

        // A struct that is store only, not copy, not drop
        struct StoreOnlyStruct has store {
            d: u8,
        }

        // Create some bool literals and check their use
        public fun bool_literals(): bool {
            let t = true;
            let f = false;
            let res = t && !f;
            // return the result (should be true)
            res
        }

        // Function that moves (consumes) a StoreOnlyStruct, this checks that
        // move semantics work for non-copy types
        public fun consume_store_only(s: StoreOnlyStruct) {
            // no-op but consume s
            let StoreOnlyStruct { d } = s;
            // d is u8 (copy by default), just a dummy usage:
            let _ = d + 1u8;
        }

        // Function that tries to copy a CopyDropKeyStruct
        public fun copy_struct(s: CopyDropKeyStruct): CopyDropKeyStruct {
            // copy is fine as struct has copy ability
            let s_copy = copy s;
            s_copy
        }

        // Function testing drop by ignoring received value with drop ability
        public fun drop_struct(s: CopyDropKeyStruct) {
            // struct has drop ability so can be dropped/ignored safely
        }

        // Runner function to call the above to test proper ability usage
        public fun runner() {
            let s1 = CopyDropKeyStruct { a: true, b: false };
            let _ = copy_struct(s1);
            drop_struct(s1);

            let s2 = StoreOnlyStruct { d: 8u8 };
            consume_store_only(s2);

            let b = bool_literals();
            assert!(b, 1); // Just to exercise assert! macro, no output required
        }


        // Test that closures can capture and mutate variables from outer scopes
        // We simulate closures by passing inline functions and mutable captures

        // A function that accepts an inline function with mutable reference param
        public fun pass_mut_inline_func(mut_ref: &mut u64, f: inline fun(&mut u64)) {
            f(mut_ref);
        }

        // Use runner_closure to test this inline call form
        public fun runner_closure() {
            // mutable local variable
            let mut x = 0u64;

            // define an inline function that takes &mut u64 and mutates it
            let mutator: inline fun(&mut u64) = inline fun(r: &mut u64) {
                *r = *r + 42;
            };

            pass_mut_inline_func(&mut x, mutator);

            // after mutation, x should be 42
            assert!(*&x == 42, 2);
        }
    }
}
//# run 0xCAFE::BoolAndAbilityChecks::runner
//# run 0xCAFE::BoolAndAbilityChecks::runner_closure


//# run
script {
    use 0xCAFE::BoolAndAbilityChecks;

    fun main() {
        BoolAndAbilityChecks::runner();
        BoolAndAbilityChecks::runner_closure();
    }
}

// Featurres:
// bce76d7eb4e4a72455e298b5a2a97100: Write boolean literals 'true' and 'false'.
// 8342a5161de0c9cb2d493b1ee5f4bf40: Run ability checks to ensure proper use of copy, move, and drop operations based on type abilities.
// b7338995bef53aa6347c3d6dbb5eb91c: Test that closures can capture and mutate variables from their enclosing scope when passed as inline function parameters.
