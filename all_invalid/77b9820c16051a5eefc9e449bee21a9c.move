//# publish
module 0x1::TestOptionalTypeParam {

    #[skip(lint_all)]
    public fun runner() {
        // This function is just a runner placeholder 
        // to ensure the module compiles.
    }

    /// A generic struct with an optional type parameter T.
    struct Container<T> has copy, drop, store {
        value: T,
    }

    /// A function that uses the generic Container<T>
    public fun make_container<T>(val: T): Container<T> {
        Container<T> { value: val }
    }

    /// A function that uses a lambda capturing a public function
    public fun with_lambda() {
        let f = &Self::public_fn;
        f();
    }

    public fun public_fn() {
        // public function captured by lambda
    }

    /// A function capturing a private fn inside a lambda (private, so no store required on fn)
    fun private_fn() {
        // do nothing
    }

    public fun lambda_with_private() {
        let f = &private_fn;
        f();
    }
}
# run 0x1::TestOptionalTypeParam::runner

//# publish
module 0x1::TestSkipLint {

    // Skipping multiple lint checks for this function
    #[skip(unused_variable, non_camel_case_types, ambiguous_spec_fun)]
    public fun skip_lints_example() {
        let unused_var = 42;
        let _AnotherThing: u8 = 5;
    }

    public fun runner() {
        skip_lints_example();
    }
}
# run 0x1::TestSkipLint::runner

//# publish
module 0x1::TestFunctionBodies {

    public fun runner() {
        let x = add(10, 20);
        let _ = multiply(x, 3);
    }

    public fun add(a: u64, b: u64): u64 {
        a + b
    }

    public fun multiply(a: u64, b: u64): u64 {
        a * b
    }
}
# run 0x1::TestFunctionBodies::runner

//# publish
module 0x1::TestStoreAbility {

    // public function captured by lambda -> function has store ability
    public fun public_captured() {}

    /// This private function does not have store ability, it's captured by a lambda in public func
    fun private_captured() {}

    public fun run_lambda() {
        let f_pub = &Self::public_captured;
        f_pub();

        let f_pri = &private_captured;
        f_pri();
    }

    /// Public function marked persistent, so it will have store ability
    #[persistent]
    public fun persistent_fn() {}

    public fun run_persistent_lambda() {
        let f = &Self::persistent_fn;
        f();
    }

    public fun runner() {
        run_lambda();
        run_persistent_lambda();
    }
}
# run 0x1::TestStoreAbility::runner

//# run
script {
    use 0x1::TestOptionalTypeParam;
    use 0x1::TestSkipLint;
    use 0x1::TestFunctionBodies;
    use 0x1::TestStoreAbility;

    fun main(account: signer) {
        // Run container generic creation
        let c = TestOptionalTypeParam::make_container<u64>(100);
        // Run with lambdas
        TestOptionalTypeParam::with_lambda();
        TestOptionalTypeParam::lambda_with_private();

        // Run skip lints example
        TestSkipLint::skip_lints_example();

        // Run arithmetic functions
        assert!(TestFunctionBodies::add(2, 3) == 5, 0);
        assert!(TestFunctionBodies::multiply(4, 5) == 20, 1);

        // Run lambdas with store ability functions
        TestStoreAbility::run_lambda();
        TestStoreAbility::run_persistent_lambda();
    }
}