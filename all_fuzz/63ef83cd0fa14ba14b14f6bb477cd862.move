
//# publish
module 0xCAFE::LamTest {
    const CONST_VAL: u8 = 42;

    public fun add_and_check(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return sum plus constant
        sum + CONST_VAL
    }

    // Move does not support nested function definitions.
    // Instead, inline the logic directly.
    public fun apply_lambda(x: u8, y: u8): u8 {
        // Directly compute sum instead of defining inner_lambda
        x + y
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun inline_wrapper(x: u8, y: u8): u8 {
        let inner_sum = inline_add(x, y);
        inner_sum + 10
    }

    public fun test_abort_conditional(x: u8, y: u8): u8 {
        let z = if (x > y) {
            abort 1000;
            0
        } else {
            x + y
        };
        z + 1
    }
}
