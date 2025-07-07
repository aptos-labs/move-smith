//# publish
module 0xCAFE::PatternAndPowTest {
    use std::vector;

    struct Data has copy, drop {
        a: u8,
        b: u16,
        c: bool,
    }

    enum OptionU8 has copy, drop {
        Some(u8),
        None,
    }

    // Unpack struct with wildcard pattern in tuple destructuring
    public fun unpack_data_wildcard(data: Data): u8 {
        let Data { a, b: _, c: _ } = data;
        a
    }

    // Match enum with wildcard pattern to catch all else
    public fun match_option(opt: OptionU8): u8 {
        match (opt) {
            OptionU8::Some(x) => x,
            _ => 0,
        }
    }

    // Calculate integer power for u64 correctly, including exponent zero
    public fun pow(base: u64, exp: u64): u64 {
        if (exp == 0) {
            1u64
        } else {
            let mut result = 1u64;
            let mut b = base;
            let mut e = exp;

            while (e > 0) {
                if ((e & 1) == 1) {
                    result = result * b;
                };
                b = b * b;
                e = e >> 1;
            };
            result
        }
    }

    // A runner function that tests pow function with various inputs
    public fun run_pow_tests(): (u64, u64, u64, u64, u64) {
        let res1 = pow(2u64, 10u64); // 1024
        let res2 = pow(5u64, 0u64);  // 1
        let res3 = pow(3u64, 3u64);  // 27
        let res4 = pow(10u64, 1u64); // 10
        let res5 = pow(7u64, 2u64);  // 49
        (res1, res2, res3, res4, res5)
    }

    // Use language item: use a feature requiring language version 1.3+ (assume 'jump' expression)
    public fun use_jump_and_label(): u8 {
        let mut a = 0u8;
        label_0:
        if (a >= 3) {
            a
        } else {
            a = a + 1;
            jump label_0;
        }
    }
}

//# run 0xCAFE::PatternAndPowTest::unpack_data_wildcard --args 5u8 10u16 true

//# run 0xCAFE::PatternAndPowTest::match_option --args 8u8

//# run 0xCAFE::PatternAndPowTest::pow --args 2u64 5u64

//# run 0xCAFE::PatternAndPowTest::run_pow_tests

//# run 0xCAFE::PatternAndPowTest::use_jump_and_label

// Featurres:
// e722edc0fc481db3207c966e6c9a7628: Use wildcard pattern ('*') where allowed, for example in pattern matching or unpacking.
// 04f836fd50e997632fb88c1adfcf4750: Test that the pow function correctly computes integer powers for various base and exponent pairs, including the zero exponent case.
// 1b6e69660f14edaa90ec85de5c9a4c02: Use language items that require a minimum specified language version in your Move code.
