
//# publish
module 0xCAFE::AddWithLambda {
    // A module to test addition and lambdas

    public fun add_two_values(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return sum + 10 for distinct result
        sum + 10
    }

    public fun use_lambda(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        adder(x, y)
    }

    // Runner function to test above functions
    public fun runner(): u8 {
        let result1 = add_two_values(5u8, 7u8);
        let result2 = use_lambda(3u8, 4u8);

        // Return sum of both results to have single output
        result1 + result2
    }
}


//# run 0xCAFE::AddWithLambda::runner



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::AddWithLambda;

    // Call inline function from AddWithLambda indirectly
    // Here, we call AddWithLambda::add_two_values and AddWithLambda::use_lambda
    public fun call_inline_functions(x: u8, y: u8): (u8, u8, u8) {
        let a = AddWithLambda::add_two_values(x, y);
        let b = AddWithLambda::use_lambda(x, y);

        // Call nested inline function in AddWithLambda::add_two_values again and mix results
        let c = AddWithLambda::add_two_values(a, b);
        (a, b, c)
    }

    public fun runner(): (u8, u8, u8) {
        call_inline_functions(1u8, 2u8)
    }
}


//# run 0xCAFE::InlineCaller::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
