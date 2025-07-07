
//# publish
module 0xCAFE::LambdaTest {
    use std::vector;

    // Simple struct to use for resource test
    struct CalcResult has copy, drop, store, key {
        sum: u8,
        final_value: u8,
    }

    // Function that adds two u8 values then returns a fixed u8
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let result = a + b;
        // unit expression for side effect (unused vector creation)
        (vector[1u8, 2u8]: vector<u8>);
        42u8
    }

    // Function with lambda expression returning sum and product
    public fun use_lambda(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let sum = x + y;
            let product = x * y;
            (sum, product)
        };
        lambda(a, b)
    }

    // Store CalcResult resource at signer address
    public fun store_calc_result(s: signer, sum: u8, final_value: u8) {
        let r = CalcResult { sum, final_value };
        move_to<CalcResult>(&s, r);
    }

    // Read CalcResult resource fields for a given address
    public fun read_calc_result(addr: address): (u8, u8) acquires CalcResult {
        let r = borrow_global<CalcResult>(addr);
        (r.sum, r.final_value)
    }
}


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaTest;

    public fun call_inline_function(a: u8, b: u8): u8 {
        // Call module 0xCAFE::LambdaTest's add_and_return_fixed
        let fixed = LambdaTest::add_and_return_fixed(a, b);
        fixed
    }

    public fun nested_lambda_call(a: u8, b: u8): (u8, u8) {
        // Call LambdaTest's use_lambda to test nested call with lambda
        LambdaTest::use_lambda(a, b)
    }
}


//# run 0xCAFE::LambdaTest::add_and_return_fixed --args 10u8 20u8


//# run 0xCAFE::LambdaTest::use_lambda --args 3u8 4u8


//# run 0xCAFE::InlineCaller::call_inline_function --args 5u8 7u8


//# run 0xCAFE::InlineCaller::nested_lambda_call --args 5u8 7u8


//# run 0xCAFE::LambdaTest::store_calc_result --signers 0xBABE --args 12u8 42u8


//# run 0xCAFE::LambdaTest::read_calc_result --args 0xBABE


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 64d7361646fc89108c2c632e2bc5ac2f: Assign to unit expressions for side effects without value.
// 8b23f2f668261c191767ca4ad4879589: Specify access paths that start with an address followed by a module name and a resource name.
// c838b462f314f5cdf6238506a518c872: Ensure that the code does not use restricted names by checking against a set of forbidden names.
