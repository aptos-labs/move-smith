
//# publish
module 0xCAFE::LambdaTest {
    public fun add_and_return_special(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum == 10) {
            42
        } else {
            sum
        }
    }

    public fun lambda_example(x: u8): u8 {
        let f: |u8|u8 has copy+drop = |a: u8| { a * 2 };
        f(x)
    }
}



//# run 0xCAFE::LambdaTest::add_and_return_special --args 6u8 4u8



//# run 0xCAFE::LambdaTest::lambda_example --args 5u8



//# publish
module 0xCAFE::InlineCallTest {
    use 0xCAFE::LambdaTest;

    public inline fun inline_adder(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_inline_adder(a: u8, b: u8): u8 {
        let sum = inline_adder(a, b);
        // use nested call inside lambda
        let f: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            LambdaTest::add_and_return_special(x, y)
        };
        let result = f(a, b);
        sum + result
    }
}



//# run 0xCAFE::InlineCallTest::call_inline_adder --args 3u8 7u8



//# publish
module 0xBAD::SpecTest {
    // Spec function to return the fixed constant
    spec module {
        fun const_value(): u8 { 100 }
    }

    public fun use_spec_constant(): u8 {
        // Spec functions cannot be called directly in Move code,
        // so return the constant value directly.
        100
    }
}



//# run 0xBAD::SpecTest::use_spec_constant



//# publish
module 0xDEAD::CrossAddressTest {
    public fun only_here(): u8 {
        7
    }

    // Try to forbid calls to functions in other addresses by not providing any such functions
}

// No cross address calls allowed from 0xCAFE::InlineCallTest to 0xDEAD::CrossAddressTest or vice versa

// The following scripts exercise the designed cases but no cross-address calls performed



//# run 0xCAFE::LambdaTest::add_and_return_special --args 1u8 1u8



//# run 0xCAFE::InlineCallTest::call_inline_adder --args 5u8 2u8
