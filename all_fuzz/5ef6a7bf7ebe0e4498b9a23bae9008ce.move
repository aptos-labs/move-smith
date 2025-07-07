
//# publish
module 0xCAFE::LambdaModule {
    /// A public function adding two u8 and returning u8
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    /// A function that uses a lambda (anonymous function)
    public fun use_lambda(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, y)
    }

    /// A function creating and returning a lambda itself
    public fun return_lambda(): |u8, u8|u8 has copy+drop {
        |x: u8, y: u8| { x + y }
    }
}


//# run 0xCAFE::LambdaModule::add_two_values --args 15u8 27u8


//# run 0xCAFE::LambdaModule::use_lambda --args 3u8 4u8


//# run 0xCAFE::LambdaModule::return_lambda



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::LambdaModule;

    /// Call inline functions from LambdaModule by invoking add_two_values through nested calls
    public fun call_inline_add(x: u8, y: u8): u8 {
        let partial_sum = LambdaModule::add_two_values(x, y);

        // call inline lambda returned by LambdaModule::return_lambda
        let lambda = LambdaModule::return_lambda();

        // Apply lambda to values 1 and partial_sum
        lambda(1u8, partial_sum)
    }
}


//# run 0xCAFE::CallerModule::call_inline_add --args 10u8 20u8



//# publish
module 0xCAFE::DummyAnnotModule {
    /// Dummy function imitating lifetime debug annotation registration
    public fun register_lifetime_annotation() {
        // No actual lifetime annotation in Move
        // Just a dummy function body to test compiler and VM support for this function presence
    }
}


//# run 0xCAFE::DummyAnnotModule::register_lifetime_annotation


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 42a04f2d7ad1e606a3c6e4b55fb0522f: Debug and test lifetime annotations by registering custom annotation formatters on Move functions
