//# publish
module 0xCAFE::LoopsReturnsAborts {
    use std::signer;
    use std::debug;

    /// A function illustrating a loop, with return and abort, dereference and unary, borrow, sub-expressions
    public fun test_loop_abort_return(s: &signer) {
        let mut i = 0u64;
        let threshold = 5;

        // loop with early return, sub-expressions in condition and body
        loop {
            i = i + 1;
            if (!(i < threshold)) {
                return; // return from function
            }
            let ref_i = &i;  // borrow expression
            let deref_i = *ref_i; // dereference

            let neg_i = - (deref_i as i64); // unary negation with sub-expression cast

            // abort if negated i becomes less than -3 (false here, so no abort actually)
            if (neg_i < -3) {
                abort 777;
            }
        }

        // unreachable code following return
        abort 1234; 
    }

    /// A runner function with no arguments
    public fun runner(s: &signer) {
        test_loop_abort_return(s);
    }
}
//# run 0xCAFE::LoopsReturnsAborts::runner --signers 0xCAFE

//# publish
module 0xCAFE::SpecUseWithByteString {

    use std::vector;

    /// A dummy struct for demonstration
    struct S has copy, drop, store {
        data: vector<u8>,
    }

    /// Function to create S from a byte vector
    public fun create_s_from_bslice(bs: &vector<u8>): S {
        S { data: vector::empty<u8>() } // dummy implementation, won't use bs for this demo
    }

    spec module {
        // import vector inside spec block
        use std::vector;

        // Spec function to illustrate use directive inside spec and byte string literal
        spec fun example_spec() {
            let bs = b"hello\x01\x02"; // byte string literal (text) with escape sequences included
            let v: vector<u8> = vector::empty();
            // not doing further operations here, just illustrating syntax:
            exists<S>(@0xCAFE);
        }
    }
}
//# run 0xCAFE::SpecUseWithByteString::create_s_from_bslice --args 0xCAFE --signers 0xCAFE

//# run
script {
    use 0xCAFE::LoopsReturnsAborts;

    fun main(account: signer) {
        // call runner directly
        LoopsReturnsAborts::runner(&account);
    }
}

// Featurres:
// 5be258d255be281b1e4ed32b6cfe3c62: Create loop, return, abort, dereference, unary, or borrow expressions with sub-expressions.
// 816eaba9dee923083d4ed35c7da5bafb: Include 'use' directives within specification blocks to import modules or symbols.
// 0e8ae1b63682af5198c5388dbac39748: Write byte string literals as input text that can be decoded into byte arrays
