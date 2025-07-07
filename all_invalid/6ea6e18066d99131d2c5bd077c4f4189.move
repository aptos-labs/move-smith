//# publish
module 0x1::DepModule {
    use std::signer;

    #[skip(lint1, lint2, lint3)]
    struct R has key {
        value: u64,
    }

    public fun init_r(account: &signer) {
        move_to(account, R { value: 0 });
    }

    public fun get_value(r: &R): u64 {
        r.value
    }

    // The do function modifies resource R based on input v
    public fun do(r: &mut R, v: u64) {
        if (v % 2 == 0) {
            r.value = r.value + v;
        } else {
            r.value = r.value * v;
        }
    }

    public fun runner(account: &signer) {
        // Initialize resource R in account storage
        init_r(account);
        let r_ref = borrow_global_mut<R>(signer::address_of(account));
        // Do some modifications
        do(r_ref, 4); // even number, adds 4
        do(r_ref, 3); // odd number, multiplies by 3
    }
}
//# run 0x1::DepModule::runner --signers 0x1

//# publish
module 0x1::MainModule {
    use std::signer;
    use 0x1::DepModule;

    #[skip(lint4)]
    public fun run_main(account: &signer) {
        // Use DepModule runner to init and modify R
        DepModule::runner(account);
        let r = borrow_global<DepModule::R>(signer::address_of(account));
        let _val = DepModule::get_value(&r);
        // we don't assert, just let VM execute
    }
}
//# run 0x1::MainModule::run_main --signers 0x1

//# run
script {
    use std::signer;
    use 0x1::DepModule;
    use 0x1::MainModule;

    fun main(account: signer) {
        // Directly invoke the MainModule function
        MainModule::run_main(&account);
    }
}