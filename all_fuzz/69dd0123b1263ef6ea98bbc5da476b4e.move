
//# publish
module 0xCAFE::LambdaAbortTest {
    // Removed unused import 'std::signer'.

    // Simple function that adds two u8 and returns x + y + 1
    public fun add_and_increment(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 1
    }

    // Function with a lambda that multiplies then adds one: (a * b) + 1
    public fun lambda_multiply_and_increment(a: u8, b: u8): u8 {
        let multiply_increment: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            (x * y) + 1
        };
        multiply_increment(a, b)
    }

    // Function demonstrating nested lambdas and usage of copy abilities
    public fun nested_lambda(x: u8, y: u8): (u8, u8) {
        let add: |u8, u8| u8 has copy+drop = |a: u8, b: u8| { a + b };
        let sub: |u8, u8| u8 has copy+drop = |a: u8, b: u8| { 
            // Guarantee a > b for subtraction (demo usage)
            if (a > b) { a - b } else { 0 }
        };
        let sum = add(x, y);
        let diff = sub(x, y);
        (sum, diff)
    }

    // Function that aborts explicitly if input equals 42 with abort code 9999
    spec add_and_check_abort {
        aborts_with 9999;
    }
    public fun add_and_check_abort(x: u8): u8 {
        if (x == 42) {
            abort 9999;
        };
        x + 1
    }

    // Function that calls a lambda which itself aborts if value less than 50 with abort code 1234
    spec lambda_abort {
        aborts_with 1234;
    }
    public fun lambda_abort(x: u8): u8 {
        let aborting_lambda: |u8| u8 has copy+drop = |val: u8| {
            if (val < 50) {
                abort 1234;
            };
            val + 1
        };
        aborting_lambda(x)
    }

    // Runner function to exercise all above functions without arguments 
    public fun runner() {
        let _ = add_and_increment(10u8, 20u8);
        let _ = lambda_multiply_and_increment(4u8, 5u8);
        let (_a, _b) = nested_lambda(25u8, 10u8);
        // Call with value not aborting
        let _ = add_and_check_abort(10u8);
        // Call with value >= 50, should not abort
        let _ = lambda_abort(50u8);
    }
}



//# run 0xCAFE::LambdaAbortTest::add_and_increment --args 10u8 32u8



//# run 0xCAFE::LambdaAbortTest::lambda_multiply_and_increment --args 3u8 7u8



//# run 0xCAFE::LambdaAbortTest::nested_lambda --args 40u8 35u8



//# run 0xCAFE::LambdaAbortTest::add_and_check_abort --args 10u8



//# run 0xCAFE::LambdaAbortTest::lambda_abort --args 60u8



//# run 0xCAFE::LambdaAbortTest::runner
