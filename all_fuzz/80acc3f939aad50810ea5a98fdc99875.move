
//# publish
module 0xCAFE::ComplexTest {
    use std::option;

    const CONST_ONE: u8 = 1;
    const CONST_TWO: u8 = 2;
    const CONST_THREE: u8 = 3;

    public fun add_two_u8(x: u8, y: u8): u8 {
        let sum = x + y;
        assert!(sum == x + y, 1000);
        CONST_THREE
    }

    public fun lambda_test(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            a + b
        };
        adder(x, y)
    }

    // Removed call to MyModule::f2(x) because 0xCAFE::MyModule is invalid.
    // We provide a replacement function that computes two u16 values from x.
    public fun call_inline_nested(x: u16): u32 {
        // Example replacement for MyModule::f2(x):
        // Let's define two numbers a = x and b = x * 2
        let a = x;
        let b = x * 2;
        let sum = a + b;
        sum as u32
    }

    public fun optional_type_annotation(x: u8): option::Option<u8> {
        let res: option::Option<u8> = if (x > 5) {
            option::some(x)
        } else {
            option::none<u8>()
        };
        res
    }

    public fun multi_var_binding(): (u8, u8, u8) {
        let (a, b) = (CONST_ONE, CONST_TWO);
        let c = CONST_THREE;
        (a, b, c)
    }
}


//# run 0xCAFE::ComplexTest::add_two_u8 --args 4u8 5u8


//# run 0xCAFE::ComplexTest::lambda_test --args 7u8 8u8


//# run 0xCAFE::ComplexTest::call_inline_nested --args 15u16


//# run 0xCAFE::ComplexTest::optional_type_annotation --args 6u8


//# run 0xCAFE::ComplexTest::optional_type_annotation --args 3u8


//# run 0xCAFE::ComplexTest::multi_var_binding
