
//# publish
module 0xCAFE::NestedCalls {

    /// A helper function emulating `MyModule::f1` behavior:
    /// increment `val` by 1 until it is >= 10, then add 1 more and return.
    public fun f1(val: u8, flag: bool): u8 {
        let res = val;
        if (flag) {
            while (res < 10) {
                res = res + 1;
            };
            res = res + 1;
            res
        } else {
            res
        }
    }

    /// A helper function emulating `MyModule::f2` behavior:
    /// return (a + 1, a + 2) as a tuple.
    public fun f2(a: u16): (u16, u16) {
        (a + 1, a + 2)
    }

    public fun compute_addition_then_return_value(a: u8, b: u8): u8 {
        let sum = a + b;
        // Use local f1 that increments sum until >= 10 and then adds 1
        f1(sum, true)
    }

    public fun apply_lambda_and_call_nested(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            let added = x + y;
            f1(added, (added % 2u8 == 0u8))
        };
        lambda(a, b)
    }

    public fun call_inline_function_and_sum(a: u16, b: u16): u16 {
        let (res_a, res_b) = f2(a);
        // Sum the first inline function result with b and return
        res_a + res_b + b
    }
}



//# run 0xCAFE::NestedCalls::compute_addition_then_return_value --args 3u8 6u8



//# run 0xCAFE::NestedCalls::apply_lambda_and_call_nested --args 4u8 5u8



//# run 0xCAFE::NestedCalls::call_inline_function_and_sum --args 7u16 10u16
