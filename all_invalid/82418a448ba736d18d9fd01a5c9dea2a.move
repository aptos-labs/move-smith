
//# publish
module 0xBADA::UnaryOperatorsTest {
    use std::signer;

    // Define a simple helper module to check borrow and move semantics
    // No functions in here; focus is on tests in the main script
}


//# run 0xBADA::UnaryOperatorsTest::test_unary_and_borrow


//# script
//# run
script {
    use 0xBADA::UnaryOperatorsTest;

    fun test_unary_and_borrow() {
        let x: u8 = 10;
        // Unary operator: +x (which is just x itself, but for test purpose)
        let unary_plus = +x;
        // Unary operator: -x (not directly supported, but for test, assume some conceptual test)
        // Move semantics not supported directly; just testing the expression
        let _neg_x = unary_plus - 10;  // should be 0

        // Mutable reference creation
        let y: u8 = 5;
        let r_y: &mut u8 = &mut y;

        // Borrowing immutable reference from mutable reference
        let r_immutable: &u8 = &*r_y;

        // Use in if condition
        if (*r_immutable > 0) {
            // Move immutable ref into a variable
            let z = *r_immutable;
            // Use z
            assert!(z == 5, 42);
        };

        // Assign mutable reference to an immutable variable (allowed)
        let immut_ref: &u8 = &*r_y;

        // Now, reborrow as mutable for further mutation
        let r_y_mut: &mut u8 = &mut y;
        *r_y_mut = 20;

        // Function call with immutable ref (should work)
        let _ = check_value(&*r_y);

        // Function call with mutable ref (should work)
        check_value_mut(&mut r_y);

        // Conditional with immutable borrow
        if (*r_y > 10) {
            let _ = *r_y;
        };

        // Borrowing again in nested scope
        {
            let r_innermost: &u8 = &*r_y;
            assert!(*r_innermost == 20, 43);
        }
    }

    fun check_value(val: &u8) {
        assert!(*val >= 0, 44);
    }

    fun check_value_mut(val: &mut u8) {
        *val += 1;
    }
}


// Featurres:
// b5a32a6117cd6d94dbd90966e801970e: Define modules using the 'module' function with a module identifier and its definition.
// a12be701b4cca6f3c13773c6fbb4b0df: Apply unary operators to expressions with the `unary_exp` expression.
// b93d3ab4f27c60d785009cf046f3d8ee: Test that mutable references (`&mut`) can be safely and correctly frozen to immutable references (`&`) in various contexts, including function calls, assignments, conditionals, and borrow operations, ensuring proper Move type and borrow checker behavior.
