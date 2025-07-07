module 0x1::TransactionalTest {
    use std::signer;
    use std::vector;
    use std::assert;
    use 0x1::MyModule;

    // Constants
    const ABORT_CODE: u64 = 100;

    // Structs
    struct TestStruct {
        value: u64,
        label: vector<u8>,
    }

    // Enums
    enum Status {
        Success,
        Failed,
        Pending,
    }

    // Package-private function (public within this module)
    public fun process_value(val: u64): u64 {
        val + 42
    }

    // Inline function returning a tuple
    fun inline_tuple(a: u64, b: u64): (u64, u64) {
        (a + 1, b + 2)
    }

    // Function demonstrating match with multiple variants
    fun handle_status(s: Status): u64 {
        match s {
            Status::Success => 0,
            Status::Failed => 1,
            Status::Pending => 2,
        }
    }

    // Function with assertion and custom abort code
    public fun assert_success(flag: bool) {
        if (!flag) {
            abort ABORT_CODE;
        }
    }

    // Function using a lambda (closure)
    public fun lambda_example(x: u64, y: u64): u64 {
        let add = |a: u64, b: u64| -> u64 { a + b };
        add(x, y)
    }

    // Function calling a lambda with arguments
    public fun call_lambda_with_args(a: u64, b: u64): u64 {
        let multiply = |n: u64, m: u64| -> u64 { n * m };
        multiply(a, b)
    }

    // Function handling vector literal
    public fun vector_literal(): vector<u8> {
        vector::empty<u8>()
    }

    // Function handling byte-string literal
    public fun byte_string_literal(): vector<u8> {
        b"Hello, Aptos!"
    }

    // Function demonstrating safe variable handling without explicit 'let'
    public fun safe_variable_usage(s: &signer): u64 {
        process_value(signer::public_key(s))
    }

    // Cross-module call with explicit address and signer
    public fun call_external_module(s: &signer) {
        MyModule::external_function(s);
    }

    // Main test function
    public fun run_tests(s: &signer) {
        // Call package-private function internally
        let result = process_value(10);
        assert::require(result == 52, &"Processing value failed");

        // Inline tuple
        let (a, b) = inline_tuple(5, 6);
        assert::require(a == 6 && b == 8, &"Inline tuple mismatch");

        // Match enum
        let status_code = handle_status(Status::Failed);
        assert::require(status_code == 1, &"Status handling failed");

        // Assert success
        assert_success(true);
        // Commented out to avoid abort during test
        // assert_success(false);

        // Lambdas
        let sum = lambda_example(3, 4);
        assert::require(sum == 7, &"Lambda addition failed");

        let product = call_lambda_with_args(4, 5);
        assert::require(product == 20, &"Lambda multiplication failed");

        // Vector literals
        let vec = vector_literal();
        assert::require(vector::is_empty(&vec), &"Vector should be empty");

        // Byte string literal
        let bytes = byte_string_literal();
        assert::require(vector::length(&bytes) > 0, &"Byte string should not be empty");

        // Safe variable usage
        let pk_result = safe_variable_usage(s);
        assert::require(pk_result > 0, &"Signer key processing failed");

        // Cross-module call
        call_external_module(s);
    }
}