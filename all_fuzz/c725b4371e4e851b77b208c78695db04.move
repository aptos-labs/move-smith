
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

    // Replace deprecated 'public(script)' with 'public entry'
    public entry fun script_only_function(): u8 {
        42u8
    }
}



//# run 0xCAFE::Adder::add_u8 --args 10u8 20u8



//# run 0xCAFE::Adder::with_lambda_expr --args 5u8 7u8



//# run 0xCAFE::Adder::script_only_function



//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::Adder;

    /// Public function that calls the inline add_u8 function from Adder module
    public fun call_adder_add(a: u8, b: u8): u8 {
        Adder::add_u8(a, b)
    }

    // Replace deprecated 'public(script)' with 'public entry'
    public entry fun call_script_only(): u8 {
        Adder::script_only_function()
    }
}



//# run 0xCAFE::NestedCalls::call_adder_add --args 15u8 25u8



//# run 0xCAFE::NestedCalls::call_script_only



//# publish
module 0xCAFE::ModuleWithoutAddress {
    /// Simple addition function without address module
    public fun add_simple(a: u8, b: u8): u8 {
        a + b
    }
}



//# run 0xCAFE::ModuleWithoutAddress::add_simple --args 11u8 22u8
