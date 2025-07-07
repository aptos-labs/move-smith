// # publish
module 0xCAFE::LambdaTest {
    use std::vector;

    //
    // This module tests inline functions accepting multiple lambdas with different parameter patterns
    // and usage of functions inside specification for verification.
    //

    // Function that takes two closures (as function types) and invokes them with provided params,
    // returns the combined result (proof/verification style)
    public inline fun call_two_lambdas<u8>(
        func_a: &fun(u8) : u8,
        func_b: &fun(u8, u8) : u8,
        x: u8,
        y: u8,
    ): u8 {
        // Call the first function with x
        let res_a = (*func_a)(x);
        // Call the second function with x and y
        let res_b = (*func_b)(x, y);
        res_a + res_b
    }

    // An inline function that calls a Move function normally and inside spec to verify equivalence
    public inline fun double_value(x: u64): u64 {
        2 * x
    }

    // Function that calls double_value from within a spec block
    public fun assert_double_value(x: u64) {
        spec {
            let res = double_value(x);
            // No assertions needed, just exercising usage
            let _ = res;
        }
    }

    // Runner function for testing call_two_lambdas inline function
    public fun runner(): u8 {
        // Define two inline anonymous functions (closures)
        // 1st: takes one u8 and returns u8 (identity + 1)
        let f1 = &fun(x: u8): u8 {
            x + 1
        };
        // 2nd: takes two u8 and returns u8 (sum)
        let f2 = &fun(a: u8, b: u8): u8 {
            a + b
        };

        call_two_lambdas(f1, f2, 5, 10) // expect (5+1) + (5+10) = 6 + 15 = 21
    }
}
// # run 0xCAFE::LambdaTest::runner --signers 0xCAFE

// # run
script {
    use 0xCAFE::LambdaTest;

    fun main(account: signer) {
        // We just call the runner function 
        let res: u8 = LambdaTest::runner();
        // Call the function inside module that uses spec block
        LambdaTest::assert_double_value(10);

        // Do not output anything; just calling them exercises compiler and VM.
        let _ = res;
    }
}

// Featurres:
// df481cc962cb6002eb2360c53f0fa1a7: In script modules, do not use lambda-lifted functions, as lambda lifting is disallowed in scripts.
// 2361c4c3cb440a92fc9ecbe5170e550c: Test that inline function parameters can accept and correctly invoke multiple lambda (closure) arguments with different parameter patterns.
// 9ef46790f73a4b2d6cabd8cc8f268480: Call Move functions from within specifications, and have them automatically converted to specification functions for use in proofs and verification.
