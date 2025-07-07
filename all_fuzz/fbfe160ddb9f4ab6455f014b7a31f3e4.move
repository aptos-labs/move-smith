
//# publish
module 0xCAFE::FnTest {
    // Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    // Write a function that returns a lambda which adds a number to captured value x
    public fun create_adder(x: u8): |u8|u8 {
        |y: u8| {
            x + y
        }
    }

    // Write a function that calls the above lambda and returns the result
    public fun use_adder(x: u8, y: u8): u8 {
        let adder = create_adder(x);
        adder(y)
    }
}


//# run 0xCAFE::FnTest::add_and_return_sum --args 12u8 30u8


//# run 0xCAFE::FnTest::use_adder --args 7u8 8u8


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::FnTest;

    // Test that calling an inline function from one module within another module works correctly.
    // We call FnTest::add_and_return_sum twice and add results.
    public fun nested_calls(a: u8, b: u8, c: u8, d: u8): u8 {
        let first_sum = FnTest::add_and_return_sum(a, b);
        let second_sum = FnTest::add_and_return_sum(c, d);
        first_sum + second_sum
    }

    // Call the lambda create_adder inside FnTest and use it to add two numbers nestedly
    public fun nested_lambda_use(x: u8, y: u8): u8 {
        let add_x = FnTest::create_adder(x);
        let add_y = FnTest::create_adder(y);
        let temp = add_x(y);
        add_y(temp)
    }
}


//# run 0xCAFE::InlineCaller::nested_calls --args 1u8 2u8 3u8 4u8


//# run 0xCAFE::InlineCaller::nested_lambda_use --args 5u8 6u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
