
//# publish
module 0xCAFE::MyModule {
    // Provide the inline function f2 as expected by NestedCall

    // Inline attribute and syntax depends on context; 
    // in Aptos Move, we generally just define it as a normal public function
    // but to match the test description, we assume f2 returns (a+1, a+2)

    public fun f2(a: u16): (u16, u16) {
        (a + 1, a + 2)
    }
}


//# publish
module 0xCAFE::LambdaTest {
    // Testing addition of two u8 values and returning a specific value

    public fun add_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        sum
    }

    public fun lambda_addition(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, y)
    }

    public fun wrapper() {
        let _ = add_and_return_sum(5u8, 10u8);
        let _ = lambda_addition(7u8, 8u8);
    }
}


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::LambdaTest;

    public fun call_inline_addition(a: u16): (u16, u16) {
        // Call the inline function f2 from 0xCAFE::MyModule implemented before
        // f2 is an inline function returning (a+1, a+2)
        0xCAFE::MyModule::f2(a)
    }

    public fun call_nested(a: u8, b: u8): u8 {
        // Call a function in LambdaTest that uses a lambda to sum two u8
        LambdaTest::lambda_addition(a, b)
    }

    public fun runner() {
        let (_p, _q) = call_inline_addition(100u16);
        let _sum = call_nested(25u8, 30u8);
    }
}
