//# publish
module 0xA550C18::ParenthesesTest {
    use std::signer;

    // A simple function that returns the increment of the input
    public fun inc(x: u64): u64 {
        (x + 1)
    }

    // A function demonstrating a sequence of expressions with parentheses, scopes
    public fun sequence_example(): u64 {
        let a = (1 + 2);
        let b = {
            let c = (a * 3);
            (c + 1)
        };
        b
    }

    // A runner function that calls the above to exercise the compiler with parentheses and sequences
    public fun runner(): u64 {
        let x = inc(10);
        let y = sequence_example();
        (x + y)
    }
}
//# run 0xA550C18::ParenthesesTest::runner

//# publish
module 0xA550C18::BytecodeGenTest {
    use std::signer;

    // Function to just use basic operations wrapped by parentheses to generate varied bytecode
    public fun compute_value(x: u8, y: u8): u8 {
        let sum = (x + y);
        let prod = {
            let mid = (sum * 2);
            (mid + 3)
        };
        (prod - 1)
    }

    // Runner for bytecode generation coverage
    public fun runner(): u8 {
        compute_value(4, 5)
    }
}
//# run 0xA550C18::BytecodeGenTest::runner

//# run
script {
    use 0xA550C18::ParenthesesTest;
    use 0xA550C18::BytecodeGenTest;

    fun main(account: signer) {
        // Call a function with parentheses around the arguments
        let val1 = (ParenthesesTest::inc(20));
        let val2 = (ParenthesesTest::sequence_example());
        let val3 = (ParenthesesTest::runner());

        // Call the bytecode generation related function with parentheses
        let val4 = (BytecodeGenTest::compute_value(7, 8));
        let val5 = (BytecodeGenTest::runner());

        // Just to keep things as statements:
        (val1);
        (val2);
        (val3);
        (val4);
        (val5);
    }
}