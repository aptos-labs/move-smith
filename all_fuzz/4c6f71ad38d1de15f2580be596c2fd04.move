
//# publish
module 0xCAFE::LambdaTest {

    // Since 0xCAFE::MyModule does not exist and cannot be referenced,
    // We provide an inline implementation of f2 here to fix the compilation errors.

    // For the purpose of this test, define f2 as a public function here.
    // f2 takes a u16 and returns a tuple of two u16 values.
    public fun f2(x: u16): (u16, u16) {
        // just split x arbitrarily, example:
        (x / 2, x - (x / 2))
    }

    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // return sum + 1 (arbitrary choice to test calculation)
        sum + 1
    }

    public fun lambda_add(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }

    public fun nested_inline_call(x: u16): u16 {
        // Call the local f2 function instead of the missing MyModule::f2
        let (a, b) = f2(x);
        a + b
    }
}



//# run 0xCAFE::LambdaTest::add_and_return_sum --args 10u8 20u8



//# run 0xCAFE::LambdaTest::lambda_add --args 15u8 25u8



//# run 0xCAFE::LambdaTest::nested_inline_call --args 100u16
