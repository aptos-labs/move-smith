//# publish
module 0xCAFE::CallAndAbort {
    use std::error;
    use std::signer;

    /// A function that always aborts with code 42.
    public fun will_abort(): u64 {
        abort 42;
    }

    /// Conditionally abort if input is true, otherwise return 1.
    public fun conditional_abort(cond: bool): u64 {
        if (cond) {
            abort 100;
        };
        1
    }

    /// Sequence calls to will_abort and conditional_abort, will_abort first aborts.
    public fun abort_in_sequence(): u64 {
        // This will abort first, so second call won't happen
        will_abort();
        conditional_abort(false);
        0
    }

    /// Simple function returning a fixed number.
    public fun return_five(): u64 {
        5
    }

    /// Runner function that calls our other functions using 'call' expression.
    /// Just exercise all calls without type args.
    public fun runner(): u64 {
        let a = call 0xCAFE::CallAndAbort::return_five(); // should return 5

        // call conditional_abort with false (no abort)
        let b = call 0xCAFE::CallAndAbort::conditional_abort(false);

        // sequence call, will abort, won't return
        // we put this call in a block and catch abort with native abort code for testing VM handling,
        // but Move has no native catch so this will abort the txn
        // For transactional test, just call it.
        // let c = call 0xCAFE::CallAndAbort::abort_in_sequence();

        // Return the sum of first two calls
        a + b
    }
}

//# run 0xCAFE::CallAndAbort::runner --signers 0xCAFE

//# run 0xCAFE::CallAndAbort::will_abort --signers 0xCAFE

//# run 0xCAFE::CallAndAbort::conditional_abort --signers 0xCAFE --args true

//# run 0xCAFE::CallAndAbort::conditional_abort --signers 0xCAFE --args false

//# run 0xCAFE::CallAndAbort::abort_in_sequence --signers 0xCAFE

// Featurres:
// 957f4ac0040e1148684d1fb2cc2c2abb: Call functions and methods using the `call` expression, specifying the function name, call kind, optional type arguments, and argument list.
// 5f7075a36d764abe5db46b89ed424a8e: Test that the Move module correctly handles aborts within functions and terminates execution when an abort occurs during a conditional or sequence.
// 30fa5ff5160a19cb6ededf5b95f31a5d: Import modules using 'use' instead of 'import'.
