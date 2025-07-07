//# publish
module 0x1::SwapTest {
    /// Swaps the two u64 arguments and returns them in swapped order
    public fun test(a: u64, b: u64): (u64, u64) {
        (b, a)
    }

    /// Calls test and verifies the swap by asserting swapped values
    public fun main() {
        let (x, y) = test(10, 20);
        // We expect x = 20 and y = 10 after swap
        assert!(x == 20, 1);
        assert!(y == 10, 2);
    }
}
//# run 0x1::SwapTest::main

//# publish
module 0x1::VarBindTest {

    /// An inline helper function adding two values
    inline fun add(x: u64, y: u64): u64 {
        x + y
    }

    /// Higher order function: takes a function f and applies it to 1 and 2
    public fun apply(f: &fun(u64, u64): u64): u64 {
        f(1, 2)
    }

    /// Tests variable bindings, destructuring, inline functions,
    /// higher-order functions and anonymous closures
    public fun run() {
        // Variable binding and destructuring
        let (a, b) = (3, 4);
        let c = add(a, b);

        // Anonymous closure capturing outer scope variable c
        let closure = &fun(x: u64, y: u64): u64 {
            // uses c + x + y
            c + x + y
        };

        let result = apply(closure);

        // result = c + 1 + 2 = (3+4) + 1 + 2 = 7 + 3 = 10 
        assert!(result == 10, 100);
    }
}
//# run 0x1::VarBindTest::run

//# publish
module 0x1::ParseEndTest {

    /// Function to test whether expressions end correctly by nested blocks and sequences
    public fun test_end_expr(): u64 {
        let x = {
            let y = 5;
            y + 1
        };
        // x is 6

        // Single literal expr
        let z = 7;
        // z is 7

        x + z // 13
    }

    public fun runner(): u64 {
        test_end_expr()
    }
}
//# run 0x1::ParseEndTest::runner

//# run
script {
    use 0x1::SwapTest;
    use 0x1::VarBindTest;
    use 0x1::ParseEndTest;

    /// main function of script with modifiers (e.g. entry)
    entry fun main(account: signer) {
        // Call SwapTest main verifying swap
        SwapTest::main();

        VarBindTest::run();

        let val = ParseEndTest::runner();
        assert!(val == 13, 200);

        // Bind local variables in reverse order demonstration:
        let a = 1;
        let b = 2;
        let c = 3;
        // Suppose we bind variables [c, b, a] in reverse order 
        // (simulated by just defining in order then a comment)
    }
}