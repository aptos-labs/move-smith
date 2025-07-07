
//# publish
module 0xCAFE::Addition {
    public fun add_two_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10u8 // return sum plus a fixed value 10
    }
    
    public fun with_lambda(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }
    
    public fun runner(): u8 {
        // Use the lambda with fixed inputs
        with_lambda(5u8, 7u8)
    }
}


//# run 0xCAFE::Addition::add_two_u8 --args 3u8 4u8


//# run 0xCAFE::Addition::with_lambda --args 8u8 9u8


//# run 0xCAFE::Addition::runner


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::Addition;

    public fun call_add_and_lambda(a: u8, b: u8): (u8, u8) {
        let result_add = Addition::add_two_u8(a, b);
        let result_lambda = Addition::with_lambda(a, b);
        (result_add, result_lambda)
    }

    public fun runner(): (u8, u8) {
        call_add_and_lambda(5u8, 10u8)
    }
}


//# run 0xCAFE::NestedCall::call_add_and_lambda --args 2u8 3u8


//# run 0xCAFE::NestedCall::runner


//# publish
module 0xCAFE::ModuleSaver {
    use std::vector;

    /// Dummy function to simulate saving compiled module binaries to disk.
    /// This function just creates a vector<byte> representing binary data.
    public fun save_module_binary(): vector<u8> {
        // Simulate binary data as vector of bytes
        let binary: vector<u8> = vector[0xCA, 0xFE, 0xBA, 0xBE];
        binary
    }
    
    public fun runner(): vector<u8> {
        save_module_binary()
    }
}


//# run 0xCAFE::ModuleSaver::save_module_binary


//# run 0xCAFE::ModuleSaver::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// e4c0df198ad7e24642cbc634f79a4c48: Save compiled Move modules to disk as binary files.
