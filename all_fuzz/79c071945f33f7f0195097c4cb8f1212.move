
//# publish
module 0xCAFE::NestedCalls {
    /// Added inline function f2 here to replace the missing MyModule::f2 
    /// as external module MyModule is not accessible.
    public fun f2(x: u16): (u16, u16) {
        (x, x + 1)
    }

    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 20) {
            100u8
        } else {
            50u8
        }
    }

    public fun lambda_example(): u8 {
        let f: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b + 1u8
        };
        f(5u8, 6u8)
    }

    public fun call_inline_function(x: u16): (u16, u16) {
        // Call local inline f2 instead of external module call
        f2(x)
    }

    struct NewStruct has copy, drop {
        a: u64,
        b: bool,
    }
}



//# run 0xCAFE::NestedCalls::add_and_return --args 10u8 15u8



//# run 0xCAFE::NestedCalls::lambda_example



//# run 0xCAFE::NestedCalls::call_inline_function --args 12u16
