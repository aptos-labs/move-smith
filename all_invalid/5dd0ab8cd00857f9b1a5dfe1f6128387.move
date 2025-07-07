
//# publish
module 0xCAFE::CombinedFeaturesTest {
    // Corrected import: std::debug module does not exist in Aptos stdlib.
    // Using std::debug_print instead for printing. Import std::debug_print module.
    use std::debug_print;

    // [inline]
    public inline fun inline_add_mul(a: u8, b: u8): (u8, u8) {
        // Return sum and product of a, b
        (a + b, a * b)
    }

    // [inline]
    public inline fun inline_error_fn(x: u8): u8 {
        // Intentionally trigger an abort with code 42 to test backtrace inside inline
        assert!(x > 10, 42);
        x
    }

    public fun test_lvalue_binding() {
        let (sum, product) = inline_add_mul(3u8, 7u8);
        let (x, y) = (sum, product);

        // Use the bound variables to do some operations
        let z = x + y;
        // Intentional failed assertion to produce backtrace on lvalue binding test
        assert!(z == 58, 43);
    }

    public fun test_pattern_binding_multiple_vars() {
        let (a, b) = (5u8, 6u8);
        let (c, d) = inline_add_mul(a, b);

        // Intentional assertion error for backtrace
        assert!(c < 0, 44); // invalid, forcing error with pattern vars
    }

    public fun test_inline_and_lvalue_combined() {
        let (sum, product) = inline_add_mul(1u8, 2u8);

        // Call inline function that aborts to check backtrace with inline + lvalue bindings
        let val = inline_error_fn(sum);
        let unused = product + val;

        // Replace debug::print with std::debug_print::print
        debug_print::print(b"Combined test done");
    }

    public fun test_wrong_lvalue_usage() {
        // Intentionally cause an error: destructuring wrong tuple size
        let (a, b, c) = inline_add_mul(1u8, 1u8);
        // If lvalue binding is wrong, the compiler or VM should emit backtrace here
    }

    public fun test_inline_with_tuple_return() {
        let (x, y) = inline_add_mul(10u8, 20u8);
        // Proper use with inline function returning tuple
        assert!(x == 30 && y == 200, 45);
    }
}
