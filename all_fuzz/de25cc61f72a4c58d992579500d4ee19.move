
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return_42(a: u8, b: u8): u8 {
        let sum = a + b;
        let _unused = sum; // use sum to avoid unused warning
        42u8
    }
}



//# run 0xCAFE::AddModule::add_and_return_42 --args 10u8 32u8




//# publish
module 0xCAFE::LambdaModule {
    public fun test_lambda_capture(x: u8): u8 {
        let lambda: |u8| u8 has copy+drop = |a: u8| {
            a + x
        };
        lambda(5u8)
    }

    public fun test_lambda_no_capture(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        lambda(6u8, 7u8)
    }
}



//# run 0xCAFE::LambdaModule::test_lambda_capture --args 10u8



//# run 0xCAFE::LambdaModule::test_lambda_no_capture




//# publish
module 0xCAFE::InlineCallModule {
    use 0xCAFE::AddModule;

    public inline fun inline_add(a: u8, b: u8): u8 {
        AddModule::add_and_return_42(a, b)
    }

    public fun call_inline(a: u8, b: u8): u8 {
        inline_add(a, b)
    }
}



//# run 0xCAFE::InlineCallModule::call_inline --args 10u8 20u8




//# publish
module 0xCAFE::NamedAddressUsage {
    use std::vector;

    // Example function showing usage of named address with type argument and call syntax
    public fun use_named_address_and_type_args() {
        // Correct syntax: use vector::empty<u8>() or vector with explicit vector literal
        let v1: vector<u8> = vector::empty<u8>();
        let v2: vector<u8> = vector::empty<u8>();
        let _ = (v1, v2); // silence unused variable warnings
    }
}



//# run 0xCAFE::NamedAddressUsage::use_named_address_and_type_args




//# publish
module 0xCAFE::AbortTest {
    public fun abort_with_u8_underflow() {
        // Aborting with negative is unsigned underflow
        // fix type of abort to u64, because abort only accepts u64
        abort(0u64 - 1u64);
    }
}



//# run 0xCAFE::AbortTest::abort_with_u8_underflow




//# publish
module 0xCAFE::FunPointerModule {
    use std::vector;
    use std::signer;

    // A standalone function for test
    public fun standalone_fun(x: u8): u8 {
        x * 2u8
    }

    // Enum for function-pointer type with one parameter and one return
    public enum FunHolder has copy, drop {
        Function(|u8|u8)
    }

    // Enum nested holding FunHolder
    public enum ComposedFunHolder has copy, drop {
        NestedFun(FunHolder)
    }

    // Struct holding a FunHolder resource field
    struct FunResource has key {
        fun_ptr: FunHolder
    }

    // Store a FunResource under signer's account
    public fun store_fun_resource(s: signer) {
        let fr = FunResource { fun_ptr: FunHolder::Function(standalone_fun) };
        move_to<FunResource>(&s, fr);
    }

    // Move FunResource out of storage and invoke stored function pointer with argument
    public fun invoke_stored_fun(s: signer, arg: u8): u8 {
        let fr = move_from<FunResource>(signer::address_of(&s));
        let FunHolder::Function(f) = fr.fun_ptr;
        f(arg)
    }

    // Create FunHolder with a lambda capture and return it
    public fun create_lambda_fun_holder(x: u8): FunHolder {
        let lambda: |u8| u8 has copy+drop = |a: u8| {
            a + x
        };
        FunHolder::Function(lambda)
    }

    // Use vector of FunHolder
    public fun vec_of_funs() {
        let f1 = FunHolder::Function(standalone_fun);
        let f2 = create_lambda_fun_holder(10u8);
        let v = vector::empty<FunHolder>();
        vector::push_back(&mut v, f1);
        vector::push_back(&mut v, f2);
        let FunHolder::Function(f) = *vector::borrow(&v, 0);
        let _ = f(3u8);
        let FunHolder::Function(g) = *vector::borrow(&v, 1);
        let _ = g(4u8);
    }
}



//# run 0xCAFE::FunPointerModule::store_fun_resource --signers 0xBEEF



//# run 0xCAFE::FunPointerModule::invoke_stored_fun --signers 0xBEEF --args 5u8



//# run 0xCAFE::FunPointerModule::vec_of_funs

