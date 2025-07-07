
//# publish
module 0xCAFE::MyModule {
    public fun f2(x: u16): (u16, u16) {
        (x, x + 1)
    }
}

//# publish
module 0xCAFE::AddAndLambda {
    // Removed unused 'use std::signer;'

    public fun add_u8_and_check_sum(a: u8, b: u8): u8 {
        let sum = a + b;

        let check = if (sum > 10) {
            42u8
        } else {
            24u8
        };

        // Just return check, sum can be verified in test by observing check value outcome
        check
    }

    public fun lambda_example(x: u8, y: u8): u8 {
        let f: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        f(x, y)
    }

    public fun inline_and_nested_calls(x: u16): u32 {
        // call inline f2 in MyModule to get tuple (u16, u16), then add both elements and cast.
        let (a, b) = 0xCAFE::MyModule::f2(x);
        let result = (a + b) as u32;
        result
    }
}



//# run 0xCAFE::AddAndLambda::add_u8_and_check_sum --args 5u8 6u8



//# run 0xCAFE::AddAndLambda::add_u8_and_check_sum --args 1u8 2u8



//# run 0xCAFE::AddAndLambda::lambda_example --args 3u8 4u8



//# run 0xCAFE::AddAndLambda::inline_and_nested_calls --args 10u16
