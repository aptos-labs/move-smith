
//# publish
module 0xCAFE::AdditionModule {
    // Module to test addition of two u8 and returning a specific value
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun use_lambda(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let sum = x + y;
            let prod = x * y;
            (sum, prod)
        };
        lambda(a, b)
    }
}



//# publish
module 0xCAFE::CallerModule {

    // Note: Removed unused import 'use 0xCAFE::AdditionModule;'

    public inline fun double_inline_call(x: u16): (u64, u64) {
        let (a, b) = f_inline(x);
        (a, b)
    }

    public inline fun f_inline(val: u16): (u64, u64) {
        // Fixed by using explicit addition expressions in parentheses
        // and splitting into separate let bindings to avoid expression parsing error
        let val64 = val as u64;
        let a = val64 + 10;
        let b = val64 + 20;
        (a, b)
    }

    public inline fun call_nested_inline(x: u16): (u64, u64) {
        let (a, b) = double_inline_call(x);
        (a, b)
    }
}



//# run 0xCAFE::AdditionModule::add_and_return_sum --args 15u8 27u8



//# run 0xCAFE::AdditionModule::use_lambda --args 3u8 5u8



//# run 0xCAFE::CallerModule::call_nested_inline --args 100u16

// Explanation of fixes:
// 1. In function f_inline, the expression `(val as u64 + 10, val as u64 + 20)` was causing parse errors because of operator precedence ambiguity.
//    The solution is to cast val once, assign to a local variable, and then add the constants separately.
// 2. This avoids the parser seeing `val as u64 + 10` inside a tuple expression as ambiguous.
// 3. Other fixes from original were maintained.
