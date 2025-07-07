
//# publish
module 0xCAFE::FeatureTest1 {
    // Test addition of two u8 values and return a specific value.

    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // return sum + 10 for testing return value correctness
        sum + 10
    }
}


//# run 0xCAFE::FeatureTest1::add_and_return_sum --args 5u8 7u8


//# publish
module 0xCAFE::FeatureTest2 {
    // Test lambda expressions

    public fun lambda_add_mul(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            (x + y, x * y)
        };
        lambda(a, b)
    }
}


//# run 0xCAFE::FeatureTest2::lambda_add_mul --args 3u8 4u8


//# publish
module 0xCAFE::FeatureTest3 {
    use 0xCAFE::FeatureTest1;

    public fun nested_call(x: u8, y: u8): u8 {
        // Call inline function from FeatureTest1 for nested calls
        let intermediate = FeatureTest1::add_and_return_sum(x, y);

        // reuse intermediate value in return
        intermediate + 5
    }
}


//# run 0xCAFE::FeatureTest3::nested_call --args 2u8 3u8


//# publish
module 0xCAFE::FeatureTest4 {
    // Test passing lambdas as arguments including lambdas calling lambdas

    public fun call_lambda_with_lambda(x: u8, y: u8, f: |u8|u8, g: |u8, u8| u8): u8 {
        let temp = f(x);
        g(temp, y)
    }

    public fun runner(x: u8, y: u8): u8 {
        let lambda1: |u8|u8 has copy+drop = |a: u8| { a + 1 };
        let lambda2: |u8, u8|u8 has copy+drop = |a: u8, b: u8| { a * b };
        call_lambda_with_lambda(x, y, lambda1, lambda2)
    }
}


//# run 0xCAFE::FeatureTest4::runner --args 3u8 4u8


//# publish
module 0xCAFE::FeatureTest5 {
    // Struct with function-typed field, instantiate with closure and invoke it.

    struct StructWithFunc has copy, drop {
        f: |u8, u8| u8
    }

    public fun create_struct(f: |u8, u8| u8): StructWithFunc {
        StructWithFunc { f }
    }

    public fun call_struct_func(s: &StructWithFunc, a: u8, b: u8): u8 {
        (s.f)(a, b)
    }

    public fun test_struct_func(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| { x + y + 1 };
        let s = create_struct(lambda);
        call_struct_func(&s, a, b)
    }
}


//# run 0xCAFE::FeatureTest5::test_struct_func --args 7u8 8u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 8c738cf5e5ee14fc926782c3f0f6d187: Test that lambda expressions (function values) can be passed as arguments to public entry functions, including using lambdas that call other lambdas as arguments.
// 2dcaf4d44e1044060a6d017696e23c8b: Test that structs with function-typed fields can be declared, instantiated with a closure, and invoked inside a Move module.
