
//# publish
module 0xCAFE::TestSwap {
    use std::option;

    public fun test(x: u64, y: u64, iterations: u64) {
        let a = x;
        let b = y;
        let i = 0;
        while (i < iterations) {
            let temp = a;
            a = b;
            b = temp;
            i = i + 1;
        }
        // After loop, `a` and `b` have swapped values if iterations > 0
        move(a);
        move(b);
    }
}


//# run 0xCAFE::TestSwap::test --args 10u64 20u64 5u64



//# publish
module 0xCAFE::Expressions {
    // Function to create primary expressions: literals and name references
    public fun literals_and_names() {
        let num_literal = 42u64;
        let bool_literal = true;
        let byte_str_literal = b"hello\nworld";
        let named_value = num_literal; // referencing literal value
        move(named_value);
    }
}


//# run 0xCAFE::Expressions::literals_and_names



//# publish
module 0xCAFE::Quantifiers {
    // Function to define and use range quantifiers with bind variables
    public fun range_quantifiers() {
        // Loop over range 0..5, binding each to i
        let sum = 0;
        let range_start = 0;
        let range_end = 5;
        let i = range_start;
        while (i < range_end) {
            // Use the bind variable `i` in a condition
            if (i % 2 == 0) {
                sum = sum + i;
            }
            i = i + 1;
        }
        // Use quantifier: For all i in 0..5, i >= 0 (trivially true)
        assert (forall(i in 0..5): i >= 0);
        move(sum);
    }
}


//# run 0xCAFE::Quantifiers::range_quantifiers

// Featurres:
// b2ebafbe1a7eab3fd68df73d10d28c1f: Test that the `test` function correctly swaps the values of `x` and `y` after a number of iterations based on the input.
// 8e6fca7ad7a41c88c6b4a550ff9e7b3e: Create primary expressions such as name references and value literals (like numbers, booleans, byte strings).
// 4ef7f031a62e72900b731fc82e1d6ca3: Use quantifiers over ranges and bind variables for them in specifications or logic expressions.
