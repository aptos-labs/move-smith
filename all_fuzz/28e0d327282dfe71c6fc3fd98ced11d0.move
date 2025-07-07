
//# publish
module 0xCAFE::LambdaModule {
    const CONST_VAL: u8 = 42;

    struct CopyStruct has copy, drop, store {
        a: u8,
        b: u8,
    }

    // *** Provide a dummy native implementation ***
    public fun native_add(a: u8, b: u8): u8 {
        a + b
    }

    // Simple add function returning sum plus CONST_VAL
    public fun add_plus_const(x: u8, y: u8): u8 {
        let sum = Self::native_add(x, y);
        sum + CONST_VAL
    }

    public fun use_lambda(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            a + b
        };
        let product_lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            a * b
        };

        let sum = add_lambda(x, y);
        let prod = product_lambda(x, y);
        sum + prod
    }

    public fun copy_local_vars(x: u8, y: u8): u8 {
        let s = CopyStruct { a: x, b: y };
        let s_copy = copy s;
        let sum_fields = s.a + s.b;
        let sum_copy_fields = s_copy.a + s_copy.b;
        let total = sum_fields + sum_copy_fields;
        total
    }

    public fun native_forward_add(x: u8, y: u8): u8 {
        Self::native_add(x, y)
    }
}



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::LambdaModule;

    public inline fun inline_add(x: u8, y: u8): u8 {
        x + y
    }

    public fun call_inline(x: u8,y: u8): u8 {
        inline_add(x,y)
    }

    public fun nested_calls(x: u8, y: u8): u8 {
        let inline_res = Self::call_inline(x, y);
        let lambda_res = LambdaModule::use_lambda(x, y);
        let total = inline_res + lambda_res;
        total
    }
}



//# run 0xCAFE::LambdaModule::add_plus_const --args 3u8 4u8



//# run 0xCAFE::LambdaModule::use_lambda --args 5u8 6u8



//# run 0xCAFE::LambdaModule::copy_local_vars --args 7u8 8u8



//# run 0xCAFE::CallerModule::call_inline --args 10u8 20u8



//# run 0xCAFE::CallerModule::nested_calls --args 1u8 2u8



//# run 0xCAFE::LambdaModule::native_forward_add --args 9u8 10u8


// Features:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// a7ebfa887699363af1eb7542d0845eb4: Mark module members as native using the 'native' modifier.
// 2541c26e47c58059ea613edebd6523d6: Test that local variables can be copied and used multiple times within a function for both primitive types and structs with the copy ability.
