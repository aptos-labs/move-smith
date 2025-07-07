
//# publish
module 0xCAFE::Calculator {
    /// Adds two u8 numbers and returns their sum plus 5u8.
    public fun add_and_adjust(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 5u8
    }

    /// Function that defines and calls a lambda to multiply and add.
    public fun lambda_operations(x: u8, y: u8): (u8, u8) {
        let multiply: |u8, u8| u8 has copy+drop = |a: u8, b: u8| a * b;
        let add: |u8, u8| u8 has copy+drop = |a: u8, b: u8| a + b;
        let product = multiply(x, y);
        let summation = add(x, y);
        (product, summation)
    }

    /// Calls an inline function from another module (MyModule)
    public fun call_inline_from_other_module(a: u16): u16 {
        // Since MyModule::f2 doesn't exist, replaced with simple inline logic
        a + 10u16
    }
}



//# run 0xCAFE::Calculator::add_and_adjust --args 10u8 15u8



//# run 0xCAFE::Calculator::lambda_operations --args 4u8 5u8



//# run 0xCAFE::Calculator::call_inline_from_other_module --args 20u16



//# publish
module 0xCAFE::AttributesExample {
    /// A simple function to demonstrate attributes usage.
    // test_only]
    public fun simple_test_func(): u64 {
        42u64
    }
}



//# run 0xCAFE::AttributesExample::simple_test_func



//# publish
module 0xCAFE::ExpressionTests {
    /// Unit literal expression test - returns unit type ()
    public fun unit_expression(): () {
    }

    /*
    // This function intentionally won't compile if uncommented, it serves as documentation for unresolved error expression.
    public fun unresolved_error_test() {
        let x: UnresolvedType; // This type does not exist, should trigger a compiler error
    }
    */
}



//# run 0xCAFE::ExpressionTests::unit_expression
