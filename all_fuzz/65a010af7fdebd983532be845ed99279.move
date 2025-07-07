
//# publish
module 0xCAFE::LambdaUse {
    // Define f1 locally since 0xCAFE::MyModule doesn't exist.
    public fun f1(x: u8, flag: bool): u8 {
        if (flag) {
            x + 1
        } else {
            x
        }
    }

    // Define a struct similar to what Mod::f3 might have returned
    struct SumStruct has copy, drop, store {
        x: u32,
        y: u32,
    }

    // Define f3 locally (simulate the behavior)
    public fun f3(x: u16): SumStruct {
        SumStruct { x: (x as u32) * 2, y: (x as u32) * 3 }
    }

    public fun add_then_f1(x: u8, y: u8, flag: bool): u8 {
        let sum = x + y;
        // call the locally defined f1
        Self::f1(sum, flag)
    }

    public fun run_lambda(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(10u8, 15u8)
    }

    public fun run_nested(x: u16): u32 {
        let s = Self::f3(x);
        s.x + s.y
    }
}



//# run 0xCAFE::LambdaUse::add_then_f1 --args 10u8 20u8 true



//# run 0xCAFE::LambdaUse::run_lambda



//# run 0xCAFE::LambdaUse::run_nested --args 25u16
