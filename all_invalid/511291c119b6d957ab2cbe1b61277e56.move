
//# publish
module 0xCAFE::Addition {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        42u8
    }
}


//# run 0xCAFE::Addition::add_and_return_fixed --args 10u8 32u8


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::MyModule;

    public fun call_f2_and_sum(a: u16): u16 {
        let (x, y) = MyModule::f2(a);
        x + y
    }
}


//# run 0xCAFE::InlineCaller::call_f2_and_sum --args 20u16


//# publish
module 0xCAFE::SpecCheck {
    const is_spec_module: bool = true;
}


//# publish
module 0xCAFE::NumericToken {
    struct NumToken has copy, drop {
        0: u8,
        1: u8
    }

    public fun create_token(x: u8, y: u8): NumToken {
        NumToken { 0: x, 1: y }
    }

    public fun get_sum(token: &NumToken): u8 {
        token.0 + token.1
    }
}


//# run 0xCAFE::NumericToken::create_token --args 7u8 8u8


//# run 0xCAFE::NumericToken::get_sum --args 7u8 8u8


//# publish
module 0xCAFE::ShadowingExample {
    public fun foo() {
        let _x = 100u8;

        let shadow_lambda: |u8|u8 = |_x: u8| {
            _x
        };

        let _res = shadow_lambda(200u8);
        _x = 1u8;
        let _final = _x;
    }
}


//# run 0xCAFE::ShadowingExample::foo


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 7436b27712b729874971d9d4406efa42: Identify spec modules by setting the 'is_spec_module' flag to true.
// 1ec968b9866c644bfe28fd6c982f270e: Use numeric tokens to identify positional fields in Move code.
// 752981d9b3e9a6a13ea7834c2e4b5abe: Verify that the inner function `foo` can correctly shadow and assign to the outer variable `_x` through a lambda parameter.
