
//# publish
module 0xCAFE::AddModule {
    // Test addition of two u8 values before returning a specific value
    public fun add_and_return_fixed(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return fixed value 42 for testing
        42u8
    }
}


//# run 0xCAFE::AddModule::add_and_return_fixed --args 10u8 32u8


//# publish
module 0xCAFE::LambdaModule {
    public fun run_lambda_example(x: u8, y: u8): u8 {
        // lambda adding two values
        let add_lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, y)
    }

    public fun run_complex_lambda(x: u8): u8 {
        let captured = x;
        // lambda capturing an outer variable
        let lambda: |u8|u8 has copy+drop = |a: u8| {
            a + captured
        };
        lambda(10u8)
    }
}


//# run 0xCAFE::LambdaModule::run_lambda_example --args 5u8 7u8


//# run 0xCAFE::LambdaModule::run_complex_lambda --args 3u8


//# publish
module 0xCAFE::InlineCallModule {
    use 0xCAFE::LambdaModule;

    public inline fun inline_double_add(x: u8, y: u8): u8 {
        let temp = LambdaModule::run_lambda_example(x, y);
        temp + 1u8
    }

    public fun call_inline_and_lambda(x: u8, y: u8): u8 {
        // call inline function defined above
        inline_double_add(x, y)
    }
}


//# run 0xCAFE::InlineCallModule::call_inline_and_lambda --args 2u8 3u8


//# publish
module 0xCAFE::MutateModule {
    struct MutStruct has store {
        val: u8,
    }

    public fun create_struct(x: u8): MutStruct {
        MutStruct { val: x }
    }

    public fun mutate_directly(s: &mut MutStruct, new_val: u8) {
        s.val = new_val;
    }
}


//# run 0xCAFE::MutateModule::create_struct --args 10u8


//# run 0xCAFE::MutateModule::mutate_directly --args 20u8


//# publish
module 0xCAFE::PatternBindModule {
    public fun bind_pattern(x: u8): u8 {
        let val: u8 = x + 10u8;
        val
    }

    public fun bind_tuple_pattern(): u8 {
        let (x, y): (u8, u8) = (5u8, 7u8);
        x + y
    }
}


//# run 0xCAFE::PatternBindModule::bind_pattern --args 5u8


//# run 0xCAFE::PatternBindModule::bind_tuple_pattern


//# publish
module 0xCAFE::FunctionPointerEnum {
    use std::vector;
    use std::signer;

    public fun standalone_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun standalone_double(x: u8): u8 {
        x * 2u8
    }

    public enum FuncEnum has copy, drop {
        AddStandalone(|u8, u8| u8),
        DoubleStandalone(|u8| u8),
        LambdaStored(|u8|u8)
    }

    public struct FuncWrapper has store {
        f: FuncEnum,
        calls: u64,
    }

    public fun create_wrapper_add(): FuncWrapper {
        FuncWrapper {
            f: FuncEnum::AddStandalone(standalone_add),
            calls: 0u64,
        }
    }

    public fun create_wrapper_double_lambda(): FuncWrapper {
        let captured = 3u8;
        let lambda: |u8|u8 has copy+drop = |x: u8| {
            x + captured
        };
        FuncWrapper {
            f: FuncEnum::LambdaStored(lambda),
            calls: 0u64,
        }
    }

    public fun invoke(wrapper: &mut FuncWrapper, x: u8, y: u8): u8 {
        let result = match (&wrapper.f) {
            FuncEnum::AddStandalone(f) => f(x, y),
            FuncEnum::DoubleStandalone(f) => f(x),
            FuncEnum::LambdaStored(f) => f(x),
        };
        wrapper.calls = wrapper.calls + 1u64;
        result
    }

    public fun compose_enums(): FuncEnum {
        let lambda: |u8| u8 has copy+drop = |x: u8| x + 1;
        FuncEnum::LambdaStored(lambda)
    }

    public fun store_resource(s: signer) {
        let wrapper = create_wrapper_add();
        move_to<FuncWrapper>(&s, wrapper);
    }

    public fun use_resource(s: signer, x: u8, y: u8): u8 {
        let wrapper_ref: &mut FuncWrapper = borrow_global_mut<FuncWrapper>(signer::address_of(&s));
        invoke(wrapper_ref, x, y)
    }
}


//# run 0xCAFE::FunctionPointerEnum::create_wrapper_add


//# run 0xCAFE::FunctionPointerEnum::create_wrapper_double_lambda


//# run 0xCAFE::FunctionPointerEnum::invoke --args 5u8 7u8


//# run 0xCAFE::FunctionPointerEnum::compose_enums


//# run 0xCAFE::FunctionPointerEnum::store_resource --signers 0xABCD


//# run 0xCAFE::FunctionPointerEnum::use_resource --signers 0xABCD --args 1u8 2u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 2e88e719c2a4a03015f635a5bd3e72e9: Mutate fields of dotted expressions directly.
// 1eb3a6ffbc69a8c241e0efa818707998: Bind the result of an expression to a pattern using 'let', with optional type annotation.
// 2e519c18a9e5a3cb570c8d8c2e7c7d3a: Test that Move function-pointer enums can store, move, and invoke both standalone functions and lambda captures (including persistent functions and vector-of-funs), and can be composed within other enums and used as resource fields.
