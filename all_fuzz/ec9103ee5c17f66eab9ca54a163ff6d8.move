
//# publish
module 0xCAFE::LambdaAndInline {
    // Use inline functions and lambdas in combination

    public inline fun add_u8(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_lambda_then_add(x: u8, y: u8): u8 {
        let lambda: |u8, u8|u8 has copy + drop = |a: u8, b: u8| {
            add_u8(a, b)
        };
        lambda(x, y)
    }

    public fun runner(): u8 {
        // call with lambda
        call_lambda_then_add(10u8, 5u8)
    }
}


//# run 0xCAFE::LambdaAndInline::call_lambda_then_add --args 7u8 8u8


//# run 0xCAFE::LambdaAndInline::runner



//# publish
module 0xCAFE::CrossModuleInlineCaller {
    use 0xCAFE::LambdaAndInline;

    public fun call_add_u8_via_inline(x: u8, y: u8): u8 {
        // Call inline function from LambdaAndInline explicitly
        LambdaAndInline::add_u8(x, y)
    }

    public fun call_runner(): u8 {
        // Call inline runner in LambdaAndInline
        LambdaAndInline::runner()
    }
}


//# run 0xCAFE::CrossModuleInlineCaller::call_add_u8_via_inline --args 1u8 2u8


//# run 0xCAFE::CrossModuleInlineCaller::call_runner


//# publish
module 0xCAFE::CompileTimeOptionConditional {
    const CONFIG_FLAG: bool = true;

    public fun conditional_computation(x: u8): u8 {
        if (CONFIG_FLAG) {
            x + 10u8
        } else {
            x + 20u8
        };
        // Function returns x + 10 if CONFIG_FLAG is true
        x + 10u8
    }
}


//# run 0xCAFE::CompileTimeOptionConditional::conditional_computation --args 5u8



//# publish
module 0xCAFE::OptionalConstraints {
    // This function can optionally contain type constraints.
    // We simulate optional parsing by just adding type parameters and constraints and calling in test.

    public fun identity<T: copy + drop>(x: T): T {
        x
    }

    public fun call_identity_u8(x: u8): u8 {
        identity<u8>(x)
    }
}


//# run 0xCAFE::OptionalConstraints::call_identity_u8 --args 123u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 15968fc5a0eff6d807500231066e05d2: Control test code compilation using a compile-time option
// ec762062220ebd6de7077c8bb9042449: Create functions with optional type constraints that are parsed when present.
