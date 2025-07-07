
//# publish
module 0xCAFE::ClosureShadowing {
    use std::debug;

    struct Dummy has copy, drop {}

    const CONST_VAL: u8 = 42;

    struct AnnotatedStruct has copy, drop {
        value: u8
    }

    struct PropertySetStruct has copy, drop {}

    public fun foo(x: u8, f: &fun(u8): u8): u8 {
        let x = f(x);
        x
    }

    public fun runner(): u8 {
        let x = 1u8;

        let f = &fun(x_param: u8): u8 {
            3u8
        };

        let x = foo(x, f);
        debug::print(&x);
        x
    }
}



//# run 0xCAFE::ClosureShadowing::runner
