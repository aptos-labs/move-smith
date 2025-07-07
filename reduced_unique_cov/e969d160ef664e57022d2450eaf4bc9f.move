
//# publish
module 0xCAFE::AddLambda {
    // A module to test addition and lambda functions and inline function cross-calls

    // Removed use 0xCAFE::MyModule; because it's unbound and invalid

    /// Provide an inline function f2 within this module to replace MyModule::f2
    public inline fun f2(a: u16): (u16, u16) {
        // Just return a tuple (a, a*2) for testing
        (a, a * 2)
    }

    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return sum + 5 just to test computation
        sum + 5
    }

    public fun lambda_test(): u8 {
        let adder: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            a + b
        };
        let x = 10u8;
        let y = 20u8;
        let result = adder(x, y);
        // Add 1 to test using the lambda result
        result + 1
    }

    public fun inline_call_test(a: u16): u16 {
        let (a1, a2) = Self::f2(a);
        // Return the sum of the tuple from inline function plus 10
        a1 + a2 + 10
    }
}



//# run 0xCAFE::AddLambda::add_and_return --args 3u8 4u8



//# run 0xCAFE::AddLambda::lambda_test



//# run 0xCAFE::AddLambda::inline_call_test --args 5u16
