
//# publish
module 0xCAFE::BasicAdd {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        let fixed = 42u8;
        fixed
    }

    public fun with_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| x + y;
        let result = lambda(a, b);
        result
    }

    public inline fun inline_double(x: u8): u8 {
        x * 2
    }
}


//# publish
module 0xCAFE::AdvancedTest {
    use 0xCAFE::BasicAdd;

    public inline fun inline_triple(x: u8): u8 {
        x * 3
    }

    public fun nested_inline_and_lambda(x: u8, y: u8): u8 {
        let sum = BasicAdd::with_lambda(x, y);
        let doubled = BasicAdd::inline_double(sum);
        let tripled = inline_triple(doubled);
        tripled
    }

    public fun binding_and_destructuring() {
        let (a, b) = (2u8, 3u8);
        let lambda: |u8| u8 has copy+drop = |x: u8| x + 5;
        let c = lambda(a);
        let d = lambda(b);
        let (e, f) = (c, d);
        let _ = e + f;
    }
}


//# run 0xCAFE::BasicAdd::add_and_return_fixed --args 10u8 11u8


//# run 0xCAFE::BasicAdd::with_lambda --args 5u8 7u8


//# run 0xCAFE::AdvancedTest::nested_inline_and_lambda --args 2u8 4u8


//# run 0xCAFE::AdvancedTest::binding_and_destructuring


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// a266a7f8865315499de9a81c96b2fb89: Test the correct handling of variable bindings, destructuring, inline functions, higher-order functions, and anonymous closures in Move.
