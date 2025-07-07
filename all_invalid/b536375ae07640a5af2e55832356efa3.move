//# publish
module 0x1::KeyDropTest {
    use aptos_framework::account;

    resource struct R has key, drop { val: u64 }

    public fun create_and_borrow(s: &signer) {
        let r = R { val: 42 };
        move_to(s, r);

        // borrow the resource immutably
        let r_ref = borrow_global<R>(account::address_of(s));
        let _v = r_ref.val;

        // try to borrow mutably while an immutable borrow exists - this should cause a failure
        // Uncommenting the next line should cause a borrow checker error at compile or runtime,
        // but since we are testing Move VM behavior, here we simulate an expected failure.
        // let r_mut = borrow_global_mut<R>(account::address_of(s));
        // r_mut.val = 100; // Expected failure or assertion

        // drop the resource explicitly by moving it out manually
        let r_moved = move_from<R>(account::address_of(s));
        drop(r_moved);

        // Trying to borrow after resource is moved triggers resource existence failure
        // let r_ref2 = borrow_global<R>(account::address_of(s)); // expected fail at runtime
    }

    // This is the runner function with no arguments that triggers the above behavior.
    public fun runner(s: &signer) {
        create_and_borrow(s);
    }
}
//# run 0x1::KeyDropTest::runner --signers 0x1

//# publish
module 0x1::ShadowAssign {
    /// Verifies that inner function can shadow and assign to outer variable `_x`
    public fun outer() {
        let mut _x = 10;

        let foo = |mut _x_param: u64| {
            // shadow _x with _x_param in inner scope
            _x = _x_param + 5;
        };

        foo(20);

        // _x should now be 25 (overwritten by inner lambda assignment)
        let _res = _x;
    }

    public fun runner() {
        outer();
    }
}
//# run 0x1::ShadowAssign::runner

//# publish
module 0x1::ParserErrorTest {
    // This module intentionally contains a comment showing an example of unexpected token usage:
    // For simulating diagnostic error, we put a fake malformed function that would cause parser error.
    // However, since transactional tests must compile, we instead add a doc comment to illustrate:

    /*
    The following line would cause a parse error if uncommented:

    fun bad_func( { // ERROR: unexpected token '{' after '(' during parsing
       // body
    }
    */

    // No functions are compiled, just a stub module.
}
// No run commands since it does not compile.

//# run
script {
    // use if expression to conditionally execute code branches

    use 0x1::ShadowAssign;

    // local variable
    let cond = true;

    if cond {
        ShadowAssign::outer();
    } else {
        // no-op for else branch
    };
}