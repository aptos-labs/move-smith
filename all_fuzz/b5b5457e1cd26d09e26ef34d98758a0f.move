
//# publish
module 0xCAFE::AdvancedTest {
    // Removed unused import: `use std::signer;`

    // 5. Annotate with named attributes
    // test_attr]
    struct Demo has copy, drop {}

    public fun compute_addition(a: u8, b: u8): u8 {
        let sum = a + b;
        // 1. Test addition u8 before returning fixed value 42u8
        sum + 10u8
    }

    public fun test_lambda_usage(): u8 {
        // 2. Lambda expression with capture and return
        let lam: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            let res = x * y;
            res + 1u8
        };
        lam(4u8, 5u8)
    }

    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }

    public fun test_nested_inline_calls(a: u8): u8 {
        // 3. Call inline function inside another function
        let res1 = inline_increment(a);
        // Use `Self::` to refer to the same module since `use` or module qualifier fails here
        Self::inline_increment(res1)
    }

    public fun test_move_then_reassign(x: u8): u8 {
        let val = x;
        let temp = val;
        if (temp > 10) {
            val = temp - 5;
        } else {
            val = temp + 5;
        };
        val
    }

    public fun test_block_expression(): u8 {
        // 6. Group multiple expr with block
        let result = {
            let x = 20u8;
            let y = 22u8;
            x + y
        };
        result
    }
}



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AdvancedTest;

    public fun call_external_nested_inline(a: u8): u8 {
        // 3. Calls inline function from another module
        AdvancedTest::test_nested_inline_calls(a)
    }
}



//# run 0xCAFE::AdvancedTest::compute_addition --args 15u8 20u8



//# run 0xCAFE::AdvancedTest::test_lambda_usage



//# run 0xCAFE::AdvancedTest::test_nested_inline_calls --args 7u8



//# run 0xCAFE::AdvancedTest::test_move_then_reassign --args 12u8



//# run 0xCAFE::AdvancedTest::test_move_then_reassign --args 5u8



//# run 0xCAFE::AdvancedTest::test_block_expression



//# run 0xCAFE::CallerModule::call_external_nested_inline --args 8u8
