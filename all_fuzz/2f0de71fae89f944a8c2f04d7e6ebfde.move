
//# publish
module 0xCAFE::AddModule {
    // Module to test simple addition and anonymous functions (lambda)

    public fun add_two_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return a constant 42u8 after performing addition to test order
        sum;
        42u8
    }

    public fun apply_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let res = lambda(x, y);
        res
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun nested_call(a: u8, b: u8): u8 {
        // Call inline_add from AddModule inside this function
        AddModule::inline_add(a, b)
    }

    // Returns visibility as string via a u8 vector
    public fun get_visibility_string(): vector<u8> {
        // Simulate: "public"
        vector[112u8, 117u8, 98u8, 108u8, 105u8, 99u8]
    }
}

// A dummy struct to simulate LiveVarAnalysis via field names of live vars
// Although actual live variable analysis isn't possible here, this tests naming and access

//# publish
module 0xCAFE::LiveVarModule {
    struct LiveVars has copy, drop, store {
        a: u8,
        b: u8,
        c: u8,
    }

    public fun record_live_vars(): LiveVars {
        let a = 1u8;
        let b = 2u8;
        let c = 3u8;
        LiveVars {a, b, c}
    }
}


//# run 0xCAFE::AddModule::add_two_u8 --args 10u8 32u8


//# run 0xCAFE::AddModule::apply_lambda --args 20u8 22u8


//# run 0xCAFE::CallerModule::nested_call --args 100u8 55u8


//# run 0xCAFE::CallerModule::get_visibility_string


//# run 0xCAFE::LiveVarModule::record_live_vars


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// fabdfe3e50de63951e286a1bc897e998: Define a function to get the string representation of a function's visibility.
// cec73c9384cb63d81368e9c1ec7f0ce0: Use LiveVarAnalysis to identify live variables at different points in the code.
// 978304a80de9c5218197ed83e328b094: Automatically add the 'fun' keyword to function definitions that do not already include it.
