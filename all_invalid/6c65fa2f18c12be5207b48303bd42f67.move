
//# publish
module 0xCAFE::PragmaSpecImportEvalOrder {
    use std::signer;
    use std::vector;
    use std::string;

    // Use pragma directives as identifiers as allowed by Move syntax
    pragma(abc);
    pragma(custom_verifier);

    struct Counter has key, store {
        count: u64,
    }

    public fun init(s: signer) {
        let c = Counter {count: 0};
        move_to<Counter>(&s, c);
    }

    public fun get_count(s: &signer): u64 {
        let addr = signer::address_of(s);
        let counter_ref = borrow_global<Counter>(addr);
        counter_ref.count
    }

    public fun inc_count(s: &signer): u64 {
        let addr = signer::address_of(s);
        let counter_ref_mut = borrow_global_mut<Counter>(addr);
        counter_ref_mut.count = counter_ref_mut.count + 1;
        counter_ref_mut.count
    }

    public fun double_inc(s: &signer): u64 {
        // test nested mutations during argument evaluation
        inc_count(s) + inc_count(s)
    }

    public fun inc_and_assign(s: &signer, val_ref: &mut u64): u64 {
        let c = inc_count(s);
        *val_ref = c;
        c
    }

    public fun complex_expr(s: &signer): u64 {
        let local_val = 0u64;
        let x = inc_and_assign(s, &mut local_val) + inc_and_assign(s, &mut local_val) + local_val;
        x
    }

    spec module {
        use std::vector;
        use std::string;

        spec struct Counter {
            count: u64,
        }

        // Spec function to specify counter's count after initialization
        spec init(s: signer) {
            ensures exists<Counter>(signer::address_of(&s));
            ensures (borrow_global<Counter>(signer::address_of(&s))).count == 0;
        }

        // Spec to capture that inc_count increases count by 1
        spec inc_count(s: signer) {
            let pre = old(borrow_global<Counter>(signer::address_of(&s))).count;
            let post = borrow_global<Counter>(signer::address_of(&s)).count;
            ensures post == pre + 1;
        }

        // Spec to describe behavior of double_inc: after two increments, count increases by 2
        spec double_inc(s: signer) {
            let pre = old(borrow_global<Counter>(signer::address_of(&s))).count;
            let post = borrow_global<Counter>(signer::address_of(&s)).count;
            ensures post == pre + 2;
            // also ensures result == post
        }

        // Spec for inc_and_assign showing it increments count and assigns to val_ref
        spec inc_and_assign(s: signer, val_ref: &mut u64) {
            let pre = old(borrow_global<Counter>(signer::address_of(&s))).count;
            let post = borrow_global<Counter>(signer::address_of(&s)).count;
            ensures post == pre + 1;
            ensures *val_ref == post;
        }

        // Spec for complex_expr showing proper sequencing in expression evaluation
        spec complex_expr(s: signer) {
            let pre = old(borrow_global<Counter>(signer::address_of(&s))).count;
            let post = borrow_global<Counter>(signer::address_of(&s)).count;
            ensures post == pre + 2;
            // result is sum of two increments + last assigned local_val
            // so result == (pre+1) + (pre+2) + (pre+2) == 3*post - 3
        }
    }
}


//# run 0xCAFE::PragmaSpecImportEvalOrder::init --signers 0xDEAD


//# run 0xCAFE::PragmaSpecImportEvalOrder::get_count --signers 0xDEAD


//# run 0xCAFE::PragmaSpecImportEvalOrder::inc_count --signers 0xDEAD


//# run 0xCAFE::PragmaSpecImportEvalOrder::get_count --signers 0xDEAD


//# run 0xCAFE::PragmaSpecImportEvalOrder::double_inc --signers 0xDEAD


//# run 0xCAFE::PragmaSpecImportEvalOrder::get_count --signers 0xDEAD


//# run 0xCAFE::PragmaSpecImportEvalOrder::complex_expr --signers 0xDEAD


//# run 0xCAFE::PragmaSpecImportEvalOrder::get_count --signers 0xDEAD


// Featurres:
// ae83749d0886920342fdea6bdc4ba15f: Use pragma values that are identifiers in your Move code.
// d7586a9eca0243621ef9fbddf6282992: Include 'use' declarations inside spec blocks to import modules or components.
// ab4f2d8020a10dcc50efd93b1d2646fd: Test the order of evaluation and side effect sequencing of complex nested expressions with mutation and assignment in function arguments.
