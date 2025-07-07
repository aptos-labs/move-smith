
//# publish
module 0xDEAD::NestedInlineFunctions {
    use std::vector;

    struct TestStruct has copy, drop, store {
        value: u8
    }

    public fun test_nested_inlines() {
        // Using the inline function f2 with argument 3
        let (a, b) = Self::f2(3);
        // Passing the result of f2 to f1
        let result = Self::f1(a, b > 1);
        // Return the result of f1, which should be a u8
        result
    }

    // Inline function f2: returns tuple (a+1, a+2)
    public inline fun f2(a: u16): (u16, u16) {
        (a + 1, a + 2)
    }

    // Function f1: returns u8, with some conditions
    public fun f1(x: u8, y: bool): u8 {
        // if y is true, set parenthesis for clarity
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


//# run 0xDEAD::NestedInlineFunctions::test_nested_inlines


// Featurres:
// 7f0eee0ccf6d537626d8da45a5b5f98a: Use optional type annotations in your code to allow types to be present or omitted
// cc8c69755e71ae8b32b329d7d21583ea: Test that the nested inline functions in the module correctly compute the value by applying f2 to 3 and then passing the result to f1, resulting in the correct final output.
// 4b1e2b46aabc7fb4cadc6b955a2b1035: Write code blocks where the final expression is allowed without a trailing semicolon to return its value.
