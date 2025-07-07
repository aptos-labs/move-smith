//# publish
module 0xCAFE::AttributeTest {
    /// Function that always aborts with error code 42
    #[abort]
    public fun fail() {
        abort 42;
    }

    /// Function with complex expressions
    public fun exprs() {
        let x = 1 + 2 * 3 / (4 - 2);
        let y = (x << 2) & 0xFF;
        let z = if x > 10 { y } else { x };
        let a = true && false || !false;
        let b = vector::empty<u8>();
        vector::push_back(&mut b, 7);
        let _ = vector::length(&b);
    }

    /// Function to be called from external call using the module function as address specifier
    public fun runner() {
        // call fail (which aborts) - but in testing we just want to compile and run, no assertions
        // We will call fail in a separate run so the abort won't block runner.
        let dummy = 10;
    }
}

//# run 0xCAFE::AttributeTest::runner --signers 0xCAFE

//# run 0xCAFE::AttributeTest::fail --signers 0xCAFE

//# publish
module 0xCAFE::Caller {
    use 0xCAFE::AttributeTest;

    public fun call_runner() {
        // Calling runner function from AttributeTest as address specifier and module name chain
        0xCAFE::AttributeTest::runner();
    }

    public fun call_fail() {
        // Calling fail (with abort attribute) from AttributeTest to check attribute apply syntax handling
        0xCAFE::AttributeTest::fail();
    }
}

//# run 0xCAFE::Caller::call_runner --signers 0xCAFE

//# run 0xCAFE::Caller::call_fail --signers 0xCAFE

//# run
script {
    use 0xCAFE::Caller;

    fun main(s: &signer) {
        // Call call_runner from script
        Caller::call_runner();

        // Call call_fail from script (expected to abort, just testing VM)
        // We will catch the abort or ignore, since no assertions are needed.
        Caller::call_fail();
    }
}

// Featurres:
// fcc9fee0cda6d242ce153b78b45832e0: Use attributes with apply syntax to specify attributes without parameters that signal expected failures.
// 1150e97b1d14b0647b6fb152fce63fd7: Write expressions in Move programs
// 3529fa9a355a147f5666efd952ea3c36: Call module functions as address specifiers, with optional type arguments, from a module's name chain.
