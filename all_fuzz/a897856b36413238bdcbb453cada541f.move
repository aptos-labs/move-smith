
//# publish
module 0xCAFE::FeatureTest {
    use std::vector;

    // 1. Test addition of two u8 values and return specific value
    public fun add_then_return(a: u8, b: u8, ret: u8): u8 {
        let sum = a + b;
        sum;
        ret
    }

    // 2. Functions containing lambda expressions with copy+drop abilities
    public fun apply_lambda(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |a: u8| { a + 1 };
        lambda(x)
    }

    public fun apply_lambda_double(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |a: u8| { a * 2 };
        lambda(x)
    }

    // 3. Calling an inline function from another module correctly
    public fun call_inline_from_other_module(x: u16): (u16, u16) {
        0xCAFE::InlineModule::inline_add_two(x)
    }

    // 4. Use labels in code for breaking loops
    public fun loop_with_label(x: u8): u8 {
        let counter = x;
        'loop_label: loop {
            if (counter == 0) {
                break 'loop_label;
            };
            counter = counter - 1;
        };
        counter
    }

    // 5. Spec function - remove 'native' annotation as it is invalid here
    spec fun pure_spec_fun(): u8;

    // 6. Match arms with either single expression or block as body
    enum MyEnum has copy, drop {
        One,
        Two(u8),
        Three { value: u8 }
    }

    public fun match_example(e: MyEnum): u8 {
        let res = match e {
            MyEnum::One => 1,
            MyEnum::Two(a) => {
                let val = a + 2;
                val
            },
            MyEnum::Three { value } => value + 3,
        };
        res
    }
}



//# publish
module 0xCAFE::InlineModule {
    public inline fun inline_add_two(x: u16): (u16, u16) {
        (x + 2, x + 3)
    }
}



//# run 0xCAFE::FeatureTest::add_then_return --args 5 10 42


//# run 0xCAFE::FeatureTest::apply_lambda --args 10


//# run 0xCAFE::FeatureTest::apply_lambda_double --args 7


//# run 0xCAFE::FeatureTest::call_inline_from_other_module --args 100


//# run 0xCAFE::FeatureTest::loop_with_label --args 3


//# run 0xCAFE::FeatureTest::match_example --args 0


//# run 0xCAFE::FeatureTest::match_example --args 1



//# run
script {
    use 0xCAFE::FeatureTest;

    fun main() {
        let e = FeatureTest::MyEnum::Three { value: 5u8 };
        let _result = FeatureTest::match_example(e);
    }
}
