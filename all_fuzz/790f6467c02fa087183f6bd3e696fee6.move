
//# publish
module 0xCAFE::TestAddition {
    /// Adds two u8 values and then adds 10u8 to the result, returns the total.
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        // Add 10 to sum and return
        sum + 10u8
    }

    /// Function that contains lambda expressions and returns the results in a tuple (v1, v2).
    public fun lambdas_example(x: u8, y: u8): (u8, u8) {
        let add_lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| { a + b };
        let mul_lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| { a * b };

        let v1 = add_lambda(x, y);
        let v2 = mul_lambda(x, y);
        (v1, v2)
    }
}



//# publish
module 0xCAFE::InlineAndControlFlow {
    use 0xCAFE::TestAddition;

    public inline fun inner_increment(x: u8): u8 {
        x + 1u8
    }

    public fun call_nested_functions(a: u8, b: u8): u8 {
        let sum = TestAddition::add_and_offset(a, b);
        let incremented = inner_increment(sum);

        if (incremented > 20u8) {
            let val = incremented;
            while (val > 15u8) {
                val = val - 1u8;
            };
            loop {
                if (val == 15u8) {
                    break;
                };
                val = val + 1u8;
            };
            val
        } else {
            0u8
        }
    }

    public fun macro_and_assert_example(x: u8) {
        let sum = x + 2u8;
        assert!(sum > x, 100);

        // Fixed: removed `let _ = ();` which is invalid because `()` is a disallowed tuple type here.
        // You can simply use blocks without assignments when you want an empty statement branch.

        if (sum > 5u8) {
            // do nothing; keep block empty or use `{}`
        } else {
            // do nothing; keep block empty or use `{}`
        };
    }
}



//# run 0xCAFE::TestAddition::add_and_offset --args 5u8 7u8



//# run 0xCAFE::TestAddition::lambdas_example --args 3u8 4u8



//# run 0xCAFE::InlineAndControlFlow::call_nested_functions --args 5u8 8u8



//# run 0xCAFE::InlineAndControlFlow::macro_and_assert_example --args 4u8
