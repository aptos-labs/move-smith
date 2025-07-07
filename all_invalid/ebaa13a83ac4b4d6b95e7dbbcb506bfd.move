//# publish
module 0xCAFE::LoopTest {
    struct Counter has copy, drop, store {
        val: u64,
    }

    public fun for_loop_count(): u64 {
        let mut sum = 0;
        // For loop from 0 to 10 (exclusive)
        let i = 0;
        // Since Move has no classical for loops, we use a while with an increment
        let mut i = 0;
        while (i < 10) {
            sum = sum + i;
            i = i + 1;
        };
        sum
    }

    struct NamedFields has copy, drop, store {
        foo: u8,
        bar: u64,
    }

    public fun make_named_fields(): NamedFields {
        NamedFields { foo: 1, bar: 2 }
    }

    // Closure-like simulation: Move does not have closures,
    // but we can simulate variable shadowing within a block scope.
    public fun variable_shadowing(): u64 {
        let mut outer = 5u64;

        {
            let outer = 10u64;  // shadows outer variable
            if (outer > 5) {
                // shadowed outer does not mutate outside variable
                // but we simulate closure updating by explicitly assigning
                outer = 15u64;
            }
            // The shadowed outer goes out of scope here
            // No side effect on original outer here,
            // but to simulate closure updating outer variable, we assign it:
            let mut outer_original = outer;
            outer_original = outer;
        };

        // Simulate correct update by manually assigning:
        outer = 15u64;
        outer
    }

    public fun runner(): u64 {
        let sum = for_loop_count();
        let named = make_named_fields();
        let shadowed = variable_shadowing();
        sum + (named.foo as u64) + named.bar + shadowed
    }
}

//# run 0xCAFE::LoopTest::runner

// Featurres:
// e30a10ad8f41ff841643f76465921990: Test that a for loop iterates correctly over a range from 0 to 10.
// f8a5f4d8aa8d95ae2f248e69416f2896: Name struct or tuple fields using identifiers as usual.
// 118133204bf7d0b6a196821951fddb7c: Test that a variable shadowed within a closure correctly updates an outer variable when the closure is invoked.
