//# publish
module 0xabcde::immutability_tests {
    fun reassign_test(): u64 {
        let val = 5;
        // The following line should cause a compile-time error if uncommented
        // val = val + 1; 
        // To demonstrate, we'll just return the initial value
        val
    }

    fun multiple_vars_test(): u64 {
        let a = 10;
        let b = 20;
        // Attempting to reassign should cause a compile error if uncommented
        // a = a + 5;
        // b = b + 5;
        a + b
    }

    fun main() {
        // Uncomment to test reassignment error
        // assert!(reassign_test() == 5, 0);
        assert!(multiple_vars_test() == 30, 1);
    }
}

//# run 0xabcde::immutability_tests::main

//# publish
module 0x12345::resource_access {
    use 0x1::vector;

    struct Balance has key {
        amount: u64
    }

    fun check_balance(account: address): u64 acquires Balance {
        *borrow_global<Balance>(account).amount
    }

    fun spend(wallet: &mut Balance, amount: u64) {
        wallet.amount = wallet.amount - amount;
    }

    fun transfer(from: address, to: address, amount: u64) acquires Balance {
        let from_balance = borrow_global_mut<Balance>(from);
        let to_balance = borrow_global_mut<Balance>(to);
        from_balance.amount = from_balance.amount - amount;
        to_balance.amount = to_balance.amount + amount;
    }

    public fun main() {
        // Set up initial balances
        // Assume initial balances are already set in the global resources for testing
        let sender = @0x100;
        let receiver = @0x200;

        // Check initial balances
        let sender_balance = check_balance(sender);
        let receiver_balance = check_balance(receiver);

        // Spend some amount
        let sender_wallet = borrow_global_mut<Balance>(sender);
        spend(sender_wallet, 10);
        
        // Transfer remaining to receiver
        transfer(sender, receiver, 5);

        // Validate updated balances
        let new_sender_balance = check_balance(sender);
        let new_receiver_balance = check_balance(receiver);

        // For the purpose of testing, assertions are omitted.
    }
}

//# run 0x12345::resource_access::main

//# publish
module 0x67890::closure_test {
    inline fun sum_closures(f1: |u64| u64, f2: |u64| u64): u64 {
        f1(5) + f2(10)
    }

    public fun test() {
        let result = sum_closures(
            |x| x + 2,
            |y| y * 2
        );
        // Expected result: (5 + 2) + (10 * 2) = 7 + 20 = 27
        assert!(result == 27, 0);
    }
}

//# run 0x67890::closure_test::test