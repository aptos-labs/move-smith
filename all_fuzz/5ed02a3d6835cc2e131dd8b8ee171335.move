
//# publish
module 0xCAFE::LambdaModule {
    // This module tests lambdas and inline functions

    public inline fun add_one(a: u64): u64 {
        a + 1
    }

    public fun apply_lambda_and_add(x: u64, y: u64): u64 {
        let lambda: |u64|u64 has copy+drop = |a: u64| {
            Self::add_one(a)
        };
        let z = lambda(x);
        z + y
    }

    public fun run_lambdas() {
        let l1: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let sum = a + b;
            let prod = a * b;
            (sum, prod)
        };
        let (s, p) = l1(2u8, 3u8);

        // Copy and reuse the lambda
        let l2 = copy l1;
        let (_s2, _p2) = l2(4u8, 5u8);
    }

    public fun body_simplification(x: u64): u64 {
        let a = x + 0; // Add zero, compiler should simplify this
        let b = a;     // Assign to another variable, no change
        let c = b;     // Another assignment
        c + 0          // Add zero again, should simplify
    }

    public fun sequential_instructions(x: u64): u64 {
        let a = x + 1;
        let b = a + 2;
        let c = b + 3;
        let d = c + 4;
        d
    }
}


//# run 0xCAFE::LambdaModule::apply_lambda_and_add --args 10u64 20u64


//# run 0xCAFE::LambdaModule::run_lambdas


//# run 0xCAFE::LambdaModule::body_simplification --args 42u64


//# run 0xCAFE::LambdaModule::sequential_instructions --args 1u64


// Featurres:
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// c1154f9be2350577b0860226a11b5a9d: Write functions whose bodies can be automatically simplified by the Move compiler to improve code structure or remove unnecessary code.
// e4595db29c530452e76d595154046d23: Write function bodies with a sequence of instructions.
