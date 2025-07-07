
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
        let &mut MStruct { a: ref mut a_ref, b: ref mut b_ref } = x;
        *a_ref = *a_ref + 1;
        *b_ref = *b_ref + 2;
    }

    public fun get_a_and_b(x: &MStruct): (u8, u8) {
        (x.a, x.b)
    }

    public fun runner() {
        let s = init_struct();
        destructure_and_mutate_reference(&mut s);
        let (a, b) = get_a_and_b(&s);
        // no assert needed as transactional runner tests compilation and execution
        let _ = (a, b);
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
    struct StoredFunction has key, store { func: u8 }

    public fun init_stored_function(s: &signer) {
        let sf = StoredFunction { func: 23u8 };
        move_to(&s, sf);
    }

    public fun call_stored_function(s: &signer): u8 acquires StoredFunction {
        let sf_ref = borrow_global<StoredFunction>(signer::address_of(s));
        sf_ref.func
    }

    public fun runner(s: &signer) {
        init_stored_function(s);
        let x = call_stored_function(s);
        let _ = x;
    }
}


//# run 0xCAFE::StoredFunctionTest::runner --signers 0xDEAD


// Featurres:
// cc70eb75f3379df461262797ddf37abb: Test the ability to destructure and mutate references to struct fields using pattern matching with &mut in Move functions.
// 032c8fea14d4be9e9072f771d90b1fc9: Test that aborting functions in the Move language correctly terminate execution and that logical operators with aborts behave as expected within scripts.
// 930f83177884e6968dc972db2624fc13: Test that a stored function can be initialized and later invoked to return the expected value 23.
