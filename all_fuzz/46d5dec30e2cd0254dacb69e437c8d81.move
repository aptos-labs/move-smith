
//# publish
module 0xCAFE::AdditionModule {
    // This module tests simple addition and returning a fixed value
    public fun add_and_fix(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum < 20) {
            42u8
        } else {
            100u8
        }
    }

    public fun with_lambda() {
        let f: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let result = f(2u8, 3u8);
        let _ = result;
    }
}



//# run 0xCAFE::AdditionModule::add_and_fix --args 10u8 5u8



//# run 0xCAFE::AdditionModule::with_lambda



//# publish
module 0xCAFE::NestedInlineCall {
    use 0xCAFE::AdditionModule;

    public inline fun inline_double_add(a: u8, b: u8): u8 {
        let intermediate = AdditionModule::add_and_fix(a, b);
        AdditionModule::add_and_fix(intermediate, 1u8)
    }

    public fun call_inline_double_add(): u8 {
        inline_double_add(3u8, 4u8)
    }
}



//# run 0xCAFE::NestedInlineCall::call_inline_double_add



//# publish
module 0xCAFE::CopyAssignModule {
    struct Data64 has copy, store, drop {
        value: u64
    }

    public fun copy_and_assign(x: u64): u64 {
        let d1 = Data64 { value: x };
        let d2 = copy d1;
        let d3 = d2;
        d3.value
    }
}



//# run 0xCAFE::CopyAssignModule::copy_and_assign --args 123456u64



//# publish
module 0xCAFE::ModifyExample {
    use std::signer;

    struct MObj has store, key {
        count: u64
    }

    public fun create_obj(account: &signer) {
        let obj = MObj { count: 0u64 };
        move_to<MObj>(account, obj);
    }

    public fun increment_obj(account: &signer) acquires MObj {
        let obj_ref = borrow_global_mut<MObj>(signer::address_of(account));
        obj_ref.count = obj_ref.count + 1;
    }

    public fun check_obj(account: &signer): u64 acquires MObj {
        let obj_ref = borrow_global<MObj>(signer::address_of(account));
        obj_ref.count
    }
}



//# run 0xCAFE::ModifyExample::create_obj --signers 0xD00D



//# run 0xCAFE::ModifyExample::increment_obj --signers 0xD00D



//# run 0xCAFE::ModifyExample::check_obj --signers 0xD00D



//# publish
module 0xCAFE::FunctionParamModule {
    public fun call_with_func_param<F: copy + drop + store>(x: u8, f: F): u8 {
        f(x)
    }

    public fun example() {
        let lambda: |u8| u8 has copy+drop = |a: u8| {
            a + 10
        };
        let res = call_with_func_param(5u8, lambda);
        let _ = res;
    }
}



//# run 0xCAFE::FunctionParamModule::example
