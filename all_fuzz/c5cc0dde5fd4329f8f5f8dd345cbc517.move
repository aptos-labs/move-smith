
//# publish
module 0xCAFE::AdditionModule {
    public fun add_and_return(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 100) {
            100u8
        } else {
            sum
        }
    }

    public fun lambda_example(a: u8, b: u8): u8 {
        let adder: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        adder(a, b)
    }
}


//# run 0xCAFE::AdditionModule::add_and_return --args 40u8 50u8


//# run 0xCAFE::AdditionModule::add_and_return --args 60u8 50u8


//# run 0xCAFE::AdditionModule::lambda_example --args 30u8 70u8



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AdditionModule;

    public inline fun call_inline_add_and_return(a: u8, b: u8): u8 {
        AdditionModule::add_and_return(a, b)
    }

    public fun call_lambda(a: u8, b: u8): u8 {
        AdditionModule::lambda_example(a, b)
    }
}


//# run 0xCAFE::CallerModule::call_inline_add_and_return --args 10u8 15u8


//# run 0xCAFE::CallerModule::call_lambda --args 20u8 25u8



//# publish
module 0xCAFE::ResourceWithCallback {
    use std::signer;

    struct R has key, store {
        counter: u8,
    }

    public fun create_resource(s: signer) {
        let r = R {counter: 0};
        move_to<R>(&s, r);
    }

    public fun incr_counter(s: signer) {
        let r_mut_ref: &mut R = borrow_global_mut<R>(signer::address_of(&s));
        r_mut_ref.counter = r_mut_ref.counter + 1;
    }

    // A callback type that increments the resource counter
    public fun run_callback_incr(mut_ref: &mut R, callback: &(|&mut R|)) {
        (*callback)(mut_ref);
    }

    public fun callback_increment(r_mut_ref: &mut R) {
        r_mut_ref.counter = r_mut_ref.counter + 1;
    }

    // Function that demonstrates calling callback within resource context
    public fun test_callback(s: signer) {
        let r_mut_ref: &mut R = borrow_global_mut<R>(signer::address_of(&s));
        run_callback_incr(r_mut_ref, &callback_increment);
    }

    public fun read_counter(s: signer): u8 {
        let r_ref: &R = borrow_global<R>(signer::address_of(&s));
        r_ref.counter
    }

    public fun remove_resource(s: signer) {
        let _r = move_from<R>(signer::address_of(&s));
    }
}


//# run 0xCAFE::ResourceWithCallback::create_resource --signers 0xDDDD


//# run 0xCAFE::ResourceWithCallback::read_counter --signers 0xDDDD


//# run 0xCAFE::ResourceWithCallback::incr_counter --signers 0xDDDD


//# run 0xCAFE::ResourceWithCallback::test_callback --signers 0xDDDD


//# run 0xCAFE::ResourceWithCallback::read_counter --signers 0xDDDD


//# run 0xCAFE::ResourceWithCallback::remove_resource --signers 0xDDDD


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 4bcb914d292492b66943fd4a00a173d3: Test that calling a callback within a move-sensitive resource context does not cause reentrancy errors when the callback accesses or modifies the resource.
