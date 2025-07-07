
//# publish
module 0xCAFE::ResourceAcquisition {
    use std::signer;

    struct Res has key, store {
        value: u64,
    }

    public fun acquire_resource(s: signer, val: u64) {
        let r = Res { value: val };
        move_to<Res>(&s, r);
    }

    public inline fun inline_acquire(s: signer, val: u64) {
        // Calls the function that acquires resource
        acquire_resource(s, val);
    }

    public fun inline_runner(s: signer) {
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
        for i in 0..5 {
            result = result && (i < 10);
        };
        result
    }

    public fun exists_example(): bool {
        // exists x in 0..5: x == 3
        let found = false;
        for x in 0..5 {
            if (x == 3) {
                found = true;
            };
        };
        found
    }

    public fun forall_with_witness(): bool {
        // forall i in 0..5: exists j in 0..i+1: j == i
        let outer_res = true;
        for i in 0..5 {
            let inner_found = false;
            for j in 0..(i+1) {
                if (j == i) {
                    inner_found = true;
                };
            };
            outer_res = outer_res && inner_found;
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

    fun infinite_loop_script() {
        // Infinite loop that should cause out-of-gas error before hitting assertion
        loop {
            // do nothing
        };
        debug::print(b"UNREACHABLE\n");
    }

    infinite_loop_script();
}


// Featurres:
// 57baad3637737b510be50aeb101099d1: Test that an inline function can call a function that acquires a resource, and the acquisition is properly propagated.
// 8c62fe7656b5a212416706b16db90891: Write quantified expressions (forall/exists) over variable bindings and ranges, optionally using witness/condition expressions.
// cec20a1c722c30352f8dbd8a196a7ccc: Test that an infinite loop in a script results in an out-of-gas error before reaching any assertions.
