
//# publish
module 0xCAFE::MathModule {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42u8
        } else {
            sum
        }
    }

    public inline fun inline_add(a: u16, b: u16): u16 {
        a + b
    }
}


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::MathModule;

    public fun call_inline_add(a: u16, b: u16): u16 {
        // Call inline_add from MathModule and add 5 to the result
        let result = MathModule::inline_add(a, b);
        result + 5u16
    }
}


//# run 0xCAFE::MathModule::add_two_values --args 3u8 4u8


//# run 0xCAFE::MathModule::add_two_values --args 10u8 5u8


//# run 0xCAFE::NestedCallModule::call_inline_add --args 20u16 22u16


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 57fa136e7175a1a531a1a8ea1121eae4: Define modules and package definitions in Move source code.
