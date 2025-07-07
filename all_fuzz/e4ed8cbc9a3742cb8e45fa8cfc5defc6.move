
//# publish
module 0xCAFE::LambdaModule {
    public fun add_two_values(x: u8, y: u8): u8 {
        let sum = x + y; // unused variable warning if not used later, but we use it as return value below
        sum + 0u8
    }

    public fun with_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    public fun return_lambda(): |u8, u8|u8 has copy+drop {
        let lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda
    }
}


//# run 0xCAFE::LambdaModule::add_two_values --args 5u8 7u8


//# run 0xCAFE::LambdaModule::with_lambda --args 3u8 4u8


//# run 0xCAFE::LambdaModule::return_lambda


//# publish
module 0xCAFE::InlineCallModule {
    use 0xCAFE::LambdaModule;

    public inline fun inline_adder(a: u8, b: u8): u8 {
        let result = LambdaModule::add_two_values(a, b);
        result
    }

    public fun call_inline_adder(): u8 {
        inline_adder(8u8, 9u8)
    }
}


//# run 0xCAFE::InlineCallModule::call_inline_adder


//# publish
module 0xCAFE::GenericStructModule {
    use std::signer;

    struct GenStruct<T> has store, copy, drop, key {
        value: T
    }

    public fun create_gen_struct<T>(value: T): GenStruct<T> has copy, drop {
        GenStruct<T> { value }
    }

    public fun move_to_signer<T>(s: signer, value: T) {
        let gs = create_gen_struct(value);
        move_to<GenStruct<T>>(&s, gs);
    }

    public fun exists<T>(addr: address): bool {
        exists<GenStruct<T>>(addr)
    }

    public fun borrow_value<T>(addr: address): &T {
        let gs_ref = borrow_global<GenStruct<T>>(addr);
        &gs_ref.value
    }
}


//# run 0xCAFE::GenericStructModule::create_gen_struct --args 100u8


//# run 0xCAFE::GenericStructModule::move_to_signer --signers 0xDEAD --args 55u8


//# run 0xCAFE::GenericStructModule::exists --args 0xDEAD


//# publish
module 0xCAFE::UseGenericModule {
    use 0xCAFE::GenericStructModule;
    use std::signer;

    public fun store_and_check(s: signer, val: u64): bool {
        GenericStructModule::move_to_signer<u64>(s, val);
        GenericStructModule::exists<u64>(signer::address_of(&s))
    }

    public fun invoke_generic_func(): u8 {
        let gs = GenericStructModule::create_gen_struct<u8>(42u8);
        gs.value
    }
}


//# run 0xCAFE::UseGenericModule::store_and_check --signers 0xBEEF --args 123u64


//# run 0xCAFE::UseGenericModule::invoke_generic_func


//# publish
module 0xCAFE::LoopModule {
    public fun for_loop_sum(lower: u64, upper: u64): u64 {
        let sum = 0;
        for (i in lower..upper) {
            sum = sum + i;
        };
        sum
    }
}


//# run 0xCAFE::LoopModule::for_loop_sum --args 1u64 5u64


//# publish
module 0xCAFE::UnusedVarWarning {
    public fun function_with_unused() {
        let _used = 10u8;
        let _unused_var = 20u8; // variable declared but not used
        let another_used = 5u8;
        let _result = another_used + _used;
        // No actual usage of _unused_var, which triggers warning (comment for test)
    }
}


//# run 0xCAFE::UnusedVarWarning::function_with_unused


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 0189d3c651e54103130a64707b72129f: Test that creating and checking existence of generic structs in multiple modules, and passing them through functions, works correctly with storage, key management, and type parameters.
// b64c89f57033b655cd607100490684a0: Create a traditional 'for' loop that iterates from a lower bound to an upper bound with variable declarations.
// 3bb6d261bd641609d8a0e89fd66e0b48: Identify and warn about unused variable assignments.
