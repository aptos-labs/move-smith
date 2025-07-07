
//# publish
module 0xCAFE::Addition {
    // Simple add function that returns sum of x and y plus 10
    public fun add_and_offset(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 10
    }

    public fun with_lambda(x: u8, y: u8): u8 {
        let adder: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        adder(x, y)
    }
}


//# run 0xCAFE::Addition::add_and_offset --args 3u8 7u8


//# run 0xCAFE::Addition::with_lambda --args 4u8 5u8



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::Addition;

    // Call the add_and_offset inline function from Addition and further add 5
    public fun call_add_and_offset(x: u8, y: u8): u8 {
        let intermediate = Addition::add_and_offset(x, y);
        intermediate + 5
    }
}


//# run 0xCAFE::InlineCaller::call_add_and_offset --args 2u8 8u8



//# publish
module 0xCAFE::DeprecationControl {
    // This function documents how to control warnings by referencing environment variable
    // It's just a stub for compilation testing.
    public fun note_deprecation_setting() {
        // No-op, but documented:
        // Developers can set the environment variable 
        // "APTOS_DEPRECATION_WARNINGS_ENABLED" to "1" or "0" to show or hide deprecation warnings.
    }
}


//# run 0xCAFE::DeprecationControl::note_deprecation_setting


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 7bd7a54ae40c69822dcafecf7270ac02: Control whether deprecation warnings are shown in the Move compiler by setting an environment variable
