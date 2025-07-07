
//# publish
module 0xCAFE::MyModule {
    // Define the required inline function f2 that returns two u16 values.
    public inline fun f2(x: u16): (u16, u16) {
        (x, x + 1)
    }
}

//# publish
module 0xCAFE::FeatureTest {
    // Removed unused import 'signer'

    // 1. Test a function that adds two u8 values then returns a fixed u8 value
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        let _ = sum;
        42u8
    }

    // 2. Function using explicit function references instead of lambdas (lambdas not supported in Move)
    fun sum_fn(a: u8, b: u8): u8 {
        a + b
    }

    fun product_fn(a: u8, b: u8): u8 {
        a * b
    }

    public fun lambda_example(x: u8, y: u8): u8 {
        // Call the named functions instead of lambdas
        let s = sum_fn(x, y);
        let p = product_fn(x, y);
        s + p
    }

    // 3. Using inline function from another module
    public fun call_my_module_f2(x: u16): u32 {
        // Call inline function f2 from 0xCAFE::MyModule, get two u16, add and return as u32
        let (a, b) = 0xCAFE::MyModule::f2(x);
        (a as u32) + (b as u32)
    }

    // 4. Deprecated function example
    // deprecated]
    public fun old_function(): u8 {
        100u8
    }

    // Runner without args exercising different functions
    public fun runner() {
        let _ = add_and_return_fixed(10, 20);
        let _ = lambda_example(3, 4);
        let _ = call_my_module_f2(5u16);
        let _ = old_function();
    }
}




//# run 0xCAFE::FeatureTest::add_and_return_fixed --args 25u8 17u8




//# run 0xCAFE::FeatureTest::lambda_example --args 7u8 8u8




//# run 0xCAFE::FeatureTest::call_my_module_f2 --args 12u16




//# run 0xCAFE::FeatureTest::old_function




//# run 0xCAFE::FeatureTest::runner
