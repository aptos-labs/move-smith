// Testing module constants, packages with named addresses, and copy + move semantics

// #package
// name: TestPackage
// address_map:
//   RootAddr: 0xCAFE

//# publish
module 0xCAFE::ConstantsAndCopyMove {
    use std::signer;

    const CONST_U8: u8 = 42u8;
    const CONST_U64: u64 = 0xDEADBEEF;

    struct Copyable has copy, drop, store {
        val: u64,
    }

    /// Copies a u8 value, moves from the copy, and then uses the original copy to produce a result
    public fun copy_and_move_primitive(x: u8): u8 {
        let y = copy x;
        let z = y;
        // use original x to increment z
        z + x
    }

    /// Copies a struct (Copyable), moves from the copy, and then uses original copy to read its value again
    public fun copy_and_move_struct(): u64 {
        let orig = Copyable { val: CONST_U64 };
        let cpy = copy orig;
        let moved = cpy;
        // original struct is still usable here because orig was not moved
        orig.val + moved.val
    }

    /// Stores a Copyable struct under signer's address, then copies it and moves from the copy
    public fun store_and_test_copy_move(s: signer) {
        let obj = Copyable { val: 128u64 };
        move_to<Copyable>(&s, obj);

        let addr = signer::address_of(&s);
        let stored_ref: &Copyable = borrow_global<Copyable>(addr);

        let copied = copy *stored_ref;
        let moved = copied;
        // still can read stored_ref.val
        let _sum = stored_ref.val + moved.val;
    }

    // Runner function to exercise constants and copy+move funcs
    public fun runner(s: signer): u8 {
        let p = copy_and_move_primitive(CONST_U8);
        let q = copy_and_move_struct();
        store_and_test_copy_move(s);
        // just return p for runner, discarding q
        p
    }
}

//# run 0xCAFE::ConstantsAndCopyMove::copy_and_move_primitive --args 10u8

//# run 0xCAFE::ConstantsAndCopyMove::copy_and_move_struct

//# run 0xCAFE::ConstantsAndCopyMove::store_and_test_copy_move --signers 0xBEEF

//# run 0xCAFE::ConstantsAndCopyMove::runner --signers 0xBEEF

// Featurres:
// 92e0070943738d16812fa4208f5a1e8b: Define module constants within a module.
// c17a12b242a42c345e3c4c5630cdd985: Organize Move code into packages with named address mappings.
// 9af19ba210d3086ac523ddbde2e6d610: Test that a value can be copied and then moved from the copy, while still allowing the original value to be used, for both primitive types and structs with the copy ability.
