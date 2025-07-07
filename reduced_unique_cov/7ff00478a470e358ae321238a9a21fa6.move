
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10u8
    }
}


//# run 0xCAFE::AddModule::add_and_return_sum --args 3u8 4u8



//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AddModule;

    public inline fun nested_calls(x: u8, y: u8): u8 {
        let sum = AddModule::add_and_return_sum(x, y);
        if (sum > 15) {
            sum - 5
        } else {
            sum + 5
        }
    }
}


//# run 0xCAFE::NestedCallModule::nested_calls --args 3u8 4u8



//# publish
module 0xCAFE::LambdaStructModule {
    struct LambdaHolder has copy, drop {
        lambda: |u8, u8| u8
    }

    public fun invoke_and_update_lambda(holder: &mut LambdaHolder, a: u8, b: u8): u8 {
        let result = (holder.lambda)(a, b);
        // Re-assign a new lambda using the result (mutable borrow)
        *holder = LambdaHolder { lambda: |x: u8, y: u8| x + y + result };
        result
    }
}


//# run 0xCAFE::LambdaStructModule::invoke_and_update_lambda --args 2u8 3u8



//# publish
module 0xCAFE::NativeModule {
    native public fun native_add(a: u8, b: u8): u8;

    public fun use_native_add(x: u8, y: u8): u8 {
        Self::native_add(x, y)
    }
}


//# run 0xCAFE::NativeModule::use_native_add --args 2u8 3u8



//# publish
module 0xCAFE::ResourceAcquireModule {
    use std::signer;

    struct Res has key, store {
        val: u8,
    }

    public fun create_resource(s: signer, v: u8) {
        let r = Res { val: v };
        move_to<Res>(&s, r);
    }

    public fun borrow_resource(s: signer): u8 {
        let r_ref = borrow_global<Res>(signer::address_of(&s));
        r_ref.val
    }

    public fun update_resource(s: signer, new_val: u8) {
        let r_mut_ref = borrow_global_mut<Res>(signer::address_of(&s));
        r_mut_ref.val = new_val;
    }

    public fun remove_resource(s: signer) {
        let r = move_from<Res>(signer::address_of(&s));
        let Res { val: _v } = r;
    }
}


//# run 0xCAFE::ResourceAcquireModule::create_resource --signers 0xD1CE --args 7u8


//# run 0xCAFE::ResourceAcquireModule::borrow_resource --signers 0xD1CE


//# run 0xCAFE::ResourceAcquireModule::update_resource --signers 0xD1CE --args 9u8


//# run 0xCAFE::ResourceAcquireModule::borrow_resource --signers 0xD1CE


//# run 0xCAFE::ResourceAcquireModule::remove_resource --signers 0xD1CE


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 08959ecd08fd24a9311a87f00cf88af7: Test that a struct containing a lambda field can have the lambda invoked and its result mutable-borrowed and assigned within a function.
// 9e39b74edbca9497671d446bc896bd5f: Declare functions or modules as 'native' to indicate native implementation
// 90debe7393335a565512e6ee2d040fbb: Acquire resources of types (structs) defined in the same module using move_from, borrow_global, or borrow_global_mut.
