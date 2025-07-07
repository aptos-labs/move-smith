
//# publish
module 0xCAFE::VariableReassignment {
    // Test variable initialization, reassignment, and returning final value.

    public fun reassign_vars_u8(): u8 {
        let x = 1u8;
        let x = 2u8; // reassigned
        let x = x + 3u8; // reassigned again
        x
    }

    public fun reassign_vars_tuple(): (u8, u8) {
        let a = 10u8;
        let b = 20u8;
        let (a, b) = (b, a); // swap by reassignment
        let (a, b) = (a + 1, b + 1);
        (a, b)
    }

    public fun multiple_reassign_with_if(cond: bool): u8 {
        let val = 5u8;
        let val = if (cond) {
            val + 10u8
        } else {
            val + 100u8
        };
        let val = val * 2u8;
        val
    }
}


//# run 0xCAFE::VariableReassignment::reassign_vars_u8


//# run 0xCAFE::VariableReassignment::reassign_vars_tuple


//# run 0xCAFE::VariableReassignment::multiple_reassign_with_if --args true


//# run 0xCAFE::VariableReassignment::multiple_reassign_with_if --args false



//# publish
module 0xCAFE::DestructuringAndMutRefs {
    use std::option;
    use std::signer;

    struct Inner has copy, drop {
        a: u8,
        b: u8,
    }

    struct Outer has store {
        i: Inner,
        flag: bool,
    }

    // Construct Outer by destructuring tuple to get &mut references to Inner fields, then modify
    public fun create_and_modify(): Outer {
        let i = Inner {a: 5u8, b: 10u8};
        let Inner {a: ref mut a_ref, b: ref mut b_ref} = &mut i;
        *a_ref = *a_ref + 1;
        *b_ref = *b_ref + 2;
        Outer {i, flag: true}
    }

    // Pattern match Outer and destructure Inner mutably, modify, then reconstruct Outer
    public fun modify_outer_inner(o: &mut Outer) {
        let Outer {i: ref mut inner_ref, flag} = o;
        let Inner {a: ref mut a_ref, b: ref mut b_ref} = inner_ref;
        *a_ref = *a_ref * 2;
        *b_ref = *b_ref * 3;
        *o = Outer {i: *inner_ref, flag};
    }

    public fun get_inner_values(o: &Outer): (u8, u8) {
        let Inner {a, b} = o.i;
        (a, b)
    }

    // Helper public function to test modify_outer_inner end-to-end
    public fun test_modify(): (u8, u8) {
        let o = create_and_modify();
        modify_outer_inner(&mut o);
        get_inner_values(&o)
    }
}


//# run 0xCAFE::DestructuringAndMutRefs::create_and_modify


//# run 0xCAFE::DestructuringAndMutRefs::test_modify



//# publish
module 0xCAFE::ErrorReporting {
    use std::signer;

    struct Val has store {
        v: u8,
    }

    public fun create_val(s: signer, v: u8) {
        let val = Val {v};
        move_to<Val>(&s, val);
    }

    // Attempt illegal mutable borrow that should cause VM error
    public fun illegal_mut_borrow(s: signer) {
        let v_ref1: &mut Val = borrow_global_mut<Val>(signer::address_of(&s));
        let v_ref2: &mut Val = borrow_global_mut<Val>(signer::address_of(&s)); // illegal second mutable borrow
        v_ref1.v = 1;
        v_ref2.v = 2;
    }

    // Attempt illegal reassignment of a copied value (illegal in some contexts)
    public fun illegal_reassign() {
        let x = 10u8;
        let mut_ref = &x;
        // The line below attempts to assign through immutable reference - should cause error
        // *mut_ref = 20u8; // Move disallows, uncommenting should cause error with precise location
        // Instead trigger error with abort
        abort 42;
    }
}


//# run 0xCAFE::ErrorReporting::create_val --signers 0xBABE --args 7u8


//# run 0xCAFE::ErrorReporting::illegal_mut_borrow --signers 0xBABE


//# run 0xCAFE::ErrorReporting::illegal_reassign


// Featurres:
// 838005fe9e63911ba064e01a593af04e: Test that a local variable can be reassigned and its updated value is returned correctly from a function.
// e9cdcefcd1f70fddde31fbaee0a020c1: Test destructuring assignment and mutable reference updates during struct construction and pattern matching.
// a1f708ae68250dbae03565bf8137ee04: Associate Move bytecode execution errors with precise code locations in your source files
