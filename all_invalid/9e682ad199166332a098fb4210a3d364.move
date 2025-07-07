
//# publish
module 0xCAFE::AdvancedTest {
    use std::vector;

    struct ComplexStruct<T> has copy, drop, store {
        a: u8,
        b: T,
        c: u16,
    }

    // Inline function that accepts a function-typed parameter and invokes it in nested loops
    public fun run_nested_loops_with_func(
        f: |u8, u16| bool,
        limit_outer: u8,
        limit_inner: u16,
    ) {
        let i = 0;
        loop {
            if (i >= limit_outer) {
                break;
            };

            let j = 0;
            loop {
                if (j >= limit_inner) {
                    break;
                };

                // Construct ComplexStruct with explicit type argument
                let cs = ComplexStruct<u64> { a: i, b: 100u64, c: j };

                // Call the function-typed parameter
                let should_break = f(cs.a, cs.c);

                if (should_break) {
                    break;
                };

                j = j + 1;
            };
            i = i + 1;
        };
    }

    public fun runner() {
        // Lambda returning true if sum of arguments >= 10, else false
        let lambda: |u8, u16| bool = |x: u8, y: u16| {
            let sum = (x as u16) + y;
            if (sum >= 10) {
                true
            } else {
                false
            }
        };
        run_nested_loops_with_func(lambda, 5u8, 20u16);
    }
}

//# run 0xCAFE::AdvancedTest::runner


// Featurres:
// 4e4c465aebcc9d9fa9dc63f1c37f1ee2: Create or use function parameters with function-typed values in inline functions.
// cfc2fdac37678eab319a0d31c41e206f: Construct pack values with module access, type arguments, and fields.
// 3a0d3f7792007d352ef52a3bdf719c1c: Test nested loop constructs with break statements and verify proper control flow termination.
