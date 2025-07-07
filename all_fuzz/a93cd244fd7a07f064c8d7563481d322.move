
//# publish
module 0xCAFE::Adder {
    public fun add_and_return(value1: u8, value2: u8): u8 {
        let sum = value1 + value2;
        // Return 42 if sum equals or exceeds 42, otherwise return the sum
        if (sum >= 42) {
            42
        } else {
            sum
        }
    }

    public fun use_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| a + b;
        lambda(x, y)
    }

    public fun user_of_inline(x: u8, y: u8): u8 {
        // Re-use lambda to add two numbers then add y again
        let lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| a + b;
        let sum = lambda(x, y);
        sum + y
    }
}



//# run 0xCAFE::Adder::add_and_return --args 10u8 32u8



//# run 0xCAFE::Adder::add_and_return --args 10u8 10u8



//# run 0xCAFE::Adder::use_lambda --args 5u8 6u8



//# run 0xCAFE::Adder::user_of_inline --args 3u8 4u8




//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::Adder;

    public fun call_inline_function(val1: u8, val2: u8): u8 {
        let res = Adder::add_and_return(val1, val2);
        res
    }

    public fun lambda_caller(a: u8, b: u8): u8 {
        Adder::use_lambda(a, b)
    }

    public fun nest_calls(a: u8, b: u8): u8 {
        let first = Adder::add_and_return(a, b);
        let second = Adder::user_of_inline(first, b);
        second
    }
}



//# run 0xCAFE::InlineCaller::call_inline_function --args 20u8 22u8



//# run 0xCAFE::InlineCaller::call_inline_function --args 10u8 5u8



//# run 0xCAFE::InlineCaller::lambda_caller --args 7u8 8u8



//# run 0xCAFE::InlineCaller::nest_calls --args 3u8 5u8
