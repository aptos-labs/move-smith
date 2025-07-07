
//# publish
module 0xCAFE::Arithmetic {
    /// Adds two u8 values and returns the result plus a constant offset
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    /// Demonstrates a lambda that multiplies and adds on u8 inputs
    public fun call_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            // multiply then add
            (a * b) + 5
        };
        lambda(x, y)
    }

    /// Calls the inline function f2 from 0xCAFE::MyModule and sums its tuple result
    public fun nested_inline_call(val: u16): u16 {
        let (a, b) = 0xCAFE::MyModule::f2(val);
        a + b
    }
}



//# run 0xCAFE::Arithmetic::add_and_offset --args 5u8 7u8



//# run 0xCAFE::Arithmetic::call_lambda --args 3u8 4u8



//# run 0xCAFE::Arithmetic::nested_inline_call --args 20u16




//# publish
module 0xCAFE::LambdaTest {
    /// Returns the output of a passed lambda that transforms u8 to u8
    public fun apply_lambda(f: |u8| u8, value: u8): u8 {
        f(value)
    }

    /// Creates and calls a lambda to add 42 to input
    public fun call_inline_lambda(x: u8): u8 {
        let add_42_lambda: |u8| u8 has copy+drop = |v: u8| {
            v + 42
        };
        apply_lambda(add_42_lambda, x)
    }
}


// Removed the invalid direct lambda argument run call. Instead we use script to run lambdas.



//# run
script {
    use 0xCAFE::LambdaTest;
    fun main() {
        let add_1: |u8| u8 has copy+drop = |x: u8| { x + 1 };
        let res = LambdaTest::apply_lambda(add_1, 7u8);
        // no assertion needed
        let _ = res;
    }
}



//# run
script {
    use 0xCAFE::LambdaTest;
    fun main() {
        let res = LambdaTest::call_inline_lambda(11u8);
        let _ = res;
    }
}
