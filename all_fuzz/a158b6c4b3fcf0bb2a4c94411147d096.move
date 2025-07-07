
//# publish
module 0xCAFE::LambdaModule {
    // Module to test lambdas and abilities annotations

    struct CopyDropStore has copy, drop, store {
        a: u8,
        b: u8,
    }

    // Define the missing struct S here
    struct S has copy, drop, store {
        x: u32,
        y: u32,
    }

    // Define the missing function f2 here
    public fun f2(x: u16): (u16, u16) {
        (x, x + 1)
    }

    public fun add_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        sum
    }

    public fun use_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    public fun inline_call(x: u16): u32 {
        let (a, b) = f2(x);
        let s = S { x: (a as u32), y: (b as u32) };
        s.x + s.y
    }
}



//# run 0xCAFE::LambdaModule::add_and_return_sum --args 10u8 20u8



//# run 0xCAFE::LambdaModule::use_lambda --args 3u8 4u8



//# run 0xCAFE::LambdaModule::inline_call --args 15u16
