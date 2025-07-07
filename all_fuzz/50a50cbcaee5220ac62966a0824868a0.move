
//# publish
module 0xCAFE::AdvancedFeatures {
    // Removed unused `use std::vector;` as it's not used.
    // Removed use 0xCAFE::MyModule; because it's an unbound module.

    // Function adding two u8 values and returns the sum plus 5
    public fun add_then_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 5
    }

    // Function with lambda that multiplies a number by 2 and adds 3 using closure
    public fun lambda_expression_example(x: u8): u8 {
        let double_and_add: |u8|u8 has copy+drop = |n: u8| { (n * 2) + 3 };
        double_and_add(x)
    }

    // Since we cannot reference 0xCAFE::MyModule::f2, let's implement inline f2 here
    // For demonstration, let's define f2 as a function that returns (val, val/2)
    public fun f2(val: u16): (u16, u16) {
        (val, val / 2)
    }

    // Calling inline function f2 defined above and returning sum of tuple
    public fun call_inline_and_sum(val: u16): u16 {
        let (a, b) = Self::f2(val);
        let result = a + b;
        result
    }

    // Bind multiple vars from tuple and use in expression and return the tuple back
    public fun multiple_binding(val1: u16, val2: u16): (u16, u16, u16) {
        let (a, b) = (val1, val2);
        let c = a + b;
        (a, b, c)
    }
}



//# run 0xCAFE::AdvancedFeatures::add_then_offset --args 10u8 15u8



//# run 0xCAFE::AdvancedFeatures::lambda_expression_example --args 7u8



//# run 0xCAFE::AdvancedFeatures::call_inline_and_sum --args 20u16



//# run 0xCAFE::AdvancedFeatures::multiple_binding --args 5u16 10u16
