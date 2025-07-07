
//# publish
module 0xCAFE::AddModule {
    /// Adds two u8 and returns sum plus 10
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    /// Returns a lambda that adds two u8 numbers and returns u8 result
    public fun make_adder(): |(u8, u8): u8| {
        &(|x: u8, y: u8| { x + y })
    }

    /// Applies given lambda to arguments and returns result plus 5
    public fun apply_lambda_with_offset(f: |(u8, u8): u8|, a: u8, b: u8): u8 {
        let res = f(a, b);
        res + 5
    }

    /// Inline function returning a tuple with input plus offset
    public inline fun inline_tuple_add(a: u8): (u8, u8) {
        (a + 1, a + 2)
    }
}

//# run 0xCAFE::AddModule::add_and_offset --args 3u8 4u8


//# run 0xCAFE::AddModule::apply_lambda_with_offset --args 2u8 3u8


//# run 0xCAFE::AddModule::make_adder


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    /// Calls AddModule.inline_tuple_add and sums elements of the tuple
    public fun call_inline_and_sum(a: u8): u8 {
        let (x, y) = AddModule::inline_tuple_add(a);
        x + y
    }

    /// Test function with split critical edges in control flow graph
    public fun split_critical_edges_test(x: u8): u8 {
        let result = 0u8;
        if (x > 5) {
            if (x < 10) {
                result = result + 1;
            } else {
                result = result + 2;
            };
        } else {
            if (x == 5) {
                result = result + 3;
            } else {
                result = result + 4;
            };
        };
        result
    }

    spec fun dummy_spec() {
        // example spec block
        assert!(true, 0);
    }
}

//# run 0xCAFE::CallerModule::call_inline_and_sum --args 5u8


//# run 0xCAFE::CallerModule::split_critical_edges_test --args 7u8


//# run 0xCAFE::CallerModule::split_critical_edges_test --args 3u8


//# run 0xCAFE::CallerModule::dummy_spec


//# run 0xCAFE::CallerModule::call_inline_and_sum --args 0u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// a14c0b4bc381bb3cd801012bacd0b468: Define specification blocks within Move code.
// 6d6cd2f7a5512a80ae044228facb41eb: Split critical edges in control flow graphs for better analysis and transformations.
