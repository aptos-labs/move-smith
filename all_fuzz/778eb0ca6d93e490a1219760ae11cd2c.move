
//# publish
module 0xCAFE::MathOps {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun lambdas_example(x: u8, y: u8): (u8, u8) {
        let add = |p: u8, q: u8| {
            p + q
        };
        let mul = |p: u8, q: u8| {
            p * q
        };
        (add(x, y), mul(x, y))
    }
}

// We implement the previously missing MyModule within this script to fix the linker errors
// This module provides the function f2 as expected by NestedCall module


//# publish
module 0xCAFE::MyModule {
    public fun f2(a: u16): (u16, u16) {
        // Example implementation: return a + 1 and a + 2 as a tuple
        (a + 1, a + 2)
    }
}



//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::MyModule;

    public fun call_inline_f2(a: u16): (u16, u16) {
        MyModule::f2(a)
    }

    public fun call_nested_addition(a: u8, b: u8): u8 {
        let (a_plus_one, a_plus_two) = call_inline_f2(a as u16);
        // return sum of a_plus_one (u16) + b (u8) converted to u8 safely with truncation
        (a_plus_one as u8) + b
    }
}



//# run 0xCAFE::MathOps::add_and_return_sum --args 10u8 20u8



//# run 0xCAFE::MathOps::lambdas_example --args 3u8 4u8



//# run 0xCAFE::NestedCall::call_inline_f2 --args 100u16



//# run 0xCAFE::NestedCall::call_nested_addition --args 10u8 20u8
