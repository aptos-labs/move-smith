
//# publish
module 0xCAFE::InlineFuncs {
    // Module defining inline functions to be called from other modules

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}



//# publish
module 0xCAFE::Calculator {
    // A simple calculator module testing addition and lambda expressions

    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return sum + 10 to differentiate from simple sum
        sum + 10
    }

    public fun call_lambda(x: u8, y: u8): u8 {
        let add: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            a + b
        };
        add(x, y)
    }

    public fun nested_inline_calls(a: u8, b: u8): u8 {
        let sum = 0xCAFE::InlineFuncs::inline_add(a, b);
        sum + 5
    }

    struct Data has copy, drop, store {
        a: u8,
        b: u8,
    }
}



//# publish
module 0xCAFE::Accumulator {
    // Module to test accumulation by summing decreasing values from input

    public fun test1(x: u8, y: u8): u8 {
        let acc = 0u8;
        let val = x;

        while (val > 0) {
            acc = acc + val;
            val = val - 1;
        };

        acc + y
    }
}



//# run 0xCAFE::Calculator::add_and_return --args 7u8 8u8



//# run 0xCAFE::Calculator::call_lambda --args 12u8 15u8



//# run 0xCAFE::Calculator::nested_inline_calls --args 3u8 4u8



//# run 0xCAFE::Accumulator::test1 --args 5u8 3u8
