
//# publish
module 0xCAFE::LambdaTest {
    // Removed unused alias: std::signer

    // A simple addition function to test u8 additions
    public fun add_two(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 10u8
    }

    // Function that returns a lambda (anonymous function)
    public fun get_adder_lambda(): |u8, u8| u8 has copy+drop {
        |a: u8, b: u8| {
            let result = a + b;
            result
        }
    }

    // Since MyModule::f2 does not exist, implement the function here
    // Original call expects a function returning (u16, u16)
    public fun f2(x: u16): (u16, u16) {
        // For example, return (x, x + 1)
        (x, x + 1)
    }

    // Function that calls an inline function from the current module
    public fun nested_inline_call(x: u16): u16 {
        let (a, b) = f2(x);
        a + b
    }

    // Function to demonstrate handling unexpected types via error code (here use abort on input > 100)
    public fun check_value(x: u8) {
        assert!(x <= 100, 999); // abort with code 999 if x > 100
    }

    // Function to test a lambda with body usage inside Move
    public fun lambda_with_body(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            let intermediate = a * 2;
            let sum = intermediate + b;
            sum
        };
        lambda(x, y)
    }

    // Runner function to call all tests for running without args
    public fun runner() {
        let _ = add_two(5u8, 7u8);
        let adder = get_adder_lambda();
        let _ = adder(10u8, 15u8);
        let _ = nested_inline_call(12u16);
        check_value(42u8);

        // Uncommenting the following line would abort (test abort)
        // check_value(101u8);

        let _ = lambda_with_body(3u8, 4u8);
    }
}



//# run 0xCAFE::LambdaTest::add_two --args 12u8 13u8



//# run 0xCAFE::LambdaTest::get_adder_lambda



//# run 0xCAFE::LambdaTest::nested_inline_call --args 20u16



//# run 0xCAFE::LambdaTest::check_value --args 50u8



//# run 0xCAFE::LambdaTest::lambda_with_body --args 7u8 8u8



//# run 0xCAFE::LambdaTest::runner
