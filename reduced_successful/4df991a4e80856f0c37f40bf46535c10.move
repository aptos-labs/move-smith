
//# publish
module 0xCAFE::Addition {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let _sum = a + b;
        42u8
    }
}



//# publish
module 0xCAFE::InlineCaller {
    // Since 0xCAFE::MyModule doesn't exist, define it here with `f2`
    public fun f2(a: u16): (u16, u16) {
        // For example, return (a, a)
        (a, a)
    }

    public fun call_f2_and_sum(a: u16): u16 {
        let (x, y) = Self::f2(a);
        x + y
    }
}



//# publish
module 0xCAFE::SpecCheck {
    // Constant names must start with uppercase letter
    const IsSpecModule: bool = true;
}



//# publish
module 0xCAFE::NumericToken {
    struct NumToken has copy, drop {
        x: u8,
        y: u8
    }

    public fun create_token(x: u8, y: u8): NumToken {
        NumToken { x, y }
    }

    public fun get_sum(token: &NumToken): u8 {
        token.x + token.y
    }
}



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
