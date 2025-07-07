
//# publish
module 0xCAFE::Addition {
    public fun add_two_values_and_return_constant(a: u8, b: u8): u8 {
        let _sum = a + b; // renamed to _sum to suppress warning about unused variable
        42u8
    }
}




//# run 0xCAFE::Addition::add_two_values_and_return_constant --args 10u8 32u8




//# publish
module 0xCAFE::LambdaModule {
    public fun apply_lambda(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let sum = x + y;
            let diff = if (x > y) { x - y } else { y - x };
            (sum, diff)
        };
        lambda(a, b)
    }
}




//# run 0xCAFE::LambdaModule::apply_lambda --args 15u8 5u8




//# publish
module 0xCAFE::InlineCrossModule {
    use 0xCAFE::Addition;

    public inline fun inline_caller(a: u8, b: u8): u8 {
        let _result = Addition::add_two_values_and_return_constant(a, b);
        _result
    }

    public fun call_inline_caller(a: u8, b: u8): u8 {
        inline_caller(a, b)
    }
}




//# run 0xCAFE::InlineCrossModule::call_inline_caller --args 20u8 22u8




//# publish
module 0xCAFE::MutableResourceLoop {
    use std::signer;

    struct Counter has key, store {
        value: u8,
    }

    public fun create_counter(s: signer, init_val: u8) {
        let counter = Counter { value: init_val };
        move_to<Counter>(&s, counter);
    }

    public fun increment_counter_loop(s: signer, increment: u8, times: u8): u8 {
        let counter_ref: &mut Counter = borrow_global_mut<Counter>(signer::address_of(&s));
        let i = 0u8;
        while (i < times) {
            counter_ref.value = counter_ref.value + increment;
            i = i + 1;
        };
        counter_ref.value
    }
}




//# run 0xCAFE::MutableResourceLoop::create_counter --signers 0xDEAD --args 10u8




//# run 0xCAFE::MutableResourceLoop::increment_counter_loop --signers 0xDEAD --args 2u8 5u8




//# publish
module 0xCAFE::MoveAndUpdate {
    public fun move_and_update_values(): (u8, u8) {
        let x = 10u8;
        let y = x;
        let x = 20u8;
        // return y and then x for verification
        (y, x)
    }
}




//# run 0xCAFE::MoveAndUpdate::move_and_update_values
