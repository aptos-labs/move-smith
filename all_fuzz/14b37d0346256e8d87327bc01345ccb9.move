
//# publish
module 0xCAFE::AddModule {
    // Module to test addition of two u8 values and returning a fixed u8 value
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        // let sum = a + b; // unused variable, removed as per warning
        42u8
    }
}



//# run 0xCAFE::AddModule::add_and_return_fixed --args 10u8 15u8



//# publish
module 0xCAFE::LambdaModule {
    // Module to test lambda expressions

    // A function returning a u8 by using a lambda to multiply by 2
    public fun double_with_lambda(x: u8): u8 {
        let doubler: |u8| u8 has copy+drop = |value: u8| {
            value * 2
        };
        doubler(x)
    }

    // Function to test lambda with captured values
    public fun add_and_multiply_with_lambda(a: u8, b: u8): u8 {
        let multiplier = 3u8;
        // The lambda captures multiplier by copy (since u8 is copy), allowed
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            (x + y) * multiplier
        };
        lambda(a, b)
    }

    // Runner function with no args to test lambdas
    public fun runner() {
        let _ = double_with_lambda(5u8);
        let _ = add_and_multiply_with_lambda(2u8, 3u8);
    }
}



//# run 0xCAFE::LambdaModule::double_with_lambda --args 7u8



//# run 0xCAFE::LambdaModule::add_and_multiply_with_lambda --args 4u8 5u8



//# run 0xCAFE::LambdaModule::runner



//# publish
module 0xCAFE::MyModule {
    // We declare the expected inline function f2 here as an example,
    // since 0xCAFE::MyModule does not exist externally.
    // For the test to compile and run, we need to define f2 inline here.

    // Example inline function that returns a tuple (u16, u16).
    public inline fun f2(x: u16): (u16, u16) {
        // Just an example: return (x, x + 1)
        (x, x + 1)
    }
}



//# publish
module 0xCAFE::CallInlineModule {
    use 0xCAFE::MyModule;

    // Function in CallInlineModule that calls MyModule::f2 inline function twice and returns sum of first components
    public fun nested_inline_call(x: u16): u16 {
        let (a1, _b1) = MyModule::f2(x);
        let (a2, _b2) = MyModule::f2(a1);
        a1 + a2
    }

    // Runner function which calls nested_inline_call with a test input
    public fun runner() {
        let _res = nested_inline_call(10u16);
    }
}



//# run 0xCAFE::CallInlineModule::nested_inline_call --args 20u16



//# run 0xCAFE::CallInlineModule::runner
