//# publish
module 0x1::DepModule {
    use std::signer;

    #[skip(unused_variable, non_ascii_idents)]
    struct R has key {
        value: u64,
    }

    public fun create_r(account: &signer, val: u64) {
        move_to(account, R { value: val });
    }

    public fun read_r(account: &signer): u64 acquires R {
        let r = borrow_global<R>(signer::address_of(account));
        r.value
    }

    // The do function modifies or interacts with R depending on val v
    public fun do(account: &signer, v: u8) acquires R {
        let addr = signer::address_of(account);
        if (exists<R>(addr)) {
            let r = borrow_global_mut<R>(addr);
            if (v == 0) {
                // reset value to 0
                r.value = 0;
            } else if (v == 1) {
                // increment by 1
                r.value = r.value + 1;
            } else if (v == 2) {
                // multiply by 2
                r.value = r.value * 2;
            } else {
                // do nothing for others
            }
        } else {
            // if R does not exist, create it with value of v as u64
            create_r(account, v as u64);
        }
    }

    // Runner function that can be called without arguments, requires signer
    public fun runner(account: &signer) acquires R {
        // Call do() with different v values sequentially
        do(account, 0);
        do(account, 1);
        do(account, 2);
        // no-op call
        do(account, 99);
    }
}
//# run 0x1::DepModule::runner --signers 0x1


//# publish
module 0x1::MainModule {
    use std::signer;
    use 0x1::DepModule;

    #[skip(unused_variable)]
    public fun test_do_with_r(account: &signer) acquires DepModule::R {
        // Initially create R with value 10
        DepModule::create_r(account, 10);

        // Test interactions with do()
        DepModule::do(account, 1); // value should become 11
        DepModule::do(account, 2); // value should become 22
        DepModule::do(account, 0); // reset to 0
        DepModule::do(account, 42); // no change since v=42 does nothing
    }

    public fun runner(account: &signer) acquires DepModule::R {
        test_do_with_r(account);
    }
}
//# run 0x1::MainModule::runner --signers 0x1


//# run
script {
    use std::signer;
    use 0x1::MainModule;
    use 0x1::DepModule;

    fun main(account: signer) {
        // Create R in DepModule through direct call
        DepModule::create_r(&account, 5);

        // Run Direct runner in DepModule to exercise do()
        DepModule::runner(&account);

        // Run test runner in MainModule
        MainModule::runner(&account);
    }
}