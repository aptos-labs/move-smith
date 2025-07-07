//# publish
module 0xCAFE::UintComparison {
    public fun test_comparisons_u8(a: u8, b: u8): (bool, bool, bool, bool, bool, bool) {
        (a == b, a != b, a < b, a > b, a <= b, a >= b)
    }

    public fun test_comparisons_u16(a: u16, b: u16): (bool, bool, bool, bool, bool, bool) {
        (a == b, a != b, a < b, a > b, a <= b, a >= b)
    }

    public fun test_comparisons_u32(a: u32, b: u32): (bool, bool, bool, bool, bool, bool) {
        (a == b, a != b, a < b, a > b, a <= b, a >= b)
    }

    public fun test_comparisons_u64(a: u64, b: u64): (bool, bool, bool, bool, bool, bool) {
        (a == b, a != b, a < b, a > b, a <= b, a >= b)
    }

    public fun test_comparisons_u128(a: u128, b: u128): (bool, bool, bool, bool, bool, bool) {
        (a == b, a != b, a < b, a > b, a <= b, a >= b)
    }

    public fun test_break_label_name(x: u8): u8 {
        let mut val = 0u8;
        'outer: loop {
            val = val + 1;
            'inner: loop {
                if (val >= x) {
                    break 'outer;
                };
                break 'inner;
            };
            val = val + 10;
        };
        val
    }
}

//# run 0xCAFE::UintComparison::test_comparisons_u8 --args 10u8 20u8

//# run 0xCAFE::UintComparison::test_comparisons_u16 --args 30u16 15u16

//# run 0xCAFE::UintComparison::test_comparisons_u32 --args 100u32 100u32

//# run 0xCAFE::UintComparison::test_comparisons_u64 --args 50u64 51u64

//# run 0xCAFE::UintComparison::test_comparisons_u128 --args 123456789u128 987654321u128

//# run 0xCAFE::UintComparison::test_break_label_name --args 5u8

//# publish
module 0xCAFE::DeprecatedModule {
    // This module is deprecated and ONLY serves to trigger diagnostics

    public fun some_function(): u8 {
        42u8
    }
}

//# run 0xCAFE::DeprecatedModule::some_function

//# run 0xCAFE::UintComparison::test_break_label_name --args 3u8

// Featurres:
// 4df524fc407cce428fdfef92c0a4923e: Test that unsigned integer types support comparison operators (==, !=, <, >, <=, >=) correctly across various bitwidths.
// cc34729450c4cd057130f86dfbdd72b3: Be warned when using deprecated modules via diagnostic messages
// 1a7a52c3626ed29ee0b31738d0130103: Use 'break' with optional labels.
