//# publish
module 0x1::ClosureTest {

    public fun run_counter() {
        let counter = 0;
        increment_counter(&mut counter);
        assert!(counter == 1, 0);
        increment_counter(&mut counter);
        assert!(counter == 2, 0);
    }

    public fun increment_counter(counter_ref: &mut u64) {
        *counter_ref = *counter_ref + 1;
    }

    public fun test_shadowed_variable_in_closure() {
        let total = 0;

        // Shadowing total with a closure
        let update = |delta: u64| {
            // Attempt to modify outer total
            total = total + delta; // This should cause an error if misuse, but in Move, variables are immutable in closures unless captured mutably.
        };

        // Since Move does not support capturing variables in lambdas like that,
        // this is just a conceptual test for shadowing and variable updates.

        // To simulate similar behavior, define a function that takes mutable reference
        // and then test supply of the reference in different scopes.

        // However, for the purpose of the test, let's define a mutable variable
        // that gets shadowed inside a nested block.

        let outer_var = 5;

        {
            // Shadowing outer_var
            let outer_var = 10;
            // modifying the shadowed variable
            let outer_var = outer_var + 2;
            // At this point, outer_var inside this block is 12
            // outer_var outside remains 5
        }

        // assert that outer_var remains unchanged
        assert!(outer_var == 5, 0);

        // To truly test variable shadowing within closures in Move,
        // the closest we can do is to define nested blocks and shadow variables.
    }

    // Additional test: ensure that mutability within a nested block affects outer variable if mutable reference is used.
    public fun test_mutable_reference_shadow() {
        let mut x = 0;
        {
            // Shadow x
            let mut x = x;
            x = 42; // modifies the shadowed variable
        }
        // original x should remain unchanged
        assert!(x == 0, 0);
    }
}

//# run 0x1::ClosureTest::run_counter
//# run 0x1::ClosureTest::test_shadowed_variable_in_closure
//# run 0x1::ClosureTest::test_mutable_reference_shadow