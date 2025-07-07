
//# publish
module 0xCAFE::TestAdd {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let _sum = a + b;
        // returns a fixed value to test function correctness
        42u8
    }
}



//# run 0xCAFE::TestAdd::add_and_return_fixed --args 3u8 4u8



//# publish
module 0xCAFE::LambdaExamples {
    public fun call_lambda_twice(x: u8): u8 {
        let f: |u8| u8 has copy+drop = |a: u8| { a + 1 };
        let first_call = f(x);
        let second_call = f(first_call);
        second_call
    }

    public fun lambda_with_two_params(a: u8, b: u8): u8 {
        let add_multiply: |u8, u8| u8 has copy+drop = |x: u8, y: u8| { x * y + x + y };
        add_multiply(a, b)
    }
}



//# run 0xCAFE::LambdaExamples::call_lambda_twice --args 5u8



//# run 0xCAFE::LambdaExamples::lambda_with_two_params --args 3u8 4u8



//# publish
module 0xCAFE::InlineCaller {
    // Removed use 0xCAFE::MyModule; because 0xCAFE::MyModule does not exist.
    // Added an inline implementation of f2 here for the test.

    // Suppose f2 is a function returning a tuple (u16, u16).
    // We define it here as a private helper:
    fun f2(x: u16): (u16, u16) {
        // Just split x into two halves for demonstration
        (x / 2, x - (x / 2))
    }

    public fun call_inline_f2_and_sum(a: u16, b: u16): u16 {
        let (a1, a2) = Self::f2(a);
        let (b1, b2) = Self::f2(b);
        a1 + a2 + b1 + b2
    }
}



//# run 0xCAFE::InlineCaller::call_inline_f2_and_sum --args 10u16 20u16



//# publish
module 0xCAFE::CompilerDiagnostics {
    // Dummy function to simulate reporting parser error diagnostics during module compilation
    public fun report_parse_error() {
        // In real compilation, errors are reported by compiler itself, here simulate with assert failure
        assert!(false, 9999);
    }
}

// No run command here because it aborts



//# publish
module 0xCAFE::ExpressionTransformer {
    use std::vector;

    // Dummy struct representing a mock compiler context
    struct Context has copy, drop {}

    // Dummy representation of an expression
    struct Expr has copy, drop {
        value: u8
    }

    // Function exp_ applies some transformation to an expression in a given context
    public fun exp_(_ctx: &Context, e: Expr): Expr {
        // For test, just increments the value by 1
        Expr { value: e.value + 1 }
    }

    // Function exps applies exp_ function to each expression in a vector of expressions
    public fun exps(ctx: &Context, exprs: vector<Expr>): vector<Expr> {
        let transformed = vector::empty<Expr>();
        let len = vector::length(&exprs);
        let i = 0u64;
        while (i < len) {
            let e_ref = vector::borrow(&exprs, i);
            let e_new = exp_(ctx, *e_ref);
            vector::push_back(&mut transformed, e_new);
            i = i + 1u64;
        };
        transformed
    }

    // Runner function to test exps with sample expressions
    public fun test_transformation(): vector<Expr> {
        let ctx = Context {};
        let original = vector[Expr{value: 10u8}, Expr{value: 20u8}, Expr{value: 30u8}];
        exps(&ctx, original)
    }
}



//# run 0xCAFE::ExpressionTransformer::test_transformation
