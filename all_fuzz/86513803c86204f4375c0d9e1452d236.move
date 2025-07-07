
//# publish
module 0xCAFE::Addition {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        let result = sum + 10u8;
        result
    }

    public fun call_lambda(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }
}



//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Addition;

    public fun call_add_and_lambda(a: u8, b: u8): (u8, u8) {
        let add_result = Addition::add_two_values(a, b);
        let lambda_result = Addition::call_lambda(a, b);
        (add_result, lambda_result)
    }

    public fun runner(): (u8, u8) {
        call_add_and_lambda(5u8, 7u8)
    }
}



//# run 0xCAFE::Addition::add_two_values --args 3u8 4u8



//# run 0xCAFE::Addition::call_lambda --args 8u8 5u8



//# run 0xCAFE::Caller::call_add_and_lambda --args 1u8 2u8



//# run 0xCAFE::Caller::runner
