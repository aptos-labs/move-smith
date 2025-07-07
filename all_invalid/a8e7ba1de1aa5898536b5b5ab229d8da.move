//# publish
module 0xCAFE::ErrorHandling {
    use std::error;
    use std::signer;
    use std::vector;

    const E_CUSTOM_ERROR: u64 = 1001;

    /// Custom error type
    struct CustomError has store {
        code: u64,
        message: vector<u8>,
    }

    public fun make_error(code: u64, message: vector<u8>): CustomError {
        CustomError { code, message }
    }

    public fun abort_with_custom_error(code: u64, message: vector<u8>) {
        // Abort with the code after printing message; Move abort halts VM execution
        // Normally logs won't be output, but this dummy function "reports" error by abort.
        abort code;
    }

    public fun test_abort_condition(flag: bool) {
        if (flag) {
            abort 777;
        }
    }

    #[test_only]
    public fun runner() {
        // Call abort_with_custom_error - this will abort with 1001
        // Normally abort stops execution, so in test only we just demonstrate the call
        // but this runner when called will abort.
        abort_with_custom_error(E_CUSTOM_ERROR, b"Custom error occurred");
    }
}

//# run 0xCAFE::ErrorHandling::runner --signers 0xCAFE

//# publish
module 0xCAFE::AbortHandling {
    public fun may_abort_in_sequence(input: u8) {
        // Sequence of instructions with an abort in between
        let x = input + 1;
        if (x > 10) {
            abort 999;
        };
        let y = x * 2;
    }

    public fun may_abort_conditional(input: u8) {
        if (input == 42) {
            abort 404;
        }
    }

    #[test_only]
    public fun runner() {
        // attempt conditional abort
        may_abort_conditional(42);
    }
}

//# run 0xCAFE::AbortHandling::runner --signers 0xCAFE

//# publish
module 0xCAFE::PackageVisibility {
    // 'package' visibility modifier example

    // Package-visible struct (only visible within same package boundaries)
    // Although Aptos Move supports package visibility, we emulate by marking 'public(package)'.

    struct PackageStruct has store {
        value: u64,
    }

    public(package) fun new_package_struct(): PackageStruct {
        PackageStruct { value: 12345 }
    }

    public fun public_function() {
        // we can call package visible function inside this module
        let _p = new_package_struct();
    }

    #[test_only]
    public fun runner() {
        public_function();
    }
}

//# run 0xCAFE::PackageVisibility::runner --signers 0xCAFE

// Featurres:
// d0b1590093892fcbd530e24213ca133e: Handle diagnostic errors with a custom error reporting mechanism
// 5f7075a36d764abe5db46b89ed424a8e: Test that the Move module correctly handles aborts within functions and terminates execution when an abort occurs during a conditional or sequence.
// 783d6142aafbae5e280c00a58b8b08a5: Declare module members with optional 'package' visibility modifier
