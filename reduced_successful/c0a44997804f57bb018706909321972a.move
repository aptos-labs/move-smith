
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

    public fun call_lambda_with_lambda(x: u8, y: u8, f: |u8|u8 has copy+drop, g: |u8, u8| u8 has copy+drop): u8 {
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
        f: |u8, u8| u8 has copy+drop
    }

    public fun create_struct(f: |u8, u8| u8 has copy+drop): StructWithFunc {
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
