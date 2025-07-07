
//# publish
module 0xCAFE::MathOps {
    public fun add_and_check(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42u8
        } else {
            sum
        }
    }

    public fun with_lambda(x: u8, y: u8): u8 {
        let add: |u8, u8| u8 has copy+drop = |a: u8, b: u8| { a + b };
        add(x, y)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}




//# publish
module 0xCAFE::LambdaAndGeneric {
    use std::signer;

    // PhantomMarker needs to have store ability because it's stored in Phantom
    struct PhantomMarker<T> has store {}

    struct Phantom<T: store> has key, store {
        dummy: u8, // data needed for resource
        _marker: PhantomMarker<T>,
    }

    public fun create_phantom_resource<T: store>(s: signer, data: u8) {
        let resource = Phantom<T> {
            dummy: data,
            _marker: PhantomMarker {}
        };
        move_to<Phantom<T>>(&s, resource);
    }

    public fun exists_phantom<T: store>(addr: address): bool {
        exists<Phantom<T>>(addr)
    }

    public fun call_generic_lambda<T>(l: |T| u8, val: T): u8 {
        l(val)
    }

    public fun create_and_call_lambda<T: store>(s: signer, val: T, data: u8) {
        create_phantom_resource<T>(s, data);

        let lambda: |T| u8 has copy+drop = |x: T| {
            // Phantom generic parameter is structurally ignored here
            7u8
        };
        let result = call_generic_lambda<T>(lambda, val);
        // Use the result somehow to prevent optimization
        let _ = result;
    }
}




//# publish
module 0xCAFE::CrossModule {
    use 0xCAFE::MathOps;

    public fun test_nested_calls(a: u8, b: u8): u8 {
        let first = MathOps::inline_add(a, b);
        let second = MathOps::add_and_check(first, 1);
        second
    }
}




//# run 0xCAFE::MathOps::add_and_check --args 5u8 4u8




//# run 0xCAFE::MathOps::with_lambda --args 3u8 8u8




//# run 0xCAFE::CrossModule::test_nested_calls --args 1u8 2u8




//# run 0xCAFE::LambdaAndGeneric::create_and_call_lambda --signers 0xBEEF --args 10u8 50u8




//# run 0xCAFE::LambdaAndGeneric::exists_phantom --args 0xBEEF
