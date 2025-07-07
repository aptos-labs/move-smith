
//# publish
module 0xCAFE::AdditionModule {
    public fun add_and_return(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return always 42 to test return value
        42
    }
}


//# run 0xCAFE::AdditionModule::add_and_return --args 10u8 32u8


//# publish
module 0xCAFE::LambdaModule {
    public fun run_lambda_add(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    public fun run_lambda_return_fixed(): u8 {
        let lambda: |u8| u8 has copy+drop = |x: u8| {
            123u8
        };
        lambda(0)
    }
}


//# run 0xCAFE::LambdaModule::run_lambda_add --args 20u8 22u8


//# run 0xCAFE::LambdaModule::run_lambda_return_fixed


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::AdditionModule;

    public inline fun inline_add_twice(a: u8, b: u8): u8 {
        let first = AdditionModule::add_and_return(a, b);
        let second = AdditionModule::add_and_return(b, a);
        first + second
    }

    public fun call_inline_add_twice(a: u8, b: u8): u8 {
        inline_add_twice(a, b)
    }
}


//# run 0xCAFE::InlineCaller::call_inline_add_twice --args 3u8 4u8


//# publish
module 0xCAFE::LocalVariableOmitInit {

    struct S has copy, drop, store {
        a: u8,
        b: u8,
    }

    public fun declare_with_type_only(): u8 {
        let x: u8;
        x = 55u8;
        x
    }

    public fun declare_with_pattern(): u8 {
        let (a, b): (u8, u8);
        (a, b) = (10u8, 20u8);
        a + b
    }

    public fun declare_struct_without_init(): u8 {
        let s: S;
        s = S {a: 1u8, b: 2u8};
        s.a + s.b
    }
}


//# run 0xCAFE::LocalVariableOmitInit::declare_with_type_only


//# run 0xCAFE::LocalVariableOmitInit::declare_with_pattern


//# run 0xCAFE::LocalVariableOmitInit::declare_struct_without_init


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// c0f1944268981470f47816567f030542: Omit the initialization when declaring local variables to only specify their type or pattern.
