//# publish
module 0x1::RModule {
    use std::signer;

    #[skip(skip_unused_variable, skip_unreachable_code)]
    resource struct R {
        v: u64,
        log_spec: vector<u8>,
    }

    /// Initialize R with v and a log specification string stored as bytes.
    public fun initialize(account: &signer, v: u64, log_spec_str: vector<u8>) {
        move_to(account, R { v, log_spec: log_spec_str });
    }

    /// The "do" function will modify the resource R in different ways based on value of v.
    /// For example:
    /// - If v is 0, set v to 1,
    /// - If v is 1, double v,
    /// - Otherwise, reset v to 0.
    public fun do_(account: &signer) {
        let r = borrow_global_mut<R>(signer::address_of(account));
        if (r.v == 0) {
            r.v = 1;
        } else if (r.v == 1) {
            r.v = r.v * 2;
        } else {
            r.v = 0;
        }
    }

    /// Return the current value of v for inspection (if needed).
    public fun get_v(account: &signer): u64 {
        borrow_global<R>(signer::address_of(account)).v
    }

    /// Return a string (vector<u8>) of the log_spec.
    public fun get_log_spec(account: &signer): &vector<u8> {
        &borrow_global<R>(signer::address_of(account)).log_spec
    }

    /// Runner that performs a sequence of operations:
    /// Initialize R with v=0 and a sample log spec,
    /// then call do_ thrice to test all branches.
    public fun runner(account: &signer) {
        let log_spec_str = b"level=info;module=RModule";
        initialize(account, 0, vector::from_bytes(log_spec_str));
        // do_ where v = 0 -> v = 1
        do_(account);
        // do_ where v = 1 -> v = 2
        do_(account);
        // do_ where v = 2 -> v = 0
        do_(account);
    }
}
//# run 0x1::RModule::runner --signers 0x1

//# run 0x1::RModule::do_ --signers 0x1

//# run 0x1::RModule::initialize --signers 0x1 --args 123u64 b"level=debug;module=RModuleB"



//# run
script {
    use std::signer;
    use 0x1::RModule;

    fun main(account: signer) {
        // Publish test resource R with v=0 and a simple log_spec string.
        let log_spec_str = b"level=warn;module=TestScript";
        RModule::initialize(&account, 0, vector::from_bytes(log_spec_str));

        // Check behavior of do_ with v=0 (should set to 1)
        RModule::do_(&account);

        // Do again (v=1 -> 2)
        RModule::do_(&account);

        // Do again (v=2 -> 0)
        RModule::do_(&account);
    }
}