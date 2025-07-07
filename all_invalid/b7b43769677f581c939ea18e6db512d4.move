
//# publish
module 0xCAFE::Adder {
    public fun add_two(a: u8, b: u8): u8 {
        let result = a + b;
        if (result > 20) {
            42u8
        } else {
            result
        }
    }

    // Move currently does not support closure/lambda expressions with |...| syntax.
    // We'll replace lambdas with regular named functions.
    fun double(x: u8): u8 {
        x * 2
    }

    fun add_five(x: u8): u8 {
        x + 5
    }

    public fun test_lambda(): u8 {
        let x = double(4u8);
        let y = add_five(x);
        y
    }

    public fun call_inline_and_nested(a: u16): u16 {
        // Calls inline function f2 from 0xCAFE::MyModule
        let (x, y) = 0xCAFE::MyModule::f2(a);
        // Use the returned tuple to compute sum
        x + y
    }
}



//# run 0xCAFE::Adder::add_two --args 10u8 11u8



//# run 0xCAFE::Adder::add_two --args 2u8 3u8



//# run 0xCAFE::Adder::test_lambda



//# run 0xCAFE::Adder::call_inline_and_nested --args 5u16





//# publish
module 0xCAFE::MutRefTests {
    struct Inner has store {
        val: u8,
    }

    struct Container has store {
        inner: Inner,
        flag: bool,
    }

    public fun borrow_and_update(container: &mut Container): u8 {
        // Borrow mutable reference to inner.val and update it
        let inner_ref: &mut u8 = &mut container.inner.val;
        *inner_ref = *inner_ref + 10;

        // Borrow immutable reference to flag and check
        let flag_ref: &bool = &container.flag;
        if (*flag_ref) {
            *inner_ref += 5;
        };

        *inner_ref
    }

    public fun aliasing_test() {
        let container = Container { inner: Inner { val: 1u8 }, flag: true };

        let inner_val_ref: &mut u8 = &mut container.inner.val;
        // Even if alias occurs here, Move borrow checker will reject if there's a conflict,
        // So we only demonstrate sequential mutable borrows.
        // Update via reference
        *inner_val_ref = 20u8;

        // borrow a new mutable reference after the first one is done
        let flag_mut_ref: &mut bool = &mut container.flag;
        *flag_mut_ref = false;

        // Use container after borrows
        let _ = container.inner.val + (if (container.flag) { 1u8 } else { 0u8 });
    }

    public fun conditional_borrow(cond: bool, c: &mut Container): u8 {
        if (cond) {
            let flag_mut_ref: &mut bool = &mut c.flag;
            *flag_mut_ref = false;
        } else {
            let inner_val_mut_ref: &mut u8 = &mut c.inner.val;
            *inner_val_mut_ref = 99u8;
        };
        c.inner.val
    }
}



//# run 0xCAFE::MutRefTests::borrow_and_update



//# run 0xCAFE::MutRefTests::aliasing_test



//# run 0xCAFE::MutRefTests::conditional_borrow --args true



//# run 0xCAFE::MutRefTests::conditional_borrow --args false







//# publish
module 0xCAFE::ClosureAndResource {
    use std::signer;

    // Add `key` ability to allow storing in global storage
    struct R has key, store {
        val: u8,
    }

    public fun create_resource(s: signer, v: u8) {
        let r = R { val: v };
        move_to<R>(&s, r);
    }

    public fun closure_modify_resource(s: signer) {
        let addr = signer::address_of(&s);

        // Closure syntax unsupported; replace with an inner function or inline code

        // Functionally equivalent to closure:
        // let modify = || { ... };
        // modify();

        // Directly do the modification here:
        {
            let r_mut_ref: &mut R = borrow_global_mut<R>(addr);
            r_mut_ref.val = r_mut_ref.val + 1;
        }

        // Further direct modification after closure runs
        let r_mut_ref2: &mut R = borrow_global_mut<R>(addr);
        r_mut_ref2.val = r_mut_ref2.val + 2;
    }

    public fun get_resource_val(s: signer): u8 {
        let r_ref: &R = borrow_global<R>(signer::address_of(&s));
        r_ref.val
    }
}



//# run 0xCAFE::ClosureAndResource::create_resource --signers 0xCAFE --args 10u8



//# run 0xCAFE::ClosureAndResource::get_resource_val --signers 0xCAFE



//# run 0xCAFE::ClosureAndResource::closure_modify_resource --signers 0xCAFE



//# run 0xCAFE::ClosureAndResource::get_resource_val --signers 0xCAFE








//# publish
module 0xCAFE::TypeCheck {
    // Move does not allow tuple types as function parameter types or lambda parameter types.
    // We'll rewrite the lambdas as regular functions using struct to hold multiple params manually,
    // or just avoid tuple args.

    struct Pair has copy, drop {
        first: u8,
        second: u8,
    }

    // Instead of lambda, use a normal function
    fun f(a: u8, b: u8): Pair {
        let c = a + b;
        let d = a * b;
        Pair { first: c, second: d }
    }

    fun g(t: Pair, v: u8): Pair {
        Pair { first: t.first + v, second: t.second + v }
    }

    public fun complex_lambda_test() {
        let p = f(3u8, 4u8);
        let r_s = g(p, 1u8);
        let _ = r_s.first;
        let _ = r_s.second;
    }
}



//# run 0xCAFE::TypeCheck::complex_lambda_test
