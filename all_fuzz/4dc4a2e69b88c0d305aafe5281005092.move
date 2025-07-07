
//# publish
module 0xCAFE::MathModule {
    // This module tests addition of two u8 values and lambda usage

    public fun add_two_numbers(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            10u8
        } else {
            sum
        }
    }

    public fun use_lambda(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        adder(x, y)
    }

    // Change helper_inline from private to public to allow inline expansion anywhere
    public fun helper_inline(a: u8): u8 {
        a + 1
    }

    public inline fun inline_increment(a: u8): u8 {
        helper_inline(a)
    }
}




//# publish
module 0xCAFE::NestedCaller {
    // Remove the import statement as it is not supported in Move modules
    // Just call the fully qualified name instead

    public fun call_inline_add(x: u8, y: u8): u8 {
        let sum = 0xCAFE::MathModule::add_two_numbers(x, y);
        let incremented = 0xCAFE::MathModule::inline_increment(sum);
        incremented
    }
}




//# run 0xCAFE::MathModule::add_two_numbers --args 4u8 5u8




//# run 0xCAFE::MathModule::add_two_numbers --args 6u8 7u8




//# run 0xCAFE::MathModule::use_lambda --args 3u8 4u8




//# run 0xCAFE::NestedCaller::call_inline_add --args 4u8 5u8
