
//# publish
module 0xCAFE::FeatureTest {
    use std::signer;

    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return a specific value 42 if sum is 100, otherwise sum
        if (sum == 100) {
            42
        } else {
            sum
        }
    }

    public fun lambda_test(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| a + b;
        adder(x, y)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun caller_inline_add(a: u8, b: u8): u8 {
        // Call inline function from current module
        inline_add(a, b)
    }

    public fun param_and_return(x: u64, y: u64): u64 {
        x + y
    }

    struct RefStore has key, store {
        val: u64
    }

    public fun test_reassign_refs(s: signer, v1: u64, v2: u64): u64 {
        let store = RefStore { val: v1 };
        move_to<RefStore>(&s, store);

        let addr = signer::address_of(&s);
        let ref1: &RefStore = borrow_global<RefStore>(addr);
        // ref1.val should be v1 initially

        let ref2: &RefStore = ref1;
        // Reassign ref1 within scope to borrow_global again with updated value
        let mut_ref: &mut RefStore = borrow_global_mut<RefStore>(addr);
        mut_ref.val = v2;

        // Dereference ref2 val - it should reflect updated value v2
        let res = ref2.val;

        // Clean up stored resource to avoid reuse problems
        let _moved = move_from<RefStore>(addr);

        res
    }
}



//# run 0xCAFE::FeatureTest::add_two_values --args 40u8 2u8



//# run 0xCAFE::FeatureTest::add_two_values --args 50u8 50u8



//# run 0xCAFE::FeatureTest::lambda_test --args 5u8 7u8



//# run 0xCAFE::FeatureTest::caller_inline_add --args 10u8 20u8



//# run 0xCAFE::FeatureTest::param_and_return --args 100u64 200u64



//# run 0xCAFE::FeatureTest::test_reassign_refs --signers 0xBEEF --args 10u64 20u64
