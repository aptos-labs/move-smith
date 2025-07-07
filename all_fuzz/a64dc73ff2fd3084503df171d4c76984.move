
//# publish
module 0xCAFE::AddAndLambda {
    use std::signer;

    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;

        // if sum equals 10 return 42 else return sum
        if (sum == 10) {
            42
        } else {
            sum
        }
    }

    public fun lambda_example(a: u8, b: u8): (u8, u8) {
        let add: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let res = x + y;
            let double_res = res * 2;
            (res, double_res)
        };
        add(a, b)
    }

    // This function consumes a signer and returns a constant for uniqueness
    public fun dummy_runner(_s: signer): u8 {
        1u8
    }
}


//# run 0xCAFE::AddAndLambda::add_two_values --args 4u8 6u8


//# run 0xCAFE::AddAndLambda::add_two_values --args 2u8 3u8


//# run 0xCAFE::AddAndLambda::lambda_example --args 3u8 4u8



//# publish
module 0xCAFE::InlineAndCalls {
    use 0xCAFE::AddAndLambda;

    public inline fun inline_increment(a: u8): u8 {
        a + 1
    }

    public fun nested_call(a: u8, b: u8): u8 {
        let (sum, doubled) = AddAndLambda::lambda_example(a, b);
        let incremented = inline_increment(doubled);
        sum + incremented
    }

    public fun runner(): u8 {
        nested_call(3u8, 2u8)
    }
}


//# run 0xCAFE::InlineAndCalls::nested_call --args 5u8 5u8


//# run 0xCAFE::InlineAndCalls::runner



//# publish
module 0xCAFE::AddressComparison {
    use std::signer;

    public fun compare_address_literals(): bool {
        // 0xDEADBEEF and 0x00DEADBEEF decimal literal should be equal addresses
        let addr_hex = @0xDEADBEEF;
        let addr_dec = @3735928559; // decimal form of 0xDEADBEEF

        addr_hex == addr_dec
    }

    public fun runner(_s: signer): bool {
        compare_address_literals()
    }
}


//# run 0xCAFE::AddressComparison::compare_address_literals


//# run 0xCAFE::AddressComparison::runner --signers 0xBEEF



//# publish
module 0xCAFE::FunctionsTuplesClosures {
    use std::vector;

    public inline fun pairify(a: u8, b: u8): (u8, u8) {
        (a, b)
    }

    public fun call_with_closure(a: u8, b: u8): u8 {
        let closure: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };

        closure(a, b)
    }

    public fun assign_and_return_tuple(): (u8, u8) {
        let (x, y) = pairify(7u8, 8u8);
        (x, y)
    }

    public fun runner(): u8 {
        let product = call_with_closure(4u8, 5u8);
        product
    }
}


//# run 0xCAFE::FunctionsTuplesClosures::pairify --args 10u8 20u8


//# run 0xCAFE::FunctionsTuplesClosures::call_with_closure --args 3u8 7u8


//# run 0xCAFE::FunctionsTuplesClosures::assign_and_return_tuple


//# run 0xCAFE::FunctionsTuplesClosures::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// d6737f4684fc194ee60b487b2ee0ce39: Test that hexadecimal and decimal address literals with equivalent values are considered equal in address comparisons.
// f1d96b651080ac0705569fa50013eef4: Test the correct functioning of function calls, inline functions, and closures, including handling of parameters, tuples, and variable assignment.
