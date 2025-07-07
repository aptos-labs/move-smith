//# publish
module 0x1::RModule {
    /// Resource that will be modified by do()
    struct R has key {
        value: u64,
    }

    /// Initialize resource R with given value under signer
    public entry fun init(s: &signer, init_val: u64) {
        move_to(s, R { value: init_val });
    }

    /// Read the current value of R
    public fun get_value(addr: address): u64 acquires R {
        borrow_global<R>(addr).value
    }
}

//# publish
module 0x1::DoModule {
    use std::signer;
    use 0x1::RModule;

    #[skip(lint_incorrect_order, lint_unused_import)]
    /// This attribute skips two lint checks: `lint_incorrect_order` and `lint_unused_import`

    /// Main function that modifies or interacts with R based on v
    public entry fun do(s: &signer, v: u64) acquires RModule::R {
        if (v == 0) {
            // If zero, reset R value to 0
            let r_ref = borrow_global_mut<RModule::R>(signer::address_of(s));
            r_ref.value = 0;
        } else if (v % 2 == 0) {
            // If even, increment R value by v
            let r_ref = borrow_global_mut<RModule::R>(signer::address_of(s));
            r_ref.value = r_ref.value + v;
        } else {
            // If odd, decrement R value by v, but prevent underflow
            let r_ref = borrow_global_mut<RModule::R>(signer::address_of(s));
            if (r_ref.value >= v) {
                r_ref.value = r_ref.value - v;
            } else {
                // If underflow risk, reset to 0
                r_ref.value = 0;
            }
        }
    }

    /// Runner function to test `do()` with various values
    public entry fun runner(s: &signer) acquires RModule::R {
        // Initialize to 10
        RModule::init(s, 10);

        // do(0): sets to 0
        do(s, 0);

        // do(4): even, adds 4, result 4
        do(s, 4);

        // do(3): odd, subtracts 3, result 1
        do(s, 3);

        // do(100): even, add 100, result 101
        do(s, 100);
    }
}
//# run 0x1::DoModule::runner --signers 0x1

//# run
script {
    use std::signer;
    use 0x1::DoModule;
    use 0x1::RModule;

    fun main(account: signer) {
        // Initialize resource R with 5
        RModule::init(&account, 5);

        // Run do(2): even, should add 2 => 7
        DoModule::do(&account, 2);

        // Run do(7): odd, subtract 7 => 0 (no underflow)
        DoModule::do(&account, 7);

        // Run do(0): reset to 0
        DoModule::do(&account, 0);
    }
}