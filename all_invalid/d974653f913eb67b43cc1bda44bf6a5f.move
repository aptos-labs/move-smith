
//# publish
module 0xCAFE::TestAdd {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun with_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
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
        let tmp1: u8 = 5u8;
        let tmp2: u8 = 10u8;
        let sum: u8 = tmp1 + tmp2;
        let flag: bool = true;
    }

    public fun init_dummy(s: signer) {
        let d = Dummy { x: 100u8 };
        move_to<Dummy>(&s, d);
    }
}


//# run 0xCAFE::SpecVars::init_dummy --signers 0xCAFE


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 7bed143cecaa4a44ba2a9ddc13d7c0a5: Define structs with type parameters in your modules.
// ad594dc711d5be629d74748562d11d51: Declare and initialize local variables in specifications.
