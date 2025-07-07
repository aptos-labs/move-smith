
//# publish
module 0xCAFE::DestructuringTest {
    struct MStruct has store {
        a: u8,
        b: u8,
    }

    public fun init_struct(): MStruct {
        MStruct { a: 10u8, b: 20u8 }
    }

    public fun destructure_and_mutate_reference(x: &mut MStruct) {
        // Correct way to mutate fields via mutable ref:
        // borrow fields mutably explicitly
        let a = &mut x.a;
        let b = &mut x.b;
        *a = *a + 1;
        *b = *b + 2;
    }

    public fun get_a_and_b(x: &MStruct): (u8, u8) {
        (x.a, x.b)
    }

    public fun runner() {
        let s = init_struct();
        destructure_and_mutate_reference(&mut s);
        let (a, b) = get_a_and_b(&s);
        // Assign each part separately to avoid tuple assignment error:
        let _a = a;
        let _b = b;
    }
}



//# run 0xCAFE::DestructuringTest::runner




//# publish
module 0xCAFE::AbortLogicTest {
    public fun abort_if_false(cond: bool) {
        if (!cond) {
            abort 777;
        };
    }

    public fun abort_if_false_and(cond_a: bool, cond_b: bool) {
        if (!(cond_a && cond_b)) {
            abort 778;
        };
    }

    public fun abort_if_true_or(cond_a: bool, cond_b: bool) {
        if (cond_a || cond_b) {
            abort 779;
        };
    }

    public fun runner_abort_logic() {
        abort_if_false(true);
        abort_if_false_and(true, true);
        // The following call aborts, so we avoid calling abort_if_true_or with true
        // and call with false to continue normal flow:
        abort_if_true_or(false, false);
    }
}



//# run 0xCAFE::AbortLogicTest::runner_abort_logic




//# publish
module 0xCAFE::StoredFunctionTest {
    use std::signer;

    struct StoredFunction has key, store { func: u8 }

    public fun init_stored_function(s: &signer) {
        let sf = StoredFunction { func: 23u8 };
        move_to(s, sf);
    }

    public fun call_stored_function(s: &signer): u8 acquires StoredFunction {
        let address = signer::address_of(s);
        let sf_ref = borrow_global<StoredFunction>(address);
        sf_ref.func
    }

    public fun runner(s: &signer) {
        init_stored_function(s);
        let x = call_stored_function(s);
        let _ = x;
    }
}



//# run 0xCAFE::StoredFunctionTest::runner --signers 0xDEAD
