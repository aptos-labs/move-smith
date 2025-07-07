
//# publish
module 0xCAFE::MathLambda {
    // Test 1: Simple addition of two u8 values and returning a constant after.
    public fun add_then_return_const(a: u8, b: u8): u8 {
        let sum = a + b;
        let _ = sum; // use sum so no unused warning
        42u8
    }

    // Test 2: Functions containing lambda (anonymous function) expressions.
    public fun apply_lambda_to_value(x: u8): u8 {
        let lambda: |u8| u8 has copy+drop = |v: u8| {
            v * 2
        };
        lambda(x)
    }

    public fun compose_and_apply(a: u8, b: u8): u8 {
        let add: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let double: |u8| u8 has copy+drop = |x: u8| {
            x * 2
        };

        let sum = add(a, b);
        double(sum)
    }
}



//# run 0xCAFE::MathLambda::add_then_return_const --args 10u8 15u8



//# run 0xCAFE::MathLambda::apply_lambda_to_value --args 21u8



//# run 0xCAFE::MathLambda::compose_and_apply --args 3u8 4u8




//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::MathLambda;

    // Test 3: Calling an inline function from another module which calls another inline function.

    // Inline function in this module that calls MathLambda::apply_lambda_to_value (which uses lambda)
    public inline fun call_apply_lambda(x: u8): u8 {
        MathLambda::apply_lambda_to_value(x)
    }

    // Inline function that calls call_apply_lambda, to test nested inline call chain
    public inline fun nested_inline_call(x: u8): u8 {
        call_apply_lambda(x)
    }

    // Public function to be run in test, calling nested inline calls and returning the result
    public fun runner(x: u8): u8 {
        nested_inline_call(x)
    }
}



//# run 0xCAFE::InlineCaller::runner --args 7u8




//# publish
module 0xCAFE::StructWithField {
    struct Container has copy, drop, store {
        inner: Inner,
    }

    struct Inner has copy, drop, store {
        value: u8
    }

    public fun create_container(v: u8): Container {
        let inner = Inner { value: v };
        Container { inner }
    }

    // Changed the argument from &Container to Container to match what can be passed through transaction args
    public fun read_inner_value(c: Container): u8 {
        // access inner.value from owned container
        c.inner.value
    }
}




//# run 0xCAFE::StructWithField::create_container --args 55u8



//# run 0xCAFE::StructWithField::read_inner_value --args 55u8

// Note: Changed the argument to be a Container (owned) and pass the value created in create_container
// This matches the VM's requirement to deserialize the argument from raw bytes:
// Passing &Container is not supported in this testing environment since references cannot be passed as transaction arguments.

// Features:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 232b89599d79eae82e64e4ab36d5a3e8: Create dotted expressions involving field access.
