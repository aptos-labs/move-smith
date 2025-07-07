
//# publish
module 0xCAFE::PatternTest {
    use std::signer;
    use std::vector;

    struct Point has copy, drop, store {
        x: u64,
        y: u64,
    }

    enum ResultType has copy, drop {
        Ok(u64),
        Err { code: u64, message: vector<u8> },
        Pending,
    }

    // This function demonstrates tuple destructuring with () syntax
    public fun tuple_destructure_example(): (u64, u64) {
        let t = (7u64, 8u64);
        let (a, b) = t;
        (a, b)
    }

    // Pattern match in an enum binding variables directly
    public fun enum_pattern_match_example(r: ResultType): u64 {
        let res = match(r) {
            ResultType::Ok(v) => v,
            ResultType::Err { code, message } => code,
            ResultType::Pending => 0,
        };
        res
    }

    // Attempt to use an uninitialized variable deliberately to check detection
    // The local variable 'uninit' is declared but not assigned before use
    public fun uninitialized_variable_example(): u64 {
        let uninit: u64;
        // The following line attempts to use uninit which is not initialized
        // This is to test detection in the Move compiler / VM
        // In real Move code, this will cause abort or compile-error
        let x = uninit + 1;
        x
    }

    // Another example of pattern matching with nested destructure
    public fun complex_pattern_example(): u64 {
        let r = ResultType::Err {
            code: 123,
            message: b"error occurred"
        };
        let code_val = match(r) {
            ResultType::Err { code, message: _ } => code,
            _ => 0,
        };
        code_val
    }
}



//# run 0xCAFE::PatternTest::tuple_destructure_example


//# run 0xCAFE::PatternTest::enum_pattern_match_example --args '{"Ok":555}'


//# run 0xCAFE::PatternTest::enum_pattern_match_example --args '{"Err":{"code":999,"message":"fail"}}'


//# run 0xCAFE::PatternTest::uninitialized_variable_example


//# run 0xCAFE::PatternTest::complex_pattern_example


// Features:
// e6c7320f0c2d4295e7b8ee35138b4cb8: Bind variables to tuple destructuring patterns using `()` syntax (in Move 2 mode)
// b12c4b597314be2d929c4915dc02b906: Bind variables directly in patterns using standard pattern matching syntax
// 16354f10c8707da213df106eeddfd58a: Detect and annotate uninitialized variable uses in your Move code.
