
//# publish
module 0xCAFE::Addition {
    public fun add_then_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        sum
    }

    public fun with_lambda_usage(x: u8, y: u8): u8 {
        let add = |a: u8, b: u8| { a + b };
        let sum = add(x, y);
        let double_it = |n: u8| { n * 2 };
        double_it(sum)
    }

    public inline fun inline_addition(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::LambdaCaller {
    use 0xCAFE::Addition;

    public fun call_lambda(x: u8, y: u8): u8 {
        Addition::with_lambda_usage(x, y)
    }
}


//# publish
module 0xCAFE::NestedInlineCall {
    use 0xCAFE::Addition;

    public fun call_inline_add(a: u8, b: u8): u8 {
        Addition::inline_addition(a, b)
    }

    public fun call_nested_inline(a: u8, b: u8): u8 {
        let first = call_inline_add(a, b);
        Addition::inline_addition(first, 10)
    }
}


//# publish
module 0xCAFE::NameChainTest {
    use 0xCAFE::Addition;

    struct Container<T> has copy, drop {
        value: T
    }

    public fun destructure_type_arg() {
        let container = Container<u8> { value: 42 };
        let Container<u8> { value: v } = container;
        let _res = Addition::add_then_return_sum(v, 10u8);
    }
}


//# run 0xCAFE::Addition::add_then_return_sum --args 5u8 10u8


//# run 0xCAFE::Addition::with_lambda_usage --args 2u8 3u8


//# run 0xCAFE::LambdaCaller::call_lambda --args 7u8 4u8


//# run 0xCAFE::NestedInlineCall::call_inline_add --args 8u8 12u8


//# run 0xCAFE::NestedInlineCall::call_nested_inline --args 1u8 2u8


//# run 0xCAFE::NameChainTest::destructure_type_arg


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// efb7b38641a82237d0fa665f316df9d7: Interpret name chains as either module references, type references, or combined module-type references based on context and syntax.
// b6047f5a6732bb8bc70c71374953ebbe: Use type arguments in destructuring patterns
