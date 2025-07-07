//# publish
module 0xCAFE::BalanceManager {
    use std::signer;
    use std::vector;

    struct Balance has key {
        amount: u64,
    }

    public fun init_balance(account: &signer, initial: u64) {
        move_to(account, Balance { amount: initial })
    }

    public fun double_and_increment(account: &signer) {
        let balance = borrow_global_mut<Balance>(signer::address_of(account));
        // Test cumulative updates via mutable reference:
        // This exercises the VM's mut_ref update logic and ensures the final value
        // reflects the double and increment operations.
        balance.amount = balance.amount * 2;
        balance.amount = balance.amount + 1;
    }

    public fun get_balance(account: address): u64 {
        borrow_global<Balance>(account).amount
    }

    // "Runner" with no args to test function filtering, acquisition inference, and cumulative mut_ref ops.
    public fun runner(account: &signer) {
        Self::init_balance(account, 10);
        Self::double_and_increment(account);
        // Filtering: get_balance is *not* called here, but available for compiler filtering checks.
    }
}
//# run 0xCAFE::BalanceManager::runner --signers 0xCAFE

//# publish
module 0xBEEF::NoAcquiresHere {
    /// This struct and all functions do not declare acquires. The compiler
    /// should infer but not complain, exercising feature #1.
    struct Foo has key {
        v: u8,
    }

    public fun publish_foo(account: &signer) {
        move_to(account, Foo { v: 42 })
    }

    public fun set_foo(account: &signer, x: u8) {
        // Should not require an explicit acquires Foo.
        let foo = borrow_global_mut<Foo>(signer::address_of(account));
        foo.v = x;
    }

    // "Runner" to trigger function filtering and test module publish.
    public fun runner(account: &signer) {
        Self::publish_foo(account);
        Self::set_foo(account, 99);
    }
}
//# run 0xBEEF::NoAcquiresHere::runner --signers 0xBEEF

//# run 0xCAFE::BalanceManager::get_balance --signers 0xCAFE --args 0xCAFE