
//# publish
module 0xCAFE::AdvancedTest {
    // Removed invalid use of 0xCAFE::MyModule

    // skip(only_public_functions)]
    const TEST_CONSTANT: u64 = 0x12345678;

    // Function that adds two u8 and returns 100u8 if sum > 10 else returns sum
    public fun add_and_check(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            100u8
        } else {
            sum
        }
    }

    // Using lambda to multiply two u8 and add a constant
    public fun lambda_calc(a: u8, b: u8): u8 {
        // Safely cast TEST_CONSTANT to u8 by taking modulo 256 to avoid overflow
        let const_u8 = (TEST_CONSTANT % 256) as u8;
        let multiplier: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            (x * y) + const_u8
        };
        multiplier(a, b)
    }

    // Dummy inline functions to replace missing MyModule::f1 and MyModule::f2
    // These must be defined in this module as MyModule is not available.

    // inline]
    public fun f1(x: u8, y: bool): u8 {
        // example behavior: if y is true, return x + 1, else x - 1 or 0 if underflow
        if (y) {
            // safe add with checked_add or manual check (no intrinsic checked_add in Move, so manual check)
            // x + 1 can't overflow u8 max (255), but let's be safe:
            if (x == 0xFF) { 0xFF } else { x + 1 }
        } else if (x > 0) {
            x - 1
        } else {
            0
        }
    }

    // inline]
    public fun f2(z: u16): (u8, u8) {
        // example: split z into two u8s: higher and lower byte
        (
            (z >> 8) as u8,
            (z & 0xFF) as u8
        )
    }


    // Inline function calls to replaced MyModule functions to test nested calls
    public fun nested_calls(input: u8): u8 {
        // call local f1 inside nested call with y true
        let f1_result = f1(input, true);
        // call inline f2 from local with u16 argument, sum the tuple elements and cast to u8
        let (a, b) = f2(f1_result as u16);
        // safely add a and b with no arithmetic overflow (max is 255 + 255 = 510 which overflows u8)
        // We'll cap sum at 255 if overflow would occur
        let sum = (a as u16) + (b as u16);
        if (sum > 0xFF) {
            0xFF
        } else {
            sum as u8
        }
    }

    // Public runner function without arguments to test lambdas and nested call
    public fun runner() {
        let _ = add_and_check(5u8, 4u8);
        let _ = lambda_calc(3u8, 7u8);
        let _ = nested_calls(5u8);
    }
}



//# run 0xCAFE::AdvancedTest::add_and_check --args 7u8 6u8



//# run 0xCAFE::AdvancedTest::lambda_calc --args 4u8 8u8



//# run 0xCAFE::AdvancedTest::nested_calls --args 7u8



//# run 0xCAFE::AdvancedTest::runner
