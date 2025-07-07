
//# publish
module 0xCAFE::LambdaTest {
    // Removed unused alias `std::signer`

    // 1: Add two u8 values and return the result plus a constant
    public fun add_and_offset(x: u8, y: u8): u8 {
        let sum = x + y;
        // return sum + 5
        sum + 5
    }

    // 2: Function containing lambda expressions and usage
    public fun apply_lambda(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let mul_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        let added = add_lambda(x, y);
        let multiplied = mul_lambda(x, y);
        // return added + multiplied
        added + multiplied
    }

    // 3: Inline function
    public inline fun inline_increment(a: u16): u16 {
        a + 1
    }
}



//# publish
module 0xCAFE::CallInline {
    use 0xCAFE::LambdaTest;

    // 3 continued: Call inline function from LambdaTest and use result further
    public fun nested_inline_call(a: u16): u16 {
        let inc = LambdaTest::inline_increment(a);
        inc + 2
    }
}



//# publish
module 0xCAFE::NameExpressionTest {
    // 4: Access module directly by name (no alias)
    use 0xCAFE::LambdaTest;

    public fun use_name_expression(x: u8, y: u8): u8 {
        LambdaTest::add_and_offset(x, y)
    }
}



//# publish
module 0xCAFE::MutRefLoopTest {
    // 5: Function that updates via mutable reference and uses a loop

    public fun increment_and_test(x_ref: &mut u8): bool {
        *x_ref = *x_ref + 1;
        *x_ref > 10
    }

    public fun loop_test(): u8 {
        let counter = 0u8;
        // Rewrote loop without `break <value>` which is unsupported:
        loop {
            let temp_counter = counter;
            let is_gt_10 = increment_and_test(&mut temp_counter);
            if (is_gt_10) {
                // Return counter value once condition met
                return temp_counter;
            };
            counter = counter + 1;
        }
    }
}



//# run 0xCAFE::LambdaTest::add_and_offset --args 4u8 8u8



//# run 0xCAFE::LambdaTest::apply_lambda --args 3u8 5u8



//# run 0xCAFE::CallInline::nested_inline_call --args 20u16



//# run 0xCAFE::NameExpressionTest::use_name_expression --args 7u8 2u8



//# run 0xCAFE::MutRefLoopTest::loop_test
