//# publish
module 0xCAFE::SpecAndCopyMove {

    use std::signer;

    #[inline]
    public fun simple_add(a: u8, b: u8): u8 {
        a + b
    }

    #[inline]
    public fun copy_and_move_primitive(x: u8): (u8, u8) {
        let y = copy x;
        // move from copy y
        let z = y;
        // original x still usable
        (x, z)
    }

    struct CopyStruct has copy, drop, store {
        val: u64
    }

    #[inline]
    public fun copy_and_move_struct(s: CopyStruct): (CopyStruct, CopyStruct) {
        let s_copy = copy s;
        let moved = s_copy;
        (s, moved)
    }

    public fun run_copy_move() {
        let x: u8 = 42;
        let (_a, _b) = copy_and_move_primitive(x);

        let s = CopyStruct { val: 123456 };
        let (_c, _d) = copy_and_move_struct(s);
    }

    spec module {
        resource struct MyResource {
            val: u8,
        }

        invariant [1] forall r: MyResource, r.val < 100;

        function my_spec_fun(a: u8): bool {
            a < 50
        }
    }
}

//# run 0xCAFE::SpecAndCopyMove::copy_and_move_primitive --args 7u8

//# run 0xCAFE::SpecAndCopyMove::copy_and_move_struct --args 0xCAFE::SpecAndCopyMove::CopyStruct { val: 99u64 }

//# run 0xCAFE::SpecAndCopyMove::run_copy_move

// Featurres:
// b44775bbdd8e5ba940595bad7170c885: Group one or more specification block members inside a module-level spec block
// 393b3763c252c101134b3399f056c26b: Define functions with attributes that can be flattened and applied.
// 9af19ba210d3086ac523ddbde2e6d610: Test that a value can be copied and then moved from the copy, while still allowing the original value to be used, for both primitive types and structs with the copy ability.
