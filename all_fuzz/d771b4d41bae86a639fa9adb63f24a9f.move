
//# publish
module 0xCAFE::LambdaAndInline {
    // This module tests lambda expressions and inline functions

    public inline fun add_u8(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_lambda_example(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            add_u8(x, y)
        };
        lambda(10u8, 20u8)
    }

    public fun runner(): u8 {
        call_lambda_example()
    }
}


//# run 0xCAFE::LambdaAndInline::runner



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::LambdaAndInline;

    // Use inline function in another module with nested calls
    public fun nested_inline_call(x: u8, y: u8): u8 {
        let sum = LambdaAndInline::add_u8(x, y);
        let inline_result = LambdaAndInline::add_u8(sum, 5u8);
        inline_result
    }

    public fun runner(): u8 {
        nested_inline_call(3u8, 4u8)
    }
}


//# run 0xCAFE::CallerModule::runner



//# publish
module 0xCAFE::OptionalTypeArgs {
    // Demonstrate function with optional type parameters in type declarations

    public fun create_vector_with_optional_type<T>(values: vector<T>): vector<T> {
        values
    }

    public fun runner(): vector<u8> {
        let v = vector[1u8, 2u8, 3u8];
        create_vector_with_optional_type<u8>(v)
    }
}


//# run 0xCAFE::OptionalTypeArgs::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 9ffabee55ce5362d2c95f2f9158c196a: Use optional type arguments in type declarations
