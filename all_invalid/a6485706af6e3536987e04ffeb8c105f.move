//# publish
module 0xA550C18::FeatureTest {
    use std::signer;
    use std::vector;

    /// A resource to be used within the module
    struct R has key {
        val: u64,
    }

    /// Initialize resource R under the caller's account
    public fun init(account: &signer) {
        move_to(account, R { val: 0 });
    }

    #[skip(lint_arithmetic, lint_unused_variables)]
    /// Function with optional type param, modifies R based on input
    public fun do<T>(account: &signer, v: u64) {
        let r = borrow_global_mut<R>(signer::address_of(account));
        if (v > 10) {
            // condition block with an expression
            r.val = r.val + v;
        } else {
            r.val = r.val + 1;
        };
    }

    /// Runner function to test do() function without args
    public fun runner(account: &signer) {
        init(account);
        // Will add 11 since 11 > 10
        do(account, 11);
        // Will add 1 since 5 <= 10
        do(account, 5);
    }
}
//# run 0xA550C18::FeatureTest::runner --signers 0xA550C18


//# publish
module 0xBEEF::Dependency {
    /// Dependency module just exposing a constant
    const MAGIC: u64 = 42;

    public fun get_magic(): u64 {
        MAGIC
    }
}
//# run 0xBEEF::Dependency::get_magic


//# publish
module 0xA550C18::UseDependency {
    use 0xBEEF::Dependency;

    public fun check_magic(): u64 {
        let val = Dependency::get_magic();
        val
    }

    #[skip(lint_unused_variables)]
    public fun with_generic<T>(input: T): u64 {
        let v = 5;
        if (v < 10) {
            100
        } else {
            200
        }
    }

    public fun runner() {
        let _ = check_magic();
        let _ = with_generic<u8>(0);
    }
}
//# run 0xA550C18::UseDependency::runner


//# run
script {
    use 0xA550C18::FeatureTest;
    use 0xA550C18::UseDependency;

    fun main(account: signer) {
        FeatureTest::init(&account);
        FeatureTest::do(&account, 15);
        FeatureTest::do(&account, 5);

        let magic = UseDependency::check_magic();
        let g = UseDependency::with_generic<u64>(123);

        // no asserts needed per instructions
    }
}