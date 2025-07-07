
//# publish
module 0xCAFE::Arithmetic {
    use std::signer;

    public fun add_and_return_specific(x: u8, y: u8): u8 {
        let sum = x + y;
        // add 10 to sum and return
        sum + 10
    }

    public fun lambda_add(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, y)
    }

    public fun lambda_multiply(x: u8, y: u8): u8 {
        let mul_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        mul_lambda(x, y)
    }
}


//# run 0xCAFE::Arithmetic::add_and_return_specific --args 3u8 5u8


//# run 0xCAFE::Arithmetic::lambda_add --args 7u8 8u8


//# run 0xCAFE::Arithmetic::lambda_multiply --args 6u8 4u8


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::Arithmetic;

    public inline fun double_addition(x: u8, y: u8): u8 {
        let partial = Arithmetic::add_and_return_specific(x, y);
        partial + Arithmetic::add_and_return_specific(1, 2)
    }

    public fun run_no_args() {
        let _ = double_addition(3, 4);
    }
}


//# run 0xCAFE::InlineCaller::double_addition --args 10u8 20u8


//# run 0xCAFE::InlineCaller::run_no_args


//# publish
module 0xCAFE::SpecTest {
    use std::signer;

    spec fun native_spec_func(x: u8): u8;

    spec fun defined_spec_func(x: u8): u8 {
        exists<u8>(@0xCAFE) && x > 0
    }
}


//# run 0xCAFE::SpecTest::defined_spec_func --args 1u8


//# run 0xCAFE::SpecTest::native_spec_func --args 2u8



//# run 0xCAFE::Arithmetic::add_and_return_specific --args 1u8 1u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 40dd5f2d2d0593977243d4dde78a926d: Choose between native spec functions (no body) and defined spec functions (with a statement sequence body).
// cdcdafb2e2568672a036eadd1b1179b2: Use address specifier 'Literal' to specify a concrete address directly.
