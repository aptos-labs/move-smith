//# publish
module 0xCAFE::ControlFlow {
    public fun if_else_example(x: u8, y: bool): u8 {
        // parentheses are required for if condition expressions
        if (y) {
            let _a = 1;
        } else {
            let _b = 2;
        };
        // All `if (...) {...}` or `if (...) {...} else {...}` MUST end with a semicolon if it's a statement.

        // parentheses are required for while condition expressions
        while( x < 10) {
            x = x + 1;
        };
        // `while` loops must end with a semicolon

        let z = x + 1;
        // last expression in a function is the return value
        z
    }

    public fun loop_examples(): u32 {
        let x: u32 = 1u32;
        for (i in 0..5) {
            x += i;
        };
        while (x > 5) {
            x -= 1;
        };
        loop {
            if (x == 0) {
                break;
            };
            x -= 1;
        };
        x
    }
}

//# run 0xCAFE::ControlFlow::if_else_example --args 3u8 true