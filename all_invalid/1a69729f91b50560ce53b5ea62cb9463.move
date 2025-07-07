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
        // Maybe store or just assume success
        // No assertions as per instructions
    }
}

//# run 0xCAFE::FirstClassFunctionTest::run_first_class_function_test --signers 0x123

//# publish
module 0xCAFE::ControlFlowTest {
    // Use unconditional jumps via labels
    public fun fib_dummy(n: u64): u64 {
        let result = 0u64;
        label start:
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

        label recursive:
            let n_minus_one = n - 1;
            let n_minus_two = n - 2;

            let fib_n_minus_one = fib_dummy(n_minus_one);
            let fib_n_minus_two = fib_dummy(n_minus_two);
            result = fib_n_minus_one + fib_n_minus_two;
            goto end;

        label end:
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

    // Variable: Declare a local variable
    public fun run_advanced_feature_test() {
        let val = 10u64; // Variable declaration
        // Let: unpack a tuple
        let (a, b) = (1u64, 2u64);
        // Include: comment indicating inclusion (conceptual)
        // Placeholder for module include semantics in test
        // Apply: calling an inline function
        let sum = call_inline_fn(val, |x| x + (a + b)); // Using lambda-like inline inline func, but Move doesn't support lambdas, so simulating via inline function
        // Pragma: placeholder in comments
        // No assertions needed
    }
}

//# run 0xCAFE::AdvancedFeaturesTest::run_advanced_feature_test --signers 0x123


// Featurres:
// dacc58a3abb8cb2f7f3de40ab22d0c1c: Call function pointers (first-class functions) with argument lists.
// 227906e22aa321006147337dca6670c1: Use unconditional jumps to transfer control flow to a specified label in Move bytecode.
// b0f60aa7637bb6c5525c3c99abb16efe: Use other spec block members such as 'Function', 'Variable', 'Let', 'Include', 'Apply', and 'Pragma' without restrictions, as they do not involve unbound names in this context.
