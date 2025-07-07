
//# publish
module 0xCAFE::LambdaTest {
    // Test 1: Function that adds two u8 values and returns a specific value
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let _sum = a + b;
        42u8
    }

    // Test 2: Function containing lambda (anonymous function) expressions
    public fun lambda_example(x: u8, y: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let c = a + b;
            let d = a * b;
            (c, d)
        };
        lambda(x, y)
    }

    // Public runner without arguments for Test 2
    public fun lambda_runner() {
        let (_c, _d) = lambda_example(2u8, 3u8);
    }
}


//# publish
module 0xCAFE::MyModule {
    // This module defines f2 that returns a tuple, required by CallingInline

    public fun f2(a: u16): (u16, u16) {
        let x = a + 1;
        let y = a + 2;
        (x, y)
    }
}


//# publish
module 0xCAFE::CallingInline {
    use 0xCAFE::MyModule;

    // Test 3: Call the inline function f2 from MyModule and use sum of tuple elements
    public fun call_inline_and_compute(a: u16): u16 {
        let (x, y) = MyModule::f2(a);
        x + y + a + 1u16
    }

    // Runner function without arguments for Test 3
    public fun runner() {
        let _res = call_inline_and_compute(10u16);
    }
}



//# run 0xCAFE::LambdaTest::add_and_return_fixed --args 10u8 20u8


//# run 0xCAFE::LambdaTest::lambda_example --args 5u8 6u8


//# run 0xCAFE::LambdaTest::lambda_runner


//# run 0xCAFE::CallingInline::call_inline_and_compute --args 15u16


//# run 0xCAFE::CallingInline::runner
