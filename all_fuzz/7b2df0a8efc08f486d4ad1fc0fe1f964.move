
//# publish
module 0xCAFE::LambdaModule {
    public fun add_two_u8(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let result = lambda(a, b);
        if (result > 10) {
            42u8
        } else {
            10u8
        };
        42u8
    }

    public fun double_and_add(a: u8, b: u8): u8 {
        let double: |u8| u8 has copy+drop = |x: u8| {
            x * 2
        };
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            double(x) + y
        };
        lambda(a, b)
    }

    public fun runner() {
        let _ = add_two_u8(5u8, 8u8);
        let _ = double_and_add(3u8, 4u8);
    }
}



//# run 0xCAFE::LambdaModule::runner



//# publish
module 0xCAFE::NestedCallModule {

    struct S has copy, drop, store {
        x: u32,
        y: u32,
    }

    public fun f2(x: u16): (u32, u32) {
        (x as u32, (x * 2) as u32)
    }

    public fun f3(x: u16): S {
        S {
            x: (x as u32) * 3,
            y: (x as u32) * 4,
        }
    }

    public fun call_inline_and_nested(x: u16): u32 {
        let (a, b) = f2(x);
        let s = f3(x);
        ((a + b) as u32) + s.x + s.y
    }

    public fun runner() {
        let _ = call_inline_and_nested(7u16);
    }
}



//# run 0xCAFE::NestedCallModule::runner



//# publish
module 0xCAFE::HexStringModule {
    public fun get_hex_bytes(): vector<u8> {
        b"4d6f7665"
    }

    public fun get_hex_bytes_explicit(): vector<u8> {
        x"4D6F7665"
    }

    public fun runner() {
        let _ = get_hex_bytes();
        let _ = get_hex_bytes_explicit();
    }
}



//# run 0xCAFE::HexStringModule::runner
