
//# publish
module 0xCAFE::InlineModule {
    public inline fun inline_function(a: u16): (u16, u16) {
        (a + 10, a + 20)
    }
}


//# publish
module 0xCAFE::LambdaTest {
    public fun add_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum < 200) {
            42u8
        } else {
            255u8
        }
    }

    public fun run_lambda_example(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b + 1u8
        };
        lambda(x, y)
    }

    public fun inline_test(a: u16): (u16, u16) {
        0xCAFE::InlineModule::inline_function(a)
    }
}


//# run 0xCAFE::LambdaTest::add_u8 --args 10u8 20u8


//# run 0xCAFE::LambdaTest::run_lambda_example --args 3u8 7u8


//# run 0xCAFE::LambdaTest::inline_test --args 100u16

/// Note: Test to warn about invalid nested attribute usage cannot be expressed as normal Move syntax.
// In Aptos Move, attributes must appear at correct positions and nested attributes are not allowed.
// Such a test is more about static checking of source code style rather than runtime Move code.
// We will show an example comment here to indicate invalid nested attribute usage that the compiler should warn about.

// Example Invalid code: (Do NOT put inside any module or function in actual test file)
// // outer]
// // inner]  // <- nested attribute not allowed; should warn
// module 0xCAFE::InvalidAttribute {}
