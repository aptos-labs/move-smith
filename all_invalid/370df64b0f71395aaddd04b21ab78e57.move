
//# publish
module 0xCAFE::AdditionModule {
    public fun add_two_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 1 to distinguish from just sum
        sum + 1
    }

    public fun use_lambda(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let sum = x + y;
            let product = x * y;
            (sum, product)
        };
        lambda(a, b)
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AdditionModule;

    // Calls inline function from AdditionModule repeatedly and sums results
    public inline fun inline_double(a: u8): (u8, u8) {
        let (first_sum, first_prod) = AdditionModule::use_lambda(a, 2);
        let (second_sum, second_prod) = AdditionModule::use_lambda(a, 3);
        (first_sum + second_sum, first_prod + second_prod)
    }

    public fun nested_call(a: u8, b: u8): u8 {
        let added = AdditionModule::add_two_u8(a, b);
        let (sum, prod) = inline_double(added);
        sum + prod
    }
}


//# run 0xCAFE::AdditionModule::add_two_u8 --args 10u8 20u8


//# run 0xCAFE::AdditionModule::use_lambda --args 3u8 4u8


//# run 0xCAFE::CallerModule::nested_call --args 5u8 6u8


//# run 0xCAFE::CallerModule::inline_double --args 10u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
