
//# publish
module 0xCAFE::ArithmeticTest {
    use std::signer;

    public fun add_two_u8(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return a fixed value after addition to test the computation is done before return
        42u8
    }

    public fun lambda_example(x: u8, y: u8): u8 {
        let add: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add(x, y)
    }

    public inline fun inline_addition(a: u16, b: u16): u16 {
        a + b
    }

    public inline fun inline_multiplication(a: u16, b: u16): u16 {
        a * b
    }

    public fun test_unsigned_16bit_arithmetic(a: u16, b: u16): (u16, u16, u16, u16, u16) {
        let addition = a + b;
        let subtraction = if (a > b) { a - b } else { 0 };
        let multiplication = a * b;
        let division = if (b != 0) { a / b } else { 0 };
        let modulus = if (b != 0) { a % b } else { 0 };
        (addition, subtraction, multiplication, division, modulus)
    }

    public fun test_abort_annotations(x: u8) {
        // Abort with code 777 if x == 0
        if (x == 0) {
            abort 777;
        };

        // Abort with code 888 if x > 10
        if (x > 10) {
            abort 888;
        };
    }
}


//# publish
module 0xCAFE::CallInline {
    use 0xCAFE::ArithmeticTest;

    public fun call_inline_functions(x: u16, y: u16): u16 {
        let sum = ArithmeticTest::inline_addition(x, y);
        let product = ArithmeticTest::inline_multiplication(x, y);
        // Return sum + product to test nested inline calls
        sum + product
    }
}


//# run 0xCAFE::ArithmeticTest::add_two_u8 --args 10u8 32u8


//# run 0xCAFE::ArithmeticTest::lambda_example --args 5u8 7u8


//# run 0xCAFE::CallInline::call_inline_functions --args 3u16 4u16


//# run 0xCAFE::ArithmeticTest::test_unsigned_16bit_arithmetic --args 100u16 25u16


//# run 0xCAFE::ArithmeticTest::test_abort_annotations --args 1u8


//# run 0xCAFE::ArithmeticTest::test_abort_annotations --args 11u8


//# run 0xCAFE::ArithmeticTest::test_abort_annotations --args 0u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 30fa5ff5160a19cb6ededf5b95f31a5d: Import modules using 'use' instead of 'import'.
// 527abebfabb1ebd69e625fa68b433419: Test that unsigned 16-bit integer arithmetic operations (addition, subtraction, multiplication, division, and modulus) behave correctly for valid inputs and properly fail or trigger errors on overflows or divisions by zero।
// a921df2a3e5dbeb0115cdd5d0717c761: Format and display abort state annotations within a function.
