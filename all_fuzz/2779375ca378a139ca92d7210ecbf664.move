
//# publish
module 0xCAFE::TestAddition {
    use std::vector;

    struct SumResult has copy, drop, store {
        sum: u8,
        flag: bool,
    }

    // Simple addition returning sum + 10 as u8
    public fun add_and_offset(a: u8, b: u8): u8 {
        let total = a + b;
        let offset_sum = total + 10u8;
        offset_sum
    }

    // Lambda that doubles a u8 and adds 5
    public fun lambda_double_add(x: u8): u8 {
        let double_and_add: |u8|u8 has copy+drop = |n: u8| {
            (n * 2) + 5
        };
        double_and_add(x)
    }

    // Inline function returning (u8, bool)
    public inline fun inline_compute(x: u8): (u8, bool) {
        (x + 1, x % 2 == 0)
    }

    // Calls inline_compute from this module and wraps the result in SumResult struct
    public fun nested_inline_call(x: u8): SumResult {
        let (res, flag) = inline_compute(x);
        SumResult { sum: res, flag }
    }

    // Using various punctuation and grouping forms
    public fun complex_expr(): u8 {
        let arr = vector[1u8, 2u8, 3u8];
        let sum = 0u8;
        // Iterate from 0 to length - 1 explicitly
        let len = vector::length(&arr);
        let i = 0u64;
        while (i < len) {
            let v = *vector::borrow(&arr, i);
            let temp = (v * 3) + 5;
            sum = sum + temp;
            i = i + 1;
        };
        sum
    }

    enum State has copy, drop {
        On,
        Off(u8),
        Unknown { code: u8 }
    }

    struct Point has copy, drop, store {
        x: u8,
        y: u8,
    }

    // Testing local variables usage
    public fun local_vars_example(a: u8): u8 {
        let x = a + 5;
        let y = x * 2;
        let z = y - 3;
        z
    }
}



//# run 0xCAFE::TestAddition::add_and_offset --args 15u8 10u8



//# run 0xCAFE::TestAddition::lambda_double_add --args 7u8



//# run 0xCAFE::TestAddition::nested_inline_call --args 8u8



//# run 0xCAFE::TestAddition::complex_expr



//# run 0xCAFE::TestAddition::local_vars_example --args 3u8



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::TestAddition;

    // Call into TestAddition's inline_compute via nested function call
    public fun call_nested(x: u8): u8 {
        let (r, flag) = TestAddition::inline_compute(x);
        if (flag) {
            r * 2
        } else {
            r + 10
        }
    }

    // Call lambda_double_add from TestAddition and add 1
    public fun call_lambda(x: u8): u8 {
        let val = TestAddition::lambda_double_add(x);
        val + 1
    }
}



//# run 0xCAFE::CallerModule::call_nested --args 20u8



//# run 0xCAFE::CallerModule::call_lambda --args 4u8
