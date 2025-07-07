//# publish
module 0x1::TestModule {
    use std::signer;

    #[skip(lint_foo, lint_bar)]
    struct R has key {
        value: u64,
    }

    /// Creates the resource R with initial value 0 under the signer
    public fun init_resource(account: &signer) {
        move_to(account, R { value: 0 });
    }

    /// The do function modifies or interacts with R based on v
    /// If v is even, increment value by v
    /// If v is odd, decrement value by v
    public fun do(account: &signer, v: u64) {
        let r = borrow_global_mut<R>(signer::address_of(account));
        if (v % 2 == 0) {
            r.value = r.value + v;
        } else {
            r.value = r.value - v;
        }
    }

    /// A package-visibility function accessible only within this package
    package fun internal_increment(account: &signer, inc: u64) {
        let r = borrow_global_mut<R>(signer::address_of(account));
        r.value = r.value + inc;
    }

    /// A pure function that returns the input value unchanged
    public fun dead(x: u64): u64 {
        x
    }

    /// Runner function with no arguments, that exercises do() with v = 10 and v = 3
    public fun runner(account: &signer) {
        init_resource(account);
        do(account, 10);
        do(account, 3);
        internal_increment(account, 7);
        let _ = dead(42);
    }
}
//# run 0x1::TestModule::runner --signers 0x1


//# run
script {
    use 0x1::TestModule;
    use std::signer;

    fun main(account: &signer) {
        // Test init_resource and do() function
        TestModule::init_resource(account);
        TestModule::do(account, 4);  // even, should increment
        TestModule::do(account, 5);  // odd, should decrement

        // Call package function through runner in module cannot be called here
        // Call dead function and ignore return value
        let _ = TestModule::dead(123);
    }
}