
//# publish
module 0xCAFE::LambdaTest {
    use std::signer; // Warning about unused alias; can safely remove to clean up, but not an error.

    // Simple function to add two u8, then return a fixed u8 value
    public fun add_then_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // fixed return value 42, sum checked but not returned
        let _unused = sum;
        42u8
    }

    // Function containing a lambda that captures one argument and returns its doubled value
    public fun lambda_double(x: u8): u8 {
        let double_fn: |u8| u8 has copy+drop = |v: u8| {
            v + v
        };
        double_fn(x)
    }

    // Function with lambda capturing outer variable and returning tuple
    public fun lambda_tuple_sum_product(x: u8, y: u8): (u8, u8) {
        let f: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            (a + b, a * b)
        };
        f(x, y)
    }
}



//# run 0xCAFE::LambdaTest::add_then_return_fixed --args 10u8 32u8



//# run 0xCAFE::LambdaTest::lambda_double --args 21u8



//# run 0xCAFE::LambdaTest::lambda_tuple_sum_product --args 3u8 7u8



//# publish
module 0xCAFE::InlineCallTest {
    use 0xCAFE::LambdaTest;

    // Inline function explicitly declared with return type, returns sum of two u8
    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    // Function calls inline_add, then uses LambdaTest::lambda_double and returns sum of results
    public fun inline_and_lambda_ops(a: u8, b: u8): u8 {
        let sum = inline_add(a, b);
        let doubled_sum = LambdaTest::lambda_double(sum);
        sum + doubled_sum
    }
}



//# run 0xCAFE::InlineCallTest::inline_and_lambda_ops --args 5u8 10u8



//# publish
module 0xCAFE::DiagnosticsTest {
    // This module defines a function that associates a diagnostic message with a range in source code
    // It purposely aborts with an error code and diagnostic location to test diagnostics reporting

    // Dummy struct to simulate diagnostic info
    struct DiagnosticInfo has copy, drop {
        code: u64,
        start_pos: u64,
        end_pos: u64,
        msg: vector<u8>,
    }

    // Function that aborts with diagnostic info (simulated via assert failure and error code)
    public fun trigger_diagnostic_error() {
        let diag = DiagnosticInfo {
            code: 777,
            start_pos: 10,
            end_pos: 20,
            msg: b"Error: invalid operation at source range 10-20"
        };
        // We cannot really attach diagnostics in Move but assert with code 777 simulates
        assert!(false, diag.code);
    }
}



//# run 0xCAFE::DiagnosticsTest::trigger_diagnostic_error



//# publish
module 0xCAFE::InternalBytecodeVerifier {
    // Function that triggers an internal bytecode verifier error by forcefully aborting with specific code
    public fun trigger_internal_verification_error() {
        abort 9999;
    }
}



//# run 0xCAFE::InternalBytecodeVerifier::trigger_internal_verification_error



//# publish
module 0xCAFE::OptionalTypeBound {
    // Simple Option container inside this module
    struct Option<T> has copy, drop {
        value: T,
        is_some: bool,
    }

    public fun some<T>(val: T): Option<T> {
        Option { value: val, is_some: true }
    }

    public fun none<T>(): Option<T> {
        Option { value: move_from_default(), is_some: false }
    }

    public fun borrow<T>(opt: &Option<T>): &T {
        assert!(opt.is_some, 1000);
        &opt.value
    }

    public fun unwrap_or<T: copy>(opt: &Option<T>, def_val: &T): T {
        if (opt.is_some) {
            *(&opt.value)
        } else {
            *def_val
        }
    }

    fun move_from_default<T>(): T {
        // We cannot create default for T, just abort to satisfy
        abort 1234;
    }

    // Function that declares a bound variable with explicit optional type annotation
    public fun optional_type_bound_explicit() {
        let opt: Option<u8> = some(10u8);  // changed from Option::some to some (within module)
        // Another let bound variable with explicit type annotation
        let x: u8 = 5u8;
        let _ = x + unwrap_or(borrow(&opt), &0u8);  // use module's own functions
    }
}



//# run 0xCAFE::OptionalTypeBound::optional_type_bound_explicit
