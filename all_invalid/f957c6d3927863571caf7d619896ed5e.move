
//# publish
module 0xCAFE::Adder {
    public fun add_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        // sum + 1 is the output to verify if addition + offset works correctly
        sum + 1
    }

    public fun with_lambda_expr(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    // Restricting function visibility to scripts only
    public(script) fun script_only_function(): u8 {
        42u8
    }
}


//# run 0xCAFE::Adder::add_u8 --args 10u8 20u8


//# run 0xCAFE::Adder::with_lambda_expr --args 5u8 7u8


//# run 0xCAFE::Adder::script_only_function


//# publish
module NestedCalls {
    use 0xCAFE::Adder;

    /// Public function that calls the inline add_u8 function from Adder module
    public fun call_adder_add(a: u8, b: u8): u8 {
        Adder::add_u8(a, b)
    }

    // Only scripts can call this function, testing public(script) visibility in a different module
    public(script) fun call_script_only(): u8 {
        Adder::script_only_function()
    }
}


//# run 0xCAFE::NestedCalls::call_adder_add --args 15u8 25u8


//# run 0xCAFE::NestedCalls::call_script_only


//# publish
module ModuleWithoutAddress {
    /// Simple addition function without address module
    public fun add_simple(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::ModuleWithoutAddress::add_simple --args 11u8 22u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// e87cf81d63f2b7e9fa10ccad0df8dfc2: Define modules with or without a specified address
// 5455ff75a13c9b6d4b39759d22407b1d: Restrict visibility of functions and modules to scripts using the 'public(script)' visibility modifier.
