
//# publish
module 0xCAFE::LambdaTest {
    // Function that adds two u8 values and returns u8 + fixed offset 10
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        // add fixed 10 offset and return
        sum + 10
    }

    // Function containing lambda expression to multiply then add constant 5
    public fun lambda_multiply_add(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            a * b + 5u8
        };
        lambda(x, y)
    }

    // Dummy inline functions to replace missing MyModule::f1 and MyModule::f2
    // f1 takes (u8, bool) returns u8
    // inline]
    public fun f1(x: u8, flag: bool): u8 {
        if (flag) {
            x + 1
        } else {
            x
        }
    }

    // f2 takes u16 returns (u16, u8)
    // inline]
    public fun f2(x: u16): (u16, u8) {
        (x, 42u8) // dummy second value
    }
    
    // Call the inline function f2 with argument 3u16, then use f1 with first element of tuple and true boolean
    public fun call_nested_inline(): u8 {
        let (a, _b) = f2(3u16);
        f1(a as u8, true)
    }

    // Runner function that uses nested inline calls and returns the final value of f1 after f2 application on 3u16
    public fun runner(): u8 {
        call_nested_inline()
    }
}


//# run 0xCAFE::LambdaTest::add_and_offset --args 12u8 17u8


//# run 0xCAFE::LambdaTest::lambda_multiply_add --args 3u8 4u8


//# run 0xCAFE::LambdaTest::call_nested_inline


//# run 0xCAFE::LambdaTest::runner
