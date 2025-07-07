//# publish
module 0xDEAD::NestedInlineFunctions {
    // Removed unused import
    // use std::vector;

    struct TestStruct has copy, drop, store {
        value: u8
    }

    public fun test_nested_inlines() {
        // Using the inline function f2 with argument 3
        let (a, b) = Self::f2(3);
        // Note: f2 returns u16, but f1 expects u8, so we need to cast
        let a_u8 = a as u8;
        let b_u8 = b as u8;
        // Passing the casted a and the boolean result of b > 1
        let result = Self::f1(a_u8, b > 1);
        // Return the result of f1, which should be a u8
        result
    }

    // Inline function f2: returns tuple (a+1, a+2)
    public inline fun f2(a: u16): (u16, u16) {
        (a + 1, a + 2)
    }

    // Function f1: returns u8, with some conditions
    public fun f1(x: u8, y: bool): u8 {
        // if y is true, set _a; else, set _b (variables unused)
        if (y) {
            let _a = 1;
        } else {
            let _b = 2;
        };
        // Using while to increment x, ending with semicolon
        while (x < 10) {
            x = x + 1;
        };
        // Last expression in function body is return value
        x
    }
}
