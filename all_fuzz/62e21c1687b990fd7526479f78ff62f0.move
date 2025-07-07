
//# publish
module 0xCAFE::CalcModule {
    // A simple function to add two u8 values and then add 10 before returning
    public fun add_then_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    // Function containing lambda (anonymous function) expressions
    public fun apply_lambda(x: u8): u8 {
        let add_ten: |u8|u8 has copy+drop = |v: u8| { v + 10 };
        add_ten(x)
    }

    // Another function with a lambda that uses 2 args
    public fun apply_double_lambda(x: u8, y: u8): (u8, u8) {
        let add: |u8, u8|u8 has copy+drop = |a: u8, b: u8| { a + b };
        let mul: |u8, u8|u8 has copy+drop = |a: u8, b: u8| { a * b };
        (add(x, y), mul(x, y))
    }
}


//# publish
module 0xCAFE::NestedCaller {
    use 0xCAFE::CalcModule;

    // Calls an inline function from CalcModule within a nested call sequence
    public inline fun inline_adder(a: u8, b: u8): u8 {
        // Inline call to CalcModule::add_then_offset indirectly via a helper inline function call
        let x = CalcModule::add_then_offset(a, b);
        x
    }

    public fun nested_calls(a: u8, b: u8): u8 {
        // call inline function from same module which calls another module inline function
        inline_adder(a, b)
    }
}


//# run 0xCAFE::CalcModule::add_then_offset --args 5u8 7u8


//# run 0xCAFE::CalcModule::apply_lambda --args 4u8


//# run 0xCAFE::CalcModule::apply_double_lambda --args 3u8 6u8


//# run 0xCAFE::NestedCaller::nested_calls --args 2u8 8u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
