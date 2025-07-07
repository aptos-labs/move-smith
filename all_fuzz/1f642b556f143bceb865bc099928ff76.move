
//# publish
module 0xCAFE::LambdaTest {
    // Removed unused 'use std::signer;'

    // A function that adds two u8 and returns sum + 5 to test computation
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        // add offset 5 to sum
        sum + 5
    }

    // A function that accepts a function pointer and arguments and returns the function result
    public fun apply_lambda(x: u8, y: u8, lam: fn(u8, u8): u8): u8 {
        lam(x, y)
    }

    // A runner function that applies a lambda function created inline
    public fun runner_with_lambda(): u8 {
        // Define a named function matching the signature
        fun lam(a: u8, b: u8): u8 {
            let sum = a + b;
            sum * 2
        }
        apply_lambda(3u8, 4u8, lam)
    }
}



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaTest;

    // Call the inline add_and_offset function from LambdaTest module
    public fun call_add_and_offset(a: u8, b: u8): u8 {
        LambdaTest::add_and_offset(a, b)
    }

    // Call the runner_with_lambda from LambdaTest to validate nested call with lambda usage
    public fun call_runner_with_lambda(): u8 {
        LambdaTest::runner_with_lambda()
    }
}



//# run 0xCAFE::LambdaTest::add_and_offset --args 10u8 20u8


//# run 0xCAFE::LambdaTest::apply_lambda --args 5u8 6u8 --type-args u8,u8,u8 --signers 0xBEEF --function-lam LambdaTest::add_and_offset


//# run 0xCAFE::LambdaTest::runner_with_lambda


//# run 0xCAFE::InlineCaller::call_add_and_offset --args 7u8 8u8


//# run 0xCAFE::InlineCaller::call_runner_with_lambda
