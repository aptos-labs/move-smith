//# publish
module 0x1::SwapTest {
    use std::debug;
    use std::signer;

    /// Swaps two u64 values and returns the swapped values in a tuple.
    public fun test(a: u64, b: u64): (u64, u64) {
        let tmp = a;
        let a = b;
        let b = tmp;
        (a, b)
    }

    /// Main function to verify the swap by asserting the swapped values.
    public fun main() {
        let (x, y) = test(123, 456);
        // assert x == 456
        debug::assert(x == 456, 0); // error code 0 for failed assertion
        // assert y == 123
        debug::assert(y == 123, 1); // error code 1 for failed assertion
    }
}
//# run 0x1::SwapTest::main

//# publish
module 0x1::WhileLoopTest {
    use std::debug;

    /// Runs a while loop with a false condition.
    /// The variable should retain its initial value.
    public fun test_while_false() {
        let mut x = 42u64;
        while (false) {
            x = 0;
        }
        // x should still be 42
        debug::assert(x == 42, 2);
    }

    /// Runner function without arguments.
    public fun main() {
        test_while_false();
    }
}
//# run 0x1::WhileLoopTest::main

//# publish
module 0x1::ExpressionEndTest {
    use std::debug;

    /// This function helps test expression parsing.
    /// It chains multiple expressions and uses multiple semicolons.
    public fun test_expression_end() {
        let x = 1 + 2;
        let _ = x;
        // we rely on the Move compiler parsing correct ends of expressions
        debug::assert(x == 3, 3);

        let y = {
            let a = 10;
            let b = 20;
            a + b
        };
        debug::assert(y == 30, 4);
    }

    /// Runner function without arguments.
    public fun main() {
        test_expression_end();
    }
}
//# run 0x1::ExpressionEndTest::main

//# run
script {
    use std::debug;

    fun main() {
        // we simply run main functions of all modules to exercise compiler and VM
        0x1::SwapTest::main();
        0x1::WhileLoopTest::main();
        0x1::ExpressionEndTest::main();

        debug::print(&"All tests ran.");
    }
}