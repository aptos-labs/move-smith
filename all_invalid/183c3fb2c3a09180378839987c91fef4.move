//# publish
module 0xCAFE::AbortInlineWhile {
    use std::signer;

    // An inline function that will abort if `cond` is true
    inline fun check_abort(cond: bool) {
        if (cond) {
            abort 100; // abort with code 100
        }
    }

    // A public caller function to test abort inline function in an expression
    public fun call_abort_inline() {
        // This will not abort
        check_abort(false);

        // This will abort with code 100
        check_abort(true);

        // This line will never be reached
        abort 101;
    }

    // A public inline function that computes sum from 0 to limit-1 using a while loop
    inline fun sum_while(limit: u64): u64 {
        let mut i = 0;
        let mut acc = 0;
        while (i < limit) {
            acc = acc + i;
            i = i + 1;
        }
        acc
    }

    // A public function that calls sum_while and aborts if computed sum doesn't match expected sum
    public fun verify_sum(limit: u64, expected_sum: u64) {
        let total = sum_while(limit);
        if (total != expected_sum) {
            abort 200;
        }
    }

    // A runner function that calls verify_sum with a small example and then calls abort inline to abort
    public fun runner() {
        // sum 0..5 = 0+1+2+3+4 = 10
        verify_sum(5, 10);

        // The following call will abort, testing abort in inline
        check_abort(true);
    }
}
//# run 0xCAFE::AbortInlineWhile::runner --signers 0xCAFE

//# run
script {
    use 0xCAFE::AbortInlineWhile;

    fun main(account: signer) {
        // Call runner from script signer
        AbortInlineWhile::runner();

        // This line will never be reached because runner aborts inside check_abort(true)
    }
}

// Featurres:
// 5ea164eeba88ba6cfda55209d82626d9: Invoke the abort operation in expressions to terminate execution
// 2df2adbcfaac94eed90f8691d9301a14: Define functions as inline to enable their bodies to be checked after inlining.
// 50d0473d321ac806268162871e8a926c: Implement a 'while' loop that continues as long as the iteration condition holds.
