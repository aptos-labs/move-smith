//# publish
module 0xA550C18::DependencyModule {
    use std::signer;
    use std::vector;

    #[skip(empty_script)]
    struct R has key {
        val: u64,
    }

    /// Initialize resource R with val = 0 under the signer
    public fun init_resource(account: &signer) {
        move_to(account, R { val: 0 });
    }

    /// Do function modifies R.val based on input v:
    /// If v is even, add v to R.val
    /// Else subtract v from R.val (not underflow checked here)
    public fun do(r: &mut R, v: u64) {
        if (v % 2 == 0) {
            r.val = r.val + v;
        } else {
            // note: intentionally allowing underflow to test vm behavior
            r.val = r.val - v;
        }
    }

    /// A runner function that exercises do with various values
    /// Modifies R by adding even and subtracting odd
    public fun runner(account: &signer) {
        let r_ref = borrow_global_mut<R>(signer::address_of(account));
        // apply do with v=2 (even)
        do(r_ref, 2);
        // apply do with v=3 (odd)
        do(r_ref, 3);
        // apply do with v=4 (even)
        do(r_ref, 4);
        // apply do with v=5 (odd)
        do(r_ref, 5);
    }
}

//# run 0xA550C18::DependencyModule::runner --signers 0xA550C18

//# publish
module 0xA550C18::TargetModule {
    use std::signer;
    use 0xA550C18::DependencyModule;

    #[skip(empty_script, unused_imports)]
    struct Dummy has copy, drop { dummy_field: bool }

    /// Initialize DependencyModule::R resource so it can be tested
    public fun setup(account: &signer) {
        DependencyModule::init_resource(account);
    }

    /// Calls DependencyModule::do on R with given value v
    public fun call_do(account: &signer, v: u64) {
        let r_ref = borrow_global_mut<DependencyModule::R>(signer::address_of(account));
        DependencyModule::do(r_ref, v);
    }

    /// Runner function to test call_do with some sample values
    public fun runner(account: &signer) {
        setup(account);
        call_do(account, 10);
        call_do(account, 7);
    }
}

//# run 0xA550C18::TargetModule::runner --signers 0xA550C18

//# run
script {
    use std::signer;
    use 0xA550C18::TargetModule;
    /// Top-level script that performs setup and calls runner to test all logic
    fun main(account: signer) {
        TargetModule::runner(&account);
    }
}