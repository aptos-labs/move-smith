//# publish
module 0x1::DependencyModule {
    #[skip(lint1, lint2)]
    struct R has key {
        val: u64,
    }

    public fun create_r(): R {
        R { val: 0 }
    }
}

//# publish
module 0x1::TestModule {
    use std::signer;
    use 0x1::DependencyModule::{R, create_r};

    #[skip(lint_unused)]
    struct Dummy has copy, drop {}

    /// Stores R under the signer, or modifies it if it exists
    public entry fun do(s: &signer, v: u64) {
        if (exists<R>(signer::address_of(s))) {
            let r = borrow_global_mut<R>(signer::address_of(s));
            r.val = r.val + v;
        } else {
            move_to(s, R { val: v });
        }
    }

    /// A runner fn which calls do() multiple times
    public fun runner_for_do(s: &signer) {
        // Initial create with 10
        do(s, 10);
        // Modify with 5, total = 15
        do(s, 5);
        // Modify with 20, total = 35
        do(s, 20);
    }
}
//# run 0x1::TestModule::runner_for_do --signers 0x1

//# run
script {
    use 0x1::TestModule;

    fun main(account: signer) {
        // Run do() with different values
        TestModule::do(&account, 7);
        TestModule::do(&account, 3);
        // Run the runner function to aggregate multiple calls
        TestModule::runner_for_do(&account);
    }
}