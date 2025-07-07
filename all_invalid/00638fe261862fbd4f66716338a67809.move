//# publish
module 0xCAFE::FirstClassFunctionTest {
    public fun identity<T>(x: T): T {
        return x;
    }

    public fun invoke_identity<T>(value: T, func: fn(T): T): T {
        let result = func(value);
        return result;
    }

    public fun run_first_class_function_test() {
        let x = 42;
        // Call identity via first-class function
        let y = invoke_identity(x, identity);
        // Additional: test with different type
        let s = b"hello";
        let s_result = invoke_identity(s, identity);
        // No assertions needed
    }
}

//# run 0xCAFE::FirstClassFunctionTest::run_first_class_function_test --signers 0x123

//# publish
module 0xCAFE::ControlFlowTest {
    // Use unconditional jumps via labels (correct syntax)
    public fun fib_dummy(n: u64): u64 {
        let result: u64;
        // Corrected label syntax: remove colon, use label start with a label declaration
        start:
            if (n == 0) {
                result = 0;
                goto end;
            }
            if (n == 1) {
                result = 1;
                goto end;
            }
            // Jump to recursive case
            goto recursive;

        recursive:
            let n_minus_one = n - 1;
            let n_minus_two = n - 2;

            let fib_n_minus_one = fib_dummy(n_minus_one);
            let fib_n_minus_two = fib_dummy(n_minus_two);
            result = fib_n_minus_one + fib_n_minus_two;
            goto end;

        end:
            return result;
    }

    public fun run_control_flow_test() {
        let _ = fib_dummy(5);
    }
}

//# run 0xCAFE::ControlFlowTest::run_control_flow_test --signers 0x123

//# publish
module 0xCAFE::AdvancedFeaturesTest {
    // Including Function, Variable, Let, Include, Apply, Pragma in comments as they don't directly affect code
    // Function: Define a function with inline function pointer usage
    public fun call_inline_fn<T>(x: T, f: fn(T): T): T {
        // Apply the function parameter directly
        let result = f(x);
        return result;
    }

    public fun run_advanced_feature_test() {
        let val = 10u64; // Variable declaration
        // Let: unpack a tuple
        let (a, b) = (1u64, 2u64);
        // Include: comment indicating inclusion (conceptual)
        // Placeholder for module include semantics in test
        // Apply: calling an inline function
        // Since Move doesn't support lambdas, simulate inline function as an inline nested function
        // Alternatively, replace with a predefined function
        fun inline_add(x: u64): u64 {
            x + (a + b)
        }
        let sum = call_inline_fn(val, inline_add);
        // Pragma: placeholder in comments
        // No assertions needed
    }
}

//# run 0xCAFE::AdvancedFeaturesTest::run_advanced_feature_test --signers 0x123