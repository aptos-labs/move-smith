
//# publish
module 0xCAFE::AdditionModule {
    public fun add_then_return_specific(a: u8, b: u8): u8 {
        let sum = a + b;
        // We return the sum plus 10 for testing
        sum + 10
    }

    public fun with_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| a + b;
        let res = lambda(x, y);
        res
    }

    public fun with_lambda_complex(x: u8, y: u8): u8 {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let sum = a + b;
            let product = a * b;
            (sum, product)
        };
        let (sum, product) = lambda(x, y);
        sum + product
    }

    public inline fun inline_adder(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AdditionModule;

    public fun call_inline_adder_and_add_extra(a: u8, b: u8): u8 {
        let intermediate = AdditionModule::inline_adder(a, b);
        intermediate + 5
    }

    public fun call_nested_functions(x: u8, y: u8): u8 {
        let part1 = AdditionModule::add_then_return_specific(x, y); // (x+y) + 10
        let part2 = call_inline_adder_and_add_extra(x, y);         // (x+y) + 5
        part1 + part2
    }
}


//# run 0xCAFE::AdditionModule::add_then_return_specific --args 3u8 4u8


//# run 0xCAFE::AdditionModule::with_lambda --args 5u8 6u8


//# run 0xCAFE::AdditionModule::with_lambda_complex --args 2u8 3u8


//# run 0xCAFE::NestedCallModule::call_inline_adder_and_add_extra --args 4u8 5u8


//# run 0xCAFE::NestedCallModule::call_nested_functions --args 1u8 2u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
