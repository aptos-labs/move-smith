
//# publish
module 0xCAFE::LambdaTest {
    public fun add_then_return_specific(a: u8, b: u8, ret: u8): u8 {
        let sum = a + b;
        let _ignored = sum; // compute sum as required, but return ret
        ret
    }

    public fun apply_lambda(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let c = x + y;
            let d = x * y;
            (c, d)
        };
        lambda(a, b)
    }
}



//# publish
module 0xCAFE::InlineCallTest {
    // Removed 'use' because both modules are in the same address and visibility.
    // Alternatively, importing within the same address may require special syntax or publishing order.
    // Since both modules are at 0xCAFE, 'use' is unnecessary or should be omitted.

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun nested_inline_call(a: u8, b: u8, c: u8): u8 {
        let sum = inline_add(a, b);
        // Call the function with fully qualified name
        0xCAFE::LambdaTest::add_then_return_specific(sum, 0u8, c)
    }
}



//# run 0xCAFE::LambdaTest::add_then_return_specific --args 12u8 34u8 99u8



//# run 0xCAFE::LambdaTest::apply_lambda --args 6u8 7u8



//# run 0xCAFE::InlineCallTest::nested_inline_call --args 4u8 5u8 77u8
