//# publish
module 0xA550C18::TestModule {
    use std::signer;
    use std::vector;

    #[skip(unknown_fields, dead_code)]
    struct R has key {
        value: u64,
    }

    public(friend) fun create_r(account: &signer, v: u64) {
        let r = R { value: v };
        move_to(account, r);
    }

    public fun do(account: &signer, v: u64) {
        let r_ref = borrow_global_mut<R>(signer::address_of(account));
        if (v > 0) {
            r_ref.value = r_ref.value + v;
        } else {
            r_ref.value = 1;
        }
    }

    public fun runner(account: &signer) {
        // Create R with initial value 10
        create_r(account, 10);

        // Do with v = 5, should add 5 => value = 15
        do(account, 5);

        // Do with v = 0, should reset value to 1
        do(account, 0);
    }
}
//# run 0xA550C18::TestModule::runner --signers 0xA550C18


//# run
script {
    use 0xA550C18::TestModule;
    use std::signer;

    fun main(account: &signer) {
        // Initialize R resource
        TestModule::create_r(account, 100);

        // Call do with positive value, expecting modification
        TestModule::do(account, 50);

        // Call do with zero value, expecting reset to 1
        TestModule::do(account, 0);
    }
}