//# publish
module 0x1::RModule {
    use std::signer;

    /// Define resource R with a value
    struct R has key {
        v: u64,
    }

    /// Constant to demonstrate access to constants
    const CONST_VALUE: u64 = 42;

    /// Initialize resource R with a value v
    public fun init_r(account: &signer, v: u64) {
        move_to(account, R { v });
    }

    /// Get the value from resource R
    public fun get_v(r: &R): u64 {
        r.v
    }
}

//# publish
module 0x1::Modifier {
    use std::signer;
    use std::debug;
    use 0x1::RModule;

    /// Example function that demonstrates skipping lints for it
    #[skip(check_unused_variable, check_style)]
    public entry fun do(account: &signer) {
        let r = borrow_global_mut<RModule::R>(signer::address_of(account));
        // if v < CONST_VALUE then add CONST_VALUE to v else set to zero
        if (r.v < RModule::CONST_VALUE) {
            r.v = r.v + RModule::CONST_VALUE;
        } else {
            r.v = 0;
        };
        
        // Provide a diagnostic message with call site info and cause
        debug::print_with_cause(
            b"do() function executed in Modifier module",
            b"v modified based on constant comparison",
        );
    }

    /// Runner function to invoke `do` as a transaction entry point without arguments
    public entry fun runner(account: &signer) {
        do(account);
    }
}

//# run 0x1::Modifier::runner --signers 0x1

//# publish
module 0x1::TestRunner {
    use std::signer;
    use 0x1::RModule;
    use 0x1::Modifier;

    /// Initialize resource and run Modifier::do
    public entry fun main(account: &signer) {
        // Initialize with v=10 (less than CONST_VALUE=42)
        RModule::init_r(account, 10);
        Modifier::do(account);
        // After Modifier::do, v should be 10 + 42 = 52

        // Re-initialize with v=50 (greater than CONST_VALUE=42)
        RModule::init_r(account, 50);
        Modifier::do(account);
        // After Modifier::do, v should be 0
    }

}

//# run
script {
    use std::signer;
    use 0x1::TestRunner;

    fun main(account: signer) {
        TestRunner::main(&account);
    }
}