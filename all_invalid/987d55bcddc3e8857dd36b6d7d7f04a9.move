//# publish
module 0xCAFE::SequentialAssign {
    // Test sequential assignments and use of updated value in arithmetic operations.
    
    // Struct with two numeric fields named 0 and 1 to test field naming with numbers
    struct Nums has copy, drop, store {
        0: u64,
        1: u64,
    }

    // Function that performs sequential assignments and arithmetic with the updated value.
    public fun seq_assign_and_use(x: u64, y: u64): u64 {
        let mut a = x;
        a = a + y; // update a
        let mut b = a;
        b = b * 2; // update b with updated a
        b + a
    }

    // Function returning Nums struct to test numeric field access
    public fun create_nums(x: u64, y: u64): Nums {
        Nums { 0: x, 1: y }
    }

    // Function reading numeric fields and summing
    public fun sum_nums_fields(n: &Nums): u64 {
        n.0 + n.1
    }

    // Runner function with no args for invocation
    public fun runner() {
        let res = seq_assign_and_use(10, 20);
        let nums = create_nums(5, 15);
        let s = sum_nums_fields(&nums);
        let _ = res + s;
    }
}

//# run 0xCAFE::SequentialAssign::seq_assign_and_use --args 100u64 50u64

//# run 0xCAFE::SequentialAssign::create_nums --args 7u64 8u64

//# run 0xCAFE::SequentialAssign::sum_nums_fields --args 0xCAFE::SequentialAssign::create_nums(20u64, 30u64)

//# run 0xCAFE::SequentialAssign::runner


//# publish
module 0xCAFE::FriendModuleA {
    use std::signer;

    struct Secret has key, store {
        val: u64,
    }

    friend 0xCAFE::FriendModuleB;

    public fun create_secret(s: signer, v: u64) {
        move_to(&s, Secret { val: v });
    }

    public fun get_secret(addr: address): u64 {
        let sec_ref = borrow_global<Secret>(addr);
        sec_ref.val
    }
}

//# publish
module 0xCAFE::FriendModuleB {
    use std::signer;
    use 0xCAFE::FriendModuleA;

    friend 0xCAFE::FriendModuleA;

    public fun update_secret(s: signer, new_val: u64) {
        let secret_ref = borrow_global_mut<FriendModuleA::Secret>(signer::address_of(&s));
        secret_ref.val = new_val;
    }

    public fun double_secret(addr: address): u64 {
        let val = FriendModuleA::get_secret(addr);
        val * 2
    }

    public fun runner(s: signer) {
        FriendModuleA::create_secret(s, 42);
        update_secret(s, 84);
        let dbl = double_secret(signer::address_of(&s));
        let _ = dbl;
    }
}

//# run 0xCAFE::FriendModuleA::create_secret --signers 0xBEEF --args 123u64

//# run 0xCAFE::FriendModuleA::get_secret --args 0xBEEF

//# run 0xCAFE::FriendModuleB::update_secret --signers 0xBEEF --args 456u64

//# run 0xCAFE::FriendModuleB::double_secret --args 0xBEEF

//# run 0xCAFE::FriendModuleB::runner --signers 0xBEEF

// Featurres:
// f5d85ae3cb5ae9c572071bd106e8a755: Test that the Move function correctly performs sequential assignments and uses the updated value in an arithmetic operation.
// 1ec968b9866c644bfe28fd6c982f270e: Use numeric tokens to identify positional fields in Move code.
// aed80a4ab164822e48542492a7d3e0f4: Define module-level friend declarations, allowing modules to declare other modules as friends using the friend syntax in Move 2.
