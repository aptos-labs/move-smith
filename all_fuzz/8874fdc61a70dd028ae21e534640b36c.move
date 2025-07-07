
//# publish
module 0xCAFE::Adder {
    public fun add_then_return_const(a: u8, b: u8): u8 {
        let sum = a + b;
        let _unused = sum; // keep sum in local variable
        42u8
    }

    public fun use_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Adder;

    public fun call_inline_add(a: u8, b: u8): u8 {
        Adder::inline_add(a, b)
    }

    public fun test_local_after_loop(x: u8): u8 {
        let local = x;
        let i = 0u8;
        while (i < 3u8) {
            i = i + 1u8;
        };
        local
    }
}

/*
// Invalid Move source code example for diagnostics during parsing.
// This example intentionally contains errors and thus is commented out.


//     // Missing semicolon, wrong keyword "funx"
//     // public funx bad_function() {
//     //     let a = 1;
//     // }

//     // Invalid syntax: assignment in function parameter list
//     // public fun param_err(mut x: u8): u8 {
//     //     x
//     // }
// }
*/


//# run 0xCAFE::Adder::add_then_return_const --args 5u8 10u8


//# run 0xCAFE::Adder::use_lambda --args 7u8 8u8


//# run 0xCAFE::Caller::call_inline_add --args 15u8 27u8


//# run 0xCAFE::Caller::test_local_after_loop --args 9u8
