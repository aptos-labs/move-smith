
//# publish
module 0xCAFE::TestReturnAbortControl {
    struct R has store {
        val: u64,
    }

    // Function demonstrating return and abort with control flow
    public fun test_return_and_abort(x: u64): u64 {
        if (x == 0) {
            abort 100;
        };
        let y = x + 1;
        if (y > 10) {
            return 42;
        };
        y
    }

    // Function demonstrating unary ops, dereference, cast, annotate
    public fun test_deref_cast_annotate(a: u8, b: u16): u64 {
        let a_u64: u64 = a as u64;
        let b_u64: u64 = b as u64;
        let sum_val = a_u64 + b_u64;
        let sum_ref: &u64 = &sum_val;
        // Fix: Use bitwise NOT operator ~ instead of logical NOT !
        let negated = ~(sum_val as u8);
        let res = (negated as u64) + *sum_ref;
        res
    }
}




//# run 0xCAFE::TestReturnAbortControl::test_return_and_abort --args 5u64




//# run 0xCAFE::TestReturnAbortControl::test_return_and_abort --args 11u64




//# run 0xCAFE::TestReturnAbortControl::test_deref_cast_annotate --args 7u8 8u16





//# publish
module 0xCAFE::TestGlobalResourceAccess {
    use std::signer;

    struct Counter has key, store {
        count: u64,
    }

    public fun init_counter(s: signer) {
        move_to<Counter>(&s, Counter { count: 0 });
    }

    // Conditionally borrow either shared or mutable Counter resource
    public fun conditional_access(s: signer, do_update: bool): u64 {
        let addr = signer::address_of(&s);
        if (do_update) {
            let counter_ref_mut: &mut Counter = borrow_global_mut<Counter>(addr);
            counter_ref_mut.count = counter_ref_mut.count + 1;
            counter_ref_mut.count
        } else {
            let counter_ref: &Counter = borrow_global<Counter>(addr);
            counter_ref.count
        }
    }
}




//# run 0xCAFE::TestGlobalResourceAccess::init_counter --signers 0xDEAD




//# run 0xCAFE::TestGlobalResourceAccess::conditional_access --signers 0xDEAD --args false




//# run 0xCAFE::TestGlobalResourceAccess::conditional_access --signers 0xDEAD --args true




//# run 0xCAFE::TestGlobalResourceAccess::conditional_access --signers 0xDEAD --args false





//# publish
module 0xCAFE::TestWhileLoopMutation {
    public fun compute_sum(x: u64): u64 {
        let sum = 0;
        let i = 0;
        while (i <= x) {
            sum = sum + i;
            i = i + 1;
        };
        sum
    }

    public fun sum_with_scope(x: u8): u8 {
        let total = 0;
        let index = 0;
        while (index < x) {
            let temp = index * 2;
            // Test variable shadowing/scopes
            {
                let temp = temp + 1;
                total = total + temp;
            };
            total = total + temp;
            index = index + 1;
        };
        total
    }
}




//# run 0xCAFE::TestWhileLoopMutation::compute_sum --args 5u64




//# run 0xCAFE::TestWhileLoopMutation::sum_with_scope --args 3u8
