//# publish
module 0xCAFE::BinopTest {
    use std::signer;
    use std::debug;

    struct Counter has store, copy, drop {
        value: u8,
    }

    /// Increment counter.value by 1 and return the previous value.
    /// Used to test evaluation order with side effects.
    public fun inc_and_get(c: &mut Counter): u8 {
        let old_value = c.value;
        c.value = c.value + 1;
        old_value
    }

    /// Perform various binary operations with mixed expressions.
    /// Returns a tuple of all results (to avoid unused warnings).
    public fun bins_and_lists(a: u8, b: u8): (u8, u8, u8, u8, bool) {
        // Test addition, subtraction, bitwise AND, OR, XOR, and comparisons.
        // Also test expression lists and nested binary ops.

        // Expression list example: (a + b, a - b)
        let (add, sub) = (a + b, a - b);

        // Bitwise operations
        let and = a & b;
        let or = a | b;
        let xor = a ^ b;

        // Comparison (a == b)
        let eq = (a == b);

        // Return the tuple
        (add, sub, and, or, eq)
    }

    /// Runner function testing evaluation order using side-effecting function inc_and_get.
    /// Should produce a series of increments from left to right.
    public fun runner(): u8 {
        let mut c = Counter { value: 0 };
        // Evaluate arguments left-to-right:
        // inc_and_get(&mut c) + inc_and_get(&mut c) * inc_and_get(&mut c)
        // With c starting at 0:
        // left op = 0 (then c=1)
        // right op = inc_and_get(&mut c) * inc_and_get(&mut c)
        //   first right inc = 1 (c=2)
        //   second right inc = 2 (c=3)
        // multiplication: 1 * 2 = 2
        // addition: 0 + 2 = 2
        let result = inc_and_get(&mut c) + (inc_and_get(&mut c) * inc_and_get(&mut c));
        // c.value = 3 after evaluation
        // result = 2
        result
    }

    /// Test a complex expression list to test evaluation order in multiple expressions.
    public fun complex_expression_list(): (u8, u8, u8) {
        let mut c = Counter { value: 10 };

        // Expression list: (inc_and_get(&mut c), inc_and_get(&mut c) + 5, inc_and_get(&mut c) * 2)
        // Evaluation order is left to right:
        // c.value = 10 initially
        // first = 10 (c=11)
        // second = 11+5=16 (c=12)
        // third = 12*2=24 (c=13)
        let results = (inc_and_get(&mut c), inc_and_get(&mut c) + 5, inc_and_get(&mut c) * 2);
        results
    }

    /// Specification block targeting entire module, checking properties of runner function.
    spec module {
        // runner must always return 2
        fun runner_returns_2(): bool {
            runner() == 2
        }

        // Within complex_expression_list, second tuple element must be first+6
        fun complex_list_property(): bool {
            let (first, second, _) = complex_expression_list();
            second == first + 6
        }
    }
}
//# run 0xCAFE::BinopTest::runner
//# run 0xCAFE::BinopTest::complex_expression_list