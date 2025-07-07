
//# publish
module 0xCAFE::Calc {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let _sum = a + b; // underscore to ignore warning
        let _fixed_value = 42u8; // just return fixed value to test
        _fixed_value
    }

    public fun lambda_example_with_capture(x: u8): u8 {
        let add_x = |y: u8| y + x;
        add_x(10)
    }

    public inline fun inline_double(x: u8): u8 {
        x * 2
    }

    public fun use_inline_double(a: u8): u8 {
        inline_double(a) + 1
    }

    public fun byte_string_example(): vector<u8> {
        b"TestASCII"
    }
}




//# run 0xCAFE::Calc::add_and_return_fixed --args 10u8 15u8




//# run 0xCAFE::Calc::lambda_example_with_capture --args 5u8




//# run 0xCAFE::Calc::use_inline_double --args 7u8




//# run 0xCAFE::Calc::byte_string_example





//# publish
module 0xCAFE::AbilitiesCheck {
    struct HasCopy has copy, drop { val: u8 }
    struct HasDrop has drop { val: u8 }
    // Added `has key` to HasStore to make it compatible with move_to
    struct HasStore has key, store { val: u8 }
    struct HasKey has key, store { val: u8 }

    public fun test_abilities(account: &signer) {
        let c = HasCopy { val: 10 };
        let _c2 = copy c;

        let d = HasDrop { val: 20 };
        // just create and drop before function exit

        let s = HasStore { val: 30 };
        move_to(account, s);

        let k = HasKey { val: 40 };
        move_to(account, k);

        // Exit state test: abort if val in HasCopy is not 10
        assert!(c.val == 10, 1001);
    }
}




//# run 0xCAFE::AbilitiesCheck::test_abilities --signers 0xBEEF





//# publish
module 0xCAFE::UnitTest {
    use std::vector;

    public fun runner_add_and_return_fixed(): u8 {
        0xCAFE::Calc::add_and_return_fixed(1u8, 2u8)
    }

    public fun runner_lambda_example(): u8 {
        0xCAFE::Calc::lambda_example_with_capture(3u8)
    }

    public fun runner_inline_call(): u8 {
        0xCAFE::Calc::use_inline_double(20u8)
    }

    public fun runner_byte_string_len(): u64 {
        let b = 0xCAFE::Calc::byte_string_example();
        vector::length(&b) as u64
    }
}




//# run 0xCAFE::UnitTest::runner_add_and_return_fixed




//# run 0xCAFE::UnitTest::runner_lambda_example




//# run 0xCAFE::UnitTest::runner_inline_call




//# run 0xCAFE::UnitTest::runner_byte_string_len
