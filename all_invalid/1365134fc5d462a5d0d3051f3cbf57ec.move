
//# publish
module 0xCAFE::AttributesAndCopyMove {
    use std::signer;
    use std::vector;

    // Feature 1: Restrict attribute constants to numeric values of type u64.
    const CONST_ONE: u64 = 1u64;
    const CONST_TWO: u64 = 2u64;
    const CONST_SUM: u64 = CONST_ONE + CONST_TWO;

    struct CopyType has copy, drop, store {
        val: u8
    }

    struct NonCopyType has drop, store {
        val: u8
    }

    // Feature 2: Define functions with attributes that can be flattened and applied.
    // test][trusted]
    public fun function_with_attributes(x: u8): u8 {
        x + 1
    }

    // test]
    // trusted]
    public fun function_with_multiple_attributes(y: u16): u16 {
        y + CONST_TWO as u16
    }

    public fun runner() {
        let a: u8 = 10;
        let b = function_with_attributes(a);
        let c = function_with_multiple_attributes(20u16);
        let _ = b + (c as u8);
    }

    // Feature 3: Test copying and moving

    public fun copy_and_move_primitive() {
        let x: u8 = 42;
        let y = copy x;
        let moved_y = y;
        let _ = x + moved_y;
    }

    public fun copy_and_move_struct() {
        let s0 = CopyType { val: 7 };
        let s1 = copy s0; // copy the struct
        let s2 = s1;      // move from the copy
        let _ = s0.val + s2.val;
    }

    public fun cant_copy_noncopy_struct() {
        let s = NonCopyType { val: 9 };
        // The following would fail if uncommented, thus test only compilation happy path
        // let s_copy = copy s;
        // let s_move = s_copy;
    }
}


//# run 0xCAFE::AttributesAndCopyMove::runner


//# run 0xCAFE::AttributesAndCopyMove::copy_and_move_primitive


//# run 0xCAFE::AttributesAndCopyMove::copy_and_move_struct


//# run 0xCAFE::AttributesAndCopyMove::cant_copy_noncopy_struct


// Featurres:
// 364ac54df3b9f6ae57e35e7dc9088e18: Restrict attribute constants to numeric values of type u64.
// 393b3763c252c101134b3399f056c26b: Define functions with attributes that can be flattened and applied.
// 9af19ba210d3086ac523ddbde2e6d610: Test that a value can be copied and then moved from the copy, while still allowing the original value to be used, for both primitive types and structs with the copy ability.
