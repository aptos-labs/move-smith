
//# publish
module 0xCAFE::AddModule {
    // Test that a Move function correctly computes addition of u8 values before returning a value.

    // prefix sum with _ to silence unused warning
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let _sum = a + b;
        // Ignores sum and returns fixed value 42u8
        42u8
    }

    public fun lambda_test(): u8 {
        let f: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        f(5u8, 7u8)
    }

    public fun lambda_capture_test(): u8 {
        let captured = 10u8;
        let f: |u8| u8 has copy + drop = |x: u8| {
            x + captured
        };
        f(15u8)
    }

    public inline fun inline_sum(a: u8, b: u8): u8 {
        a + b
    }
}



//# publish
module 0xCAFE::CallInlineModule {
    use 0xCAFE::AddModule;

    // Test calling an inline function from another module performing nested calls.
    public fun call_inline_and_add(x: u8, y: u8): u8 {
        let s = AddModule::inline_sum(x, y);
        AddModule::inline_sum(s, 1u8)
    }
}



//# publish
module 0xCAFE::VectorCopyMove {
    use std::vector;

    struct Data has store {
        value: u8
    }

    public fun test_vector_copy_and_move(): u8 {
        let v1 = vector::empty<u8>();
        vector::push_back(&mut v1, 10u8);
        // Copy v1 to v2
        let v2 = copy v1;
        vector::push_back(&mut v2, 20u8);
        let v3 = move v1;
        let val_ref = vector::borrow(&v3, 0);
        *val_ref
    }
}



//# publish
module 0xCAFE::LintTest {
    // This function body should be checked by lint passes for code quality or correctness
    public fun lint_checks(x: u8): u8 {
        let y = if (x > 10) { x } else { 10u8 };
        // Unused let binding to test lint
        let _unused = 42u8;

        // Loop for lint test
        let sum = 0u8;
        let i = 0u8;
        while (i < y) {
            sum = sum + i;
            i = i + 1;
        };
        sum
    }
}



//# publish
module 0xCAFE::QuantifierMinChoice {
    // Simulate 'choose min' quantifier by manually iterating and selecting minimal value satisfying condition.

    public fun choose_min(max: u8): u8 {
        let candidate = max;
        let current = 0u8;
        while (current <= max) {
            if ((current * current) >= 16u8) {
                if (current < candidate) {
                    candidate = current;
                };
            };
            current = current + 1u8;
        };
        candidate
    }
}



//# run 0xCAFE::AddModule::add_and_return_fixed --args 10u8 20u8



//# run 0xCAFE::AddModule::lambda_test



//# run 0xCAFE::AddModule::lambda_capture_test



//# run 0xCAFE::CallInlineModule::call_inline_and_add --args 1u8 2u8



//# run 0xCAFE::VectorCopyMove::test_vector_copy_and_move



//# run 0xCAFE::LintTest::lint_checks --args 20u8



//# run 0xCAFE::QuantifierMinChoice::choose_min --args 10u8
