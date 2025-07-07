//# publish
module 0xCAFE::SeqStmt {
    use std::signer;
    use std::aptos_framework::option;

    // A simple resource to test global storage operations
    struct Counter has store, key {
        value: u64,
    }

    // Publish function to create resource under the signer
    public fun init_account(account: &signer) {
        let counter = Counter { value: 42u64 };
        move_to(account, counter);
    }

    // Increment function to test mutation of global resource
    public fun increment(account: &signer) {
        let counter_ref = borrow_global_mut<Counter>(signer::address_of(account));
        counter_ref.value = counter_ref.value + 1u64;
    }

    // Check existence function
    public fun is_exists(addr: address): bool {
        option::is_some(&borrow_global_opt<Counter>(addr))
    }

    // Runner function, publishes, increments, checks existences all in sequence statements style
    public fun runner(account: &signer) {
        // Initialize resource
        init_account(account);

        // Increment multiple times sequenced
        increment(account);
        increment(account);

        // Check existence - should be true
        let exists = is_exists(signer::address_of(account));
        // dummy let to use exists (no assertions needed)
        let _ = exists;

        // Check existence on bogus address - should be false
        let no_exist = is_exists(0x000000000000000000000000000000000000BEEF);
        let _ = no_exist;
    }
}
//# run 0xCAFE::SeqStmt::runner --signers 0xCAFE

//# run
script {
    use std::signer;
    use 0xCAFE::SeqStmt;

    fun main(account: signer) {
        // Sequential execution of statements to test parsing and VM
        // Call runner inside a script to execute all steps
        SeqStmt::runner(&account);

        // Additional sequential statements to test expression statements
        let x: u64 = 10u64;
        let y: u64 = 20u64;
        let sum: u64 = x + y;
        let _ = sum;

        // Test global resource access and mutation again in script
        SeqStmt::increment(&account);

        // Existence checks again
        let exists = SeqStmt::is_exists(signer::address_of(&account));
        let _ = exists;

        let no_exist = SeqStmt::is_exists(0x000000000000000000000000000000000000DEAD);
        let _ = no_exist;
    }
}