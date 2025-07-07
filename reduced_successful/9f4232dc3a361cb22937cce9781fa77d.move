
//# publish
module 0xCAFE::LambdaModule {
    const RETURN_MAGIC: u8 = 42;

    // A lambda function that adds two u8 values and returns u8
    public fun add_two(a: u8, b: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        adder(a, b)
    }

    public fun with_lambda_and_return(x: u8, y: u8): u8 {
        let f: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            let sum = a + b;
            sum
        };
        let _result = f(x, y);
        let _unused = RETURN_MAGIC; // dummy usage to check constant
        // return the constant ignoring result
        RETURN_MAGIC
    }
}



//# run 0xCAFE::LambdaModule::add_two --args 10u8 15u8



//# run 0xCAFE::LambdaModule::with_lambda_and_return --args 5u8 7u8



//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::LambdaModule;

    // Calls LambdaModule::add_two twice nestedly and returns sum
    public fun double_add(x: u8, y: u8): u8 {
        let sum1 = LambdaModule::add_two(x, y);
        let sum2 = LambdaModule::add_two(sum1, 1u8);
        sum2
    }
}



//# run 0xCAFE::NestedCalls::double_add --args 20u8 22u8



//# publish
module 0xCAFE::ReturnVariable {
    public fun return_input(x: u8): u8 {
        let temp = x + 5;
        let result = temp - 3;
        result
    }
}



//# run 0xCAFE::ReturnVariable::return_input --args 10u8



//# publish
module 0xCAFE::SpannedValue {
    struct Span has copy, drop, store {
        start: u64,
        end: u64,
    }

    struct Spanned<T> has copy, drop, store {
        value: T,
        span: Span,
    }

    public fun create_spanned_value(x: u8, start: u64, end: u64): Spanned<u8> {
        let sp = Span {start, end};
        Spanned {value: x, span: sp}
    }
}



//# run 0xCAFE::SpannedValue::create_spanned_value --args 123u8 5u64 10u64
