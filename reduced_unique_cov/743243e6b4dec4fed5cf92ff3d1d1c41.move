
//# publish
module 0xCAFE::TestAdd {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun with_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x, y| {
            x + y
        };
        lambda(a, b)
    }

    struct Container<T> has copy, drop {
        val: T
    }

    public fun create_container(val: u8): Container<u8> {
        Container { val }
    }
}



//# run 0xCAFE::TestAdd::add_and_return_sum --args 10u8 20u8



//# run 0xCAFE::TestAdd::with_lambda --args 15u8 25u8



//# run 0xCAFE::TestAdd::create_container --args 42u8




//# publish
module 0xCAFE::TestInlineCaller {
    use 0xCAFE::TestAdd;

    public inline fun inline_double(a: u8): u8 {
        // call add_and_return_sum twice, nested
        let partial = TestAdd::add_and_return_sum(a, 1u8);
        TestAdd::add_and_return_sum(partial, 1u8)
    }

    public fun call_inline(a: u8): u8 {
        inline_double(a)
    }
}



//# run 0xCAFE::TestInlineCaller::call_inline --args 10u8




//# publish
module 0xCAFE::SpecVars {
    use std::signer;

    struct Dummy has store, key {
        x: u8,
    }

    spec module {
        // declare and initialize local variables in specification
        let tmp1 = 5u8;
        let tmp2 = 10u8;
        let sum = tmp1 + tmp2;
        let flag = true;
    }

    public fun init_dummy(s: signer) {
        let d = Dummy { x: 100u8 };
        move_to<Dummy>(&s, d);
    }
}



//# run 0xCAFE::SpecVars::init_dummy --signers 0xCAFE
