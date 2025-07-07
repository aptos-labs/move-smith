//# publish
module 0x1::DepModule {
    use std::signer;

    #[skip(lint_borrow_checker, lint_unused_variable)]
    resource struct R { val: u64 }

    // Initialize the resource R with some value
    public fun init_resource(account: &signer, v: u64) {
        move_to(account, R { val: v });
    }

    // do() modifies or interacts with R resource based on v
    public fun do(account: &signer, v: u64) {
        let r = borrow_global_mut<R>(signer::address_of(account));
        if (v > 0) {
            r.val = r.val + v;
        } else {
            // For demonstration, reset val if v is 0 or less
            r.val = 0;
        }
    }

    // runner function to test do() without arguments
    public fun runner(account: &signer) {
        // Use a fixed value for demonstration
        init_resource(account, 10);
        do(account, 5);
        do(account, 0);
    }
}
//# run 0x1::DepModule::runner --signers 0x1


//# publish
module 0x2::MainModule {
    use std::signer;
    use 0x1::DepModule;

    #[skip(lint_unused_imports)]
    public fun dummy() {}

    // Function parsing target and dependency module names and associated address mapping
    // NOTE: Simulation, since Move itself can't do file parsing, we simulate "parsing"
    public fun parse_targets_and_dependencies() {
        // Example "parsing"
        let target_files = vector["MainModule.move"];
        let dep_files = vector["DepModule.move"];
        let address_map = vector[(0x1, "DepModule"), (0x2, "MainModule")];
        // No real effect, just to test vector and tuple features
        let _ = target_files;
        let _ = dep_files;
        let _ = address_map;
    }

    public fun test_do_wrapper(account: &signer, v: u64) {
        // Initialize resource via DepModule
        DepModule::init_resource(account, 100);
        // Call do from DepModule
        DepModule::do(account, v);
    }

    // Runner function to call test with multiple values
    public fun runner(account: &signer) {
        parse_targets_and_dependencies();
        test_do_wrapper(account, 50);
        test_do_wrapper(account, 0);
        test_do_wrapper(account, 5);
    }
}
//# run 0x2::MainModule::runner --signers 0x2


//# run 0x2::MainModule::test_do_wrapper --signers 0x2 --args 42u64