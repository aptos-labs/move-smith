
//# publish
module 0xCAFE::Adder {
    public fun add_two_values(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_add_and_return_special(a: u8, b: u8): u8 {
        let sum = add_two_values(a, b);
        if (sum == 10) {
            42
        } else {
            sum
        }
        // Return the value explicitly
    }

    public fun with_lambda(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }
}



//# run 0xCAFE::Adder::add_two_values --args 4u8 6u8



//# run 0xCAFE::Adder::call_add_and_return_special --args 4u8 6u8



//# run 0xCAFE::Adder::call_add_and_return_special --args 2u8 3u8



//# run 0xCAFE::Adder::with_lambda --args 7u8 8u8


// Fix ordering: publish Adder before NestedCaller


//# publish
module 0xCAFE::NestedCaller {
    use 0xCAFE::Adder;

    public fun call_inline_and_lambda(a: u8, b: u8): u8 {
        let inline_result = inline_call(a);
        let lambda_result = Adder::with_lambda(a, b);
        inline_result + lambda_result
    }

    public inline fun inline_call(x: u8): u8 {
        // Calls an inline function from the Adder module and then doubles the result
        let _ = Adder::add_two_values(x, 1u8);
        x * 2
    }
}



//# run 0xCAFE::NestedCaller::call_inline_and_lambda --args 5u8 10u8
