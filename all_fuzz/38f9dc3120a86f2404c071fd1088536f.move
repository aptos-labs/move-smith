
//# publish
module 0xCAFE::ArithAdd {
    // Test a function computing addition of two u8 values, returning fixed value 77u8 after verifying sum.

    public fun add_then_fixed_return(x: u8, y: u8): u8 {
        let _sum = x + y;
        // No overflow check here to keep simple; u8 addition wraps around
        let _expected: u8 = 77u8;
        _expected
    }

    // Test lambda function computing sum and product inside
    public fun use_lambda_sum_product(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy + drop = |x: u8, y: u8| {
            (x + y, x * y)
        };
        lambda(a, b)
    }
}



//# run 0xCAFE::ArithAdd::add_then_fixed_return --args 42u8 35u8



//# run 0xCAFE::ArithAdd::use_lambda_sum_product --args 5u8 8u8




//# publish
module 0xCAFE::FuncInlineCaller {
    use 0xCAFE::ArithAdd;

    public inline fun inline_increment_u16(x: u16): u16 {
        x + 1
    }

    // Call inline function in this module from another module with extra call in between
    public fun run_nested_calls(x: u16): u8 {
        let (a, b) = (inline_increment_u16(x), inline_increment_u16(x + 1u16));
        let add_result = ArithAdd::add_then_fixed_return(a as u8, b as u8);
        add_result
    }
}



//# run 0xCAFE::FuncInlineCaller::run_nested_calls --args 100u16




//# publish
module 0xCAFE::ShiftTester {
    // Test left shift (<<) and right shift (>>) for all unsigned integer types
    // including edge cases like zero shift, shift equal to width, above width.

    public fun shift_u8(x: u8, shift: u8): u8 {
        let bits = 8u8;
        let actual_shift = if (shift >= bits) { bits - 1u8 } else { shift };
        // Left shift
        let left = x << actual_shift;
        // Right shift
        let right = x >> actual_shift;
        left + right
    }

    public fun shift_u16(x: u16, shift: u8): u16 {
        let bits = 16u8;
        let actual_shift = if (shift >= bits) { bits - 1u8 } else { shift };
        let left = x << actual_shift;
        let right = x >> actual_shift;
        left + right
    }

    public fun shift_u32(x: u32, shift: u8): u32 {
        let bits = 32u8;
        let actual_shift = if (shift >= bits) { bits - 1u8 } else { shift };
        let left = x << actual_shift;
        let right = x >> actual_shift;
        left + right
    }

    public fun shift_u64(x: u64, shift: u8): u64 {
        let bits = 64u8;
        let actual_shift = if (shift >= bits) { bits - 1u8 } else { shift };
        let left = x << actual_shift;
        let right = x >> actual_shift;
        left + right
    }

    public fun shift_u128(x: u128, shift: u8): u128 {
        let bits = 128u8;
        let actual_shift = if (shift >= bits) { bits - 1u8 } else { shift };
        let left = x << actual_shift;
        let right = x >> actual_shift;
        left + right
    }

    // Random spot check
    public fun shift_checks(): bool {
        // 1 << 0 plus 1 >> 0 == 2
        let a = shift_u8(1u8, 0u8);
        // 1 << 7 plus 1 >> 7 == 128 + 0 == 128 > 0
        let b = shift_u8(1u8, 8u8);
        // upper-bound test with large value
        let c = shift_u128(0x1u128, 127u8);
        a == 2u8 && b > 0u8 && c > 0u128
    }
}



//# run 0xCAFE::ShiftTester::shift_u8 --args 1u8 0u8



//# run 0xCAFE::ShiftTester::shift_u8 --args 1u8 8u8



//# run 0xCAFE::ShiftTester::shift_u16 --args 65535u16 16u8



//# run 0xCAFE::ShiftTester::shift_u32 --args 1234567u32 32u8



//# run 0xCAFE::ShiftTester::shift_u64 --args 123456789u64 64u8



//# run 0xCAFE::ShiftTester::shift_u128 --args 123456789u128 128u8



//# run 0xCAFE::ShiftTester::shift_checks
