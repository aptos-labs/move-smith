//# publish
module 0x100::TestInline {
    // Define inline functions that will be passed as arguments
    inline fun multiply(f: |u64| u64, g: |u64| u64, x: u64): u64 {
        f(x) * g(x)
    }

    // Example: define a test function that passes in inline lambdas
    public fun test_multiply() {
        // Pass lambdas that double and triple the input
        let result = multiply(
            |x: u64| x * 2,
            |x: u64| x * 3,
            7
        );
        // Expect 14 * 21 = 294
        assert!(result == 294, 0);
    }

    // A runner function to call the test without args
    public fun run_all_tests() {
        test_multiply();
    }
}

//# run 0x100::TestInline::run_all_tests

//# publish
module 0x100::TestApplyNested {
    // Define an inline apply function that takes a function and arguments
    public inline fun apply(f: |u64, u64| u64, x: u64, y: u64): u64 {
        f(x, y)
    }

    // Test nested apply calls
    public fun test_apply() {
        let inner_result = apply(|a: u64, b: u64| a + b, 4, 5); // 9
        let outer_result = apply(|a: u64, b: u64| a * b, inner_result, 2); // 9 * 2 = 18
        assert!(outer_result == 18, 0);
    }

    public fun run_all() {
        test_apply();
    }
}

//# run 0x100::TestApplyNested::run_all

//# publish
module 0x100::TokenValueTest {
    use 0x42::objects as obj;

    struct TestToken has key { val: u64 }

    public fun create_token(signer: &signer, owner: &obj::OwnerRef, initial: u64) {
        obj::create(signer, owner, TestToken { val: initial });
    }

    public fun get_token_value(ref: &obj::ReaderRef<TestToken>): u64 {
        obj::reader(ref).val
    }

    public fun set_token_value(ref: &obj::WriterRef<TestToken>, new_val: u64) {
        obj::writer(ref).val = new_val;
    }

    // A function to test create, read, update, and verify via assertions
    public fun test_token_value() {
        let signer_addr = @0x100;
        // Create owner ref
        let owner_ref = obj::make_owner_ref(signer_addr);
        // Create token with initial value
        create_token(&signer_addr, &owner_ref, 50);
        let rr = obj::reader_ref(&owner_ref);
        let wr = obj::writer_ref(&owner_ref);
        let val = get_token_value(&rr);
        assert!(val == 50, 0);
        // Update token value
        set_token_value(&wr, 100);
        let updated_val = get_token_value(&rr);
        assert!(updated_val == 100, 1);
    }

    public fun run_token_test() {
        test_token_value();
    }
}

//# run 0x100::TokenValueTest::run_token_test