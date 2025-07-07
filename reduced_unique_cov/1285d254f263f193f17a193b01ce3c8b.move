
//# publish
module 0xCAFE::LambdaTest {
    public fun add_and_return_expected(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum == 100) {
            42u8
        } else {
            0u8
        }
    }

    public fun run_lambda_example(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| a + b;
        let multiply_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| a * b;

        let sum = add_lambda(x, y);
        let product = multiply_lambda(x, y);

        // Return sum plus product as a simple test
        sum + product
    }

    public fun run_double_lambda(x: u8): u8 {
        let combined_lambda: |u8| u8 has copy+drop = |a: u8| {
            let inner_lambda: |u8| u8 has copy+drop = |b: u8| b * 2;
            inner_lambda(a) + 3
        };
        combined_lambda(x)
    }
}



//# run 0xCAFE::LambdaTest::add_and_return_expected --args 55u8 45u8



//# run 0xCAFE::LambdaTest::run_lambda_example --args 3u8 4u8



//# run 0xCAFE::LambdaTest::run_double_lambda --args 10u8




//# publish
module 0xCAFE::GenericStructsTest {
    use std::signer;

    struct S has store, copy, drop {
        x: u32,
        y: u32,
    }

    struct Wrapper<T> has store, key {
        inner: T
    }

    // Creates and moves a Wrapper storing S to the signer's account
    public fun create_wrapped_struct(s: signer, x: u32, y: u32) {
        let inner = S { x, y };
        let w = Wrapper<S> { inner };
        move_to<Wrapper<S>>(&s, w);
    }

    // Reads the wrapped struct and returns sum of fields
    public fun read_wrapped_struct(s: signer): u32 {
        let w_ref = borrow_global<Wrapper<S>>(signer::address_of(&s));
        w_ref.inner.x + w_ref.inner.y
    }

    // Updates the wrapped struct fields
    public fun update_wrapped_struct(s: signer, x: u32, y: u32) {
        let w_mut_ref = borrow_global_mut<Wrapper<S>>(signer::address_of(&s));
        w_mut_ref.inner.x = x;
        w_mut_ref.inner.y = y;
    }

    // Removes the wrapped struct and returns sum of fields
    public fun remove_wrapped_struct(s: signer): u32 {
        let w = move_from<Wrapper<S>>(signer::address_of(&s));
        let Wrapper { inner } = w;
        inner.x + inner.y
    }

    // Defines inline function f2 returning a tuple (u16, u16)
    public inline fun f2(a: u16): (u16, u16) {
        (a, a + 1)
    }

    // Calls inline function f2 to get a tuple, sums and returns
    public fun call_inline_f2(a: u16): u16 {
        let (x, y) = f2(a);
        x + y
    }
}



//# run 0xCAFE::GenericStructsTest::create_wrapped_struct --signers 0xBABA --args 10u32 20u32



//# run 0xCAFE::GenericStructsTest::read_wrapped_struct --signers 0xBABA



//# run 0xCAFE::GenericStructsTest::update_wrapped_struct --signers 0xBABA --args 30u32 40u32



//# run 0xCAFE::GenericStructsTest::read_wrapped_struct --signers 0xBABA



//# run 0xCAFE::GenericStructsTest::remove_wrapped_struct --signers 0xBABA



//# run 0xCAFE::GenericStructsTest::call_inline_f2 --args 100u16




//# publish
module 0xCAFE::GenericPassTest {
    use std::signer;
    use 0xCAFE::GenericStructsTest;

    struct Holder<T> has store, key {
        value: T
    }

    // Create a Holder wrapping Wrapper<S> transferred from GenericStructsTest
    public fun create_holder_from_wrapper<T>(s: signer, val: T) {
        let holder = Holder<T> { value: val };
        move_to<Holder<T>>(&s, holder);
    }

    public fun pass_wrapper(s_holder: signer, s_wrapper: signer) {
        let wrapper = move_from<GenericStructsTest::Wrapper<GenericStructsTest::S>>(signer::address_of(&s_wrapper));
        create_holder_from_wrapper<GenericStructsTest::Wrapper<GenericStructsTest::S>>(s_holder, wrapper);
    }

    public fun read_holder(s: signer): u32 {
        let holder_ref = borrow_global<Holder<GenericStructsTest::Wrapper<GenericStructsTest::S>>>(signer::address_of(&s));
        let inner_ref = &holder_ref.value.inner;
        inner_ref.x + inner_ref.y
    }
}



//# run 0xCAFE::GenericStructsTest::create_wrapped_struct --signers 0xABCD --args 11u32 12u32



//# run 0xCAFE::GenericPassTest::pass_wrapper --signers 0xBEEF --signers 0xABCD



//# run 0xCAFE::GenericPassTest::read_holder --signers 0xBEEF
