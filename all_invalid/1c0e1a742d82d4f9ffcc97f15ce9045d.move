// # publish
address 0xCAFE {
    module ModuleA {
        struct S has copy, drop, store {
            x: u8,
            y: u16,
        }

        // This function declares multiple local variables using `let` statements at once
        // We simulate "declare" by a let statement with multiple vars
        public fun declare_locals(): (u8, u16) {
            let (a, b) = (10u8, 20u16);
            a + 1u8; // use to avoid unused warning
            b + 1u16;
            (a, b)
        }

        // Helper generic inline function to extract the 'x' field from vector<S> by reference
        public inline fun extract_x(v: &vector<S>): vector<u8> {
            let mut result = vector::empty<u8>();
            let len = vector::length(v);
            let mut i = 0;
            while (i < len) {
                let s_ref = &(*v)[i];
                vector::push_back(&mut result, s_ref.x);
                i = i + 1;
            }
            result
        }

        // Runner function for extract_x test
        public fun runner(): vector<u8> {
            let s1 = S { x: 11u8, y: 100u16 };
            let s2 = S { x: 22u8, y: 200u16 };
            let s3 = S { x: 33u8, y: 300u16 };
            let mut vec_s = vector::empty<S>();
            vector::push_back(&mut vec_s, s1);
            vector::push_back(&mut vec_s, s2);
            vector::push_back(&mut vec_s, s3);
            extract_x(&vec_s)
        }
    }
}
// # run 0xCAFE::ModuleA::declare_locals
// # run 0xCAFE::ModuleA::runner


// # publish
address 0xCAFE {
    module DuplicateFieldError {
        // This struct has duplicate fields, which should cause a compiler error
        // Duplicate field: 'a' declared twice with different types
        // Compiler should report errors specifying locations and messages

        // We deliberately place the duplicate fields to trigger errors
        struct Dup has copy, drop, store {
            a: u8,
            b: u16,
            a: u32, // duplicate field to trigger diagnostic error
        }
    }
}

// Featurres:
// de04319eb88235b3bcf9371bc1ad5660: Declare local variables in Move code using `declare` statements with a list of variables.
// e18360c3589143dfbf63f7f10456469e: Report a diagnostic error when duplicate fields are detected, including their locations and relevant messages.
// 8819767f4c31f2fc027a4533595af519: Test that mapping over a vector of struct elements by reference allows collecting their fields (keys) into a new vector using generic inline functions.
