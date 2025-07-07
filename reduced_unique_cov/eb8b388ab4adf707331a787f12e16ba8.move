
//# publish
module 0xCAFE::LambdaModule {

    // Removed unused import: use std::vector;

    public fun add_two_values(a: u8, b: u8): u8 {
        a + b
    }

    // Function containing lambda expression that sums two u8 and returns u8
    public fun sum_with_lambda(a: u8, b: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        adder(a, b)
    }

    // Removed function call_inline_function because 0xCAFE::MyModule::f2 does not exist.
    // Alternatively, replace call_inline_function to a working example OR remove it.

    /*
    public fun call_inline_function(a: u16): u16 {
        let (a1, a2) = 0xCAFE::MyModule::f2(a);
        a1 + a2
    }
    */

    // Spec function: add_two_values_spec optionally takes type parameter T
    // But the spec function syntax is incorrect; spec functions do not take type parameters like that.
    // Fix spec by removing <T> or rewriting.

    spec {
        fun add_two_values_spec_fn(x: u8, y: u8): u8 {
            x + y
        }
    }
}



//# run 0xCAFE::LambdaModule::add_two_values --args 10u8 20u8



//# run 0xCAFE::LambdaModule::sum_with_lambda --args 30u8 12u8


// Removed the run for call_inline_function since it depends on missing MyModule::f2
