
//# publish
module 0xCAFE::FeatureTest {
    /// Adds two u8 values and returns the sum incremented by 5.
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 5
    }

    /// Demonstrates lambda expressions by returning a lambda and using it internally.
    public fun lambda_demo(x: u8, y: u8): u8 {
        // Lambda that multiplies two u8 values
        let multiplier: |u8, u8| u8 has copy + drop = |a: u8, b: u8| a * b;
        let product = multiplier(x, y);

        // Lambda that adds a value to 10
        let adder: |u8| u8 has copy + drop = |v: u8| v + 10u8;

        adder(product)
    }

    /// Private helper function mimicking MyModule::f2: takes u16 and returns tuple (value, value + 1)
    fun f2(x: u16): (u16, u16) {
        (x, x + 1)
    }

    /// Calls an inline function from MyModule and returns one element of the tuple.
    /// Since MyModule::f2 is missing, call local helper f2 instead.
    public fun call_inline_f2_from_mymodule(value: u16): u16 {
        let (first, _second) = f2(value);
        first
    }

    /// Assigns a value within if-else condition and returns it.
    public fun conditional_return(flag: bool): u8 {
        let result: u8;
        if (flag) {
            result = 42u8;
        } else {
            result = 100u8;
        };
        result
    }

    /// Runner function to call all above functions with some example arguments.
    public fun runner() {
        let _ = add_and_offset(10u8, 20u8);
        let _ = lambda_demo(3u8, 4u8);
        let _ = call_inline_f2_from_mymodule(5u16);
        let _ = conditional_return(true);
        let _ = conditional_return(false);
    }
}


//# run 0xCAFE::FeatureTest::add_and_offset --args 10u8 20u8


//# run 0xCAFE::FeatureTest::lambda_demo --args 3u8 4u8


//# run 0xCAFE::FeatureTest::call_inline_f2_from_mymodule --args 5u16


//# run 0xCAFE::FeatureTest::conditional_return --args true


//# run 0xCAFE::FeatureTest::conditional_return --args false


//# run 0xCAFE::FeatureTest::runner
