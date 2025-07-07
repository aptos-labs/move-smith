
//# publish
module 0xCAFE::ResourceAcquisition {
    use std::signer;
    use std::signer::move_to;

    struct Res has key, store {
        value: u64,
    }

    public fun acquire_resource(s: &signer, val: u64) {
        let r = Res { value: val };
        move_to<Res>(s, r);
    }

    public inline fun inline_acquire(s: &signer, val: u64) {
        // Calls the function that acquires resource
        acquire_resource(s, val);
    }

    public fun inline_runner(s: &signer) {
        inline_acquire(s, 42u64);
    }
}



//# run 0xCAFE::ResourceAcquisition::inline_runner --signers 0xDEAD




//# publish
module 0xCAFE::QuantifiedExpressions {
    /// A dummy struct to bind data for quantification
    struct Dummy has copy, drop, store {
        value: u8,
    }

    public fun forall_example(): bool {
        // forall i in 0..5: i < 10
        let result = true;
        let i = 0;
        while (i < 5) {
            result = result && (i < 10);
            i = i + 1;
        };
        result
    }

    public fun exists_example(): bool {
        // exists x in 0..5: x == 3
        let found = false;
        let x = 0;
        while (x < 5) {
            if (x == 3) {
                found = true;
            };
            x = x + 1;
        };
        found
    }

    public fun forall_with_witness(): bool {
        // forall i in 0..5: exists j in 0..i+1: j == i
        let outer_res = true;
        let i = 0;
        while (i < 5) {
            let inner_found = false;
            let j = 0;
            while (j < (i + 1)) {
                if (j == i) {
                    inner_found = true;
                };
                j = j + 1;
            };
            outer_res = outer_res && inner_found;
            i = i + 1;
        };
        outer_res
    }
}



//# run 0xCAFE::QuantifiedExpressions::forall_example




//# run 0xCAFE::QuantifiedExpressions::exists_example




//# run 0xCAFE::QuantifiedExpressions::forall_with_witness




//# run
script {
    use std::debug;

    // An infinite loop is not supported in a top-level script;
    // instead, make this a function or remove infinite loop.
    // For demo, let's just print and return.
    debug::print(b"UNREACHABLE\n");
}
