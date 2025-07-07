//# publish
module 0xCAFE::AbilityTest {
    // Testing ability declarations with commas, braces and semicolons

    // Ability declaration with multiple abilities separated by commas
    native public fun dummy();

    // Define abilities with commas and braces in various positions
    // This dummy struct is to ensure syntax with abilities is accepted
    struct ExampleWithAbilities has copy, drop, store {}

    // Function that returns a struct with abilities just for syntax check
    public fun create_example(): ExampleWithAbilities {
        ExampleWithAbilities {}
    }

    // Runner function to satisfy guidelines
    public fun runner() {}
}

//# run 0xCAFE::AbilityTest::runner

//# publish
module 0xCAFE::NestedLoopTest {
    // Testing nested loops with breaks and variable assignments persisting

    public fun runner(): u64 {
        let mut outer_count = 0u64;
        let mut total = 0u64;

        loop {
            outer_count = outer_count + 1;
            let mut inner_count = 0u64;

            loop {
                inner_count = inner_count + 1;
                total = total + 1;

                if inner_count == 3 {
                    break; // inner loop break
                }

                if outer_count > 5 {
                    break; // inner loop break we won't hit because inner_count < 3
                }
            }

            if outer_count == 5 {
                // Break outer loop
                break;
            }
        }

        // total should be 5 * 3 = 15, outer_count = 5
        total + outer_count
    }
}

//# run 0xCAFE::NestedLoopTest::runner

//# publish
module 0xCAFE::MoveKeywordTest {
    // Testing move keyword on a variable

    struct Container has key {
        val: u64
    }

    public fun runner(): u64 {
        let c = Container { val: 42 };
        let c_moved: Container = move(c);
        // after move, c shouldn't be used.
        c_moved.val
    }
}

//# run 0xCAFE::MoveKeywordTest::runner

// Featurres:
// a06727494262e8a948eb4b0617e7fbda: Recognize specific tokens such as commas, braces, and semicolons to parse ability declarations correctly.
// fb975419e419545ebed8bc07190730ed: Test that nested loops with inner and outer breaks execute correctly and all variable assignments persist as expected after breaking out of both loops.
// 5cb59050f7881a0c0d66dad8d4470a0c: Move a variable using the move keyword.
