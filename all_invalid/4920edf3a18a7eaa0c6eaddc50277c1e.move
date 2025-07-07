//# publish
module 0xCAFE::ConditionalAccess {
    use std::signer;

    struct Data has key, store {
        value: u64,
        flag: bool,
    }

    public fun create_data(s: signer, value: u64, flag: bool) {
        let data = Data { value, flag };
        move_to<Data>(&s, data);
    }

    public fun conditional_borrow(s: signer, expect_flag: bool): u64 {
        let addr = signer::address_of(&s);
        if (expect_flag) {
            let data_ref: &Data = borrow_global<Data>(addr);
            // if flag mismatches, abort with code 1001
            if (!(data_ref.flag == expect_flag)) {
                abort 1001;
            };
            data_ref.value
        } else {
            let data_mut_ref: &mut Data = borrow_global_mut<Data>(addr);
            // if flag mismatches, abort with code 1002
            if (!(data_mut_ref.flag == expect_flag)) {
                abort 1002;
            };
            // update value by incrementing it
            data_mut_ref.value = data_mut_ref.value + 1;
            data_mut_ref.value
        }
    }

    public inline fun call_with_closure_lambda(x: u64, y: u64, f: |u64, u64| u64): u64 {
        f(x, y)
    }

    public fun runner_no_args(): u64 {
        let s = 42u64;
        let t = 58u64;

        let lambda1: |u64, u64| u64 has copy+drop = |a: u64, b: u64| {
            a + b
        };

        let lambda2: |u64, u64| u64 has copy+drop = |a: u64, b: u64| {
            if (a > b) { a - b } else { b - a }
        };

        let res1 = call_with_closure_lambda(s, t, lambda1);
        let res2 = call_with_closure_lambda(t, s, lambda2);

        res1 + res2
    }
}

//# run 0xCAFE::ConditionalAccess::create_data --signers 0xABCD --args 99u64 true

//# run 0xCAFE::ConditionalAccess::conditional_borrow --signers 0xABCD --args true

//# run 0xCAFE::ConditionalAccess::conditional_borrow --signers 0xABCD --args false

//# run 0xCAFE::ConditionalAccess::conditional_borrow --signers 0xABCD --args false

//# run 0xCAFE::ConditionalAccess::runner_no_args

// Featurres:
// aa464619e73d0f0ff7f9495b48fa584b: Test that functions correctly borrow and access global resource data conditionally based on input parameters, ensuring proper shared and mutable references are used.
// 830c876c24f59db8f7cfb196485223b4: Abort execution using the 'abort' keyword followed by an expression to specify the abort value.
// 426aee62717231b92c1e9e4a6b492596: Test that the inline function correctly accepts and executes closure arguments with different parameter configurations and returns the expected computed value.
