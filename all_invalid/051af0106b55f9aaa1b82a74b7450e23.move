
//# publish
module 0xDEAD::ArithmeticTest {
    use std::assert;

    // Constants for boundary testing
    const MAX_U32: u32 = 4294967295;

    // Function to test addition, ensuring no overflow
    public fun test_add(x: u32, y: u32): u32 {
        let result = x + y;
        result
    }

    // Function to test subtraction, ensuring no underflow
    public fun test_sub(x: u32, y: u32): u32 {
        let result = x - y;
        result
    }

    // Function to test multiplication, ensuring no overflow
    public fun test_mul(x: u32, y: u32): u32 {
        let result = x * y;
        result
    }

    // Function to test division; expects divisor != 0
    public fun test_div(x: u32, y: u32): u32 {
        let result = x / y;
        result
    }

    // Function to test modulo; expects divisor != 0
    public fun test_mod(x: u32, y: u32): u32 {
        let result = x % y;
        result
    }

    // Function to test division by zero, should abort
    public fun test_div_zero(x: u32): u32 {
        let _ = x / 0;
        0 // placeholder; should not reach here
    }

    // Function to test modulo by zero, should abort
    public fun test_mod_zero(x: u32): u32 {
        let _ = x % 0;
        0 // placeholder; should not reach here
    }

    // Inline function to add two u32
    public inline fun inline_add(a: u32, b: u32): u32 {
        a + b
    }

    // Inline function to multiply two u32
    public inline fun inline_mul(a: u32, b: u32): u32 {
        a * b
    }

    // Wrapper function that calls inline functions
    public fun call_inlined_functions(x: u32, y: u32): (u32, u32) {
        let sum = inline_add(x, y);
        let prod = inline_mul(x, y);
        (sum, prod)
    }
}


//# run 0xDEAD::ArithmeticTest::test_add --args 0 0

//# run 0xDEAD::ArithmeticTest::test_add --args 4294967295 0

//# run 0xDEAD::ArithmeticTest::test_add --args 4294967295 1 // Expect overflow (compile-time or runtime error)


//# run 0xDEAD::ArithmeticTest::test_sub --args 0 0

//# run 0xDEAD::ArithmeticTest::test_sub --args 0 1 // Expect underflow (compile-time or runtime error)

//# run 0xDEAD::ArithmeticTest::test_sub --args 4294967295 4294967295


//# run 0xDEAD::ArithmeticTest::test_mul --args 0 100

//# run 0xDEAD::ArithmeticTest::test_mul --args 4294967295 1 // Max * 1

//# run 0xDEAD::ArithmeticTest::test_mul --args 65536 65536 // Should overflow (if checked)


//# run 0xDEAD::ArithmeticTest::test_div --args 10 2

//# run 0xDEAD::ArithmeticTest::test_div --args 4294967295 1

//# run 0xDEAD::ArithmeticTest::test_div --args 10 0 // Expect abort


//# run 0xDEAD::ArithmeticTest::test_mod --args 10 3

//# run 0xDEAD::ArithmeticTest::test_mod --args 4294967295 2

//# run 0xDEAD::ArithmeticTest::test_mod --args 10 0 // Expect abort


//# run 0xDEAD::ArithmeticTest::call_inlined_functions --args 2 3

// Additional tests for boundary values and interaction with the language constructs


//# publish
module 0xBADD::ComplexLangFeatures {
    use std::assert;

    // Struct to store results of operations
    struct ResultHolder has copy, drop, store {
        add_result: u32,
        sub_result: u32,
        mul_result: u32,
        div_result: u32,
        mod_result: u32,
    }

    // Function creating and using struct
    public fun test_structs_and_calls(a: u32, b: u32): ResultHolder {
        let add_res = 0xDEAD::ArithmeticTest::test_add(a, b);
        let sub_res = 0xDEAD::ArithmeticTest::test_sub(a, b);
        let mul_res = 0xDEAD::ArithmeticTest::test_mul(a, b);
        let div_res = 0xDEAD::ArithmeticTest::test_div(a, b);
        let mod_res = 0xDEAD::ArithmeticTest::test_mod(a, b);
        ResultHolder {add_result: add_res, sub_result: sub_res, mul_result: mul_res, div_result: div_res, mod_result: mod_res}
    }

    // Function calling other functions with complex logic
    public fun combined_operations(x: u32, y: u32): u32 {
        if (y != 0) {
            let sum = 0xDEAD::ArithmeticTest::inline_add(x, y);
            let product = 0xDEAD::ArithmeticTest::inline_mul(x, y);
            sum + product
        } else {
            // check boundary condition for division
            let div_res = 0xDEAD::ArithmeticTest::test_div(x, y); // should abort
            div_res
        }
    }

    // Function testing boundary and overflow
    public fun boundary_test() {
        let max = 4294967295;
        // addition overflow test
        let _ = 0xDEAD::ArithmeticTest::test_add(max, 1);
        // subtraction test
        let _ = 0xDEAD::ArithmeticTest::test_sub(0, 1); // underflow
        // multiplication overflow test
        let _ = 0xDEAD::ArithmeticTest::test_mul(max, 2);
    }
}


//# run 0xBADD::ComplexLangFeatures::test_structs_and_calls --args 4294967295 1


//# run 0xBADD::ComplexLangFeatures::combined_operations --args 10 20


//# run 0xBADD::ComplexLangFeatures::boundary_test


// Featurres:
// 60fb167a5e1439f457e846cb5b6ab42d: Test the correctness and overflow/underflow behavior of all arithmetic operations (+, -, *, /, %) on the u32 type, including boundary values and division/modulo by zero.
// 577f5648eeb8818c01d41906992bf110: Define modules, scripts, structs, functions, and other language definitions in your Move source files that are parsed by the compiler.
// 2df2adbcfaac94eed90f8691d9301a14: Define functions as inline to enable their bodies to be checked after inlining.
