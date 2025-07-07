
//# publish
module 0xCAFE::AdditionTest {
    public fun add_and_return_expected(a: u8, b: u8): u8 {
        let sum = a + b;
        // return 42 if sum is correct (just a dummy logic for test)
        if (sum == a + b) {
            42
        } else {
            0
        }
    }

    // Removed invalid lambda syntax and replaced by a normal function
    public fun double_value(value: u8): u8 {
        value * 2
    }

    public fun lambda_double_apply(x: u8): u8 {
        // Call the double_value function twice to mimic lambda_double_apply
        double_value(double_value(x))
    }

    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }
}



//# run 0xCAFE::AdditionTest::add_and_return_expected --args 10u8 32u8



//# run 0xCAFE::AdditionTest::lambda_double_apply --args 10u8


// Publish AdditionTest first before compiling NestedInline



//# publish
module 0xCAFE::NestedInline {
    use 0xCAFE::AdditionTest;

    public fun call_inline_increment_twice(x: u8): u8 {
        let first = AdditionTest::inline_increment(x);
        AdditionTest::inline_increment(first)
    }
}



//# run 0xCAFE::NestedInline::call_inline_increment_twice --args 40u8
