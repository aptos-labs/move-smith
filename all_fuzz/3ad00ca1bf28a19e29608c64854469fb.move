
//# publish
module 0xCAFE::NestedCalls {

    // Define f1 here: accepts a u8 and a bool, returns u8
    // Per comment: if bool is true, increment value by 1
    public fun f1(value: u8, flag: bool): u8 {
        if (flag) {
            value + 1
        } else {
            value
        }
    }

    // Define f2 inline here as well:
    // Accepts a u16 and returns a tuple (u16, u16)
    // For example, return (value, value * 2)
    public fun f2(value: u16): (u16, u16) {
        (value, value * 2)
    }

    public fun add_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        // use f1 with a boolean flag true, forcing it to increment sum by 1
        let result = Self::f1(sum, true);
        result
    }

    public fun call_inline_function(value: u16): u16 {
        let (a, _b) = Self::f2(value);
        a
    }

    public fun lambda_example(x: u8, y: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy + drop = |a: u8, b: u8| {
            (a + b, a * b)
        };
        lambda(x, y)
    }
}



//# run 0xCAFE::NestedCalls::add_and_return_sum --args 3u8 4u8



//# run 0xCAFE::NestedCalls::call_inline_function --args 20u16



//# run 0xCAFE::NestedCalls::lambda_example --args 5u8 7u8
