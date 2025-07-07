//# publish
module 0xA1B2::LambdaTest {
    // Compose an inline lambda that multiplies its argument by 2 and returns the result
    public fun double_fn(f: |u64| u64, x: u64): u64 {
        f(x)
    }

    // Runner function to test the lambda application
    public fun test_double(): u64 {
        // lambda doubles the input
        let result = double_fn(|n| n * 2, 7);
        result
    }
    
    // Function to explicitly check the correctness
    public fun main() {
        // Assert that applying lambda to 7 results in 14
        assert!(test_double() == 14, 6);
    }
}

//# run 0xA1B2::LambdaTest::main


//# publish
module 0xA1B2::NestedScopeEnum {
    // Enum with multiple variants to test scoping and pattern matching
    enum ResultType has drop {
        Success(u64),
        Error { code: u64, message: vector<u8> },
        Pending,
    }

    // Helper function to produce nested scopes and match enum variants
    public fun evaluate_result(res: &ResultType): u64 {
        let value = 0;

        // First inner block with its own variable
        {
            let value = 100; // shadowing outer variable
            match (res) {
                Success(v) => *v,
                Error { code: _, message: _ } => {
                    // nested inner scope
                    {
                        // determine if message contains 'fail' pattern
                        if (vector::length(&res.message()) > 0 && vector::index(&res.message(), 0) == 102 /* 'f' */) {
                            999
                        } else {
                            value
                        }
                    }
                },
                Pending => {
                    // inner block
                    {
                        // Access outer 'value', ensure shadowing is correct
                        value + 1
                    }
                },
            }
        }
    }

    // Runner to check correct pattern matching and scoping
    public fun run_tests(): u64 {
        let success_res = ResultType::Success(42);
        let error_res_with_fail_message = ResultType::Error { code: 1, message: b"fail" };
        let error_res_without_fail_message = ResultType::Error { code: 2, message: b"ok" };
        let pending_res = ResultType::Pending;

        let res1 = evaluate_result(&success_res); // should return 42
        let res2 = evaluate_result(&error_res_with_fail_message); // should return 999
        let res3 = evaluate_result(&error_res_without_fail_message); // should return 100 (from shadowed 'value')
        let res4 = evaluate_result(&pending_res); // should return 101 (shadowed value + 1)

        // Compose a unique combination for validation (but assertions are ignored)
        // Return sum as a simple check
        res1 + res2 + res3 + res4
    }
}

//# run 0xA1B2::NestedScopeEnum::run_tests