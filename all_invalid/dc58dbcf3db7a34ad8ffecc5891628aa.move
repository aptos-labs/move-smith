// This code needs to be structured as a Move transaction script. The error indicates that the 'script' keyword is not recognized in your test environment.
// Typically, in Move tests or transactions, you write a module with test functions or scripts in a specific way.
// Since your test is trying to execute a script, ensure you're using a proper Move script syntax and calling the test function appropriately.

// Here's a corrected version of the code, assuming you want to define a test module with a test function and then call that function from the test harness.

//# publish
module 0xBADA::UnaryOperatorsTest {

    use std::signer;

    // Your test function
    public fun test_unary_and_borrow() {
        let x: u8 = 10;
        // Unary plus: in Move, there's no unary +, so we just assign directly for test
        let unary_plus = x; // +x is same as x

        // For '-x', Move does not support unary minus directly on integers;
        // but we can simulate with subtraction for the test
        let neg_x = 0 - unary_plus; // should be 0 - 10 = -10 in arithmetic, but u8 wraps around (0 - 10) = 246
        // Note: 'neg_x' might wrap around; if you want to test negative, you'd need a signed type

        // Mutable variable y
        let y: u8 = 5;
        let y_mut = y;

        // Borrow immutable reference
        let r_y: &u8 = &y_mut;

        // Borrowing immutable reference from mutable reference
        let r_immutable: &u8 = &r_y;

        if (*r_immutable > 0) {
            let z = *r_immutable;
            assert!(z == 5, 42);
        };

        // Assign immutable reference from mutable variable
        let immut_ref: &u8 = &y_mut;

        // Reborrow as mutable
        let r_y_mut: &mut u8 = &mut y_mut;
        *r_y_mut = 20;

        // Call functions with immutable and mutable references
        check_value(&*r_y); // passing immutable ref
        check_value_mut(&mut r_y_mut); // passing mutable ref

        if (*r_y_mut > 10) {
            let _ = *r_y_mut;
        };

        {
            let r_innermost: &u8 = &*r_y_mut;
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

// Note: To execute this test, you'd typically define a test module with test attribute
// or call 'test_unary_and_borrow' from your test harness elsewhere.

// If you want a script that runs this function, you could define a simple script like:


//# script
//# run
script {
    use 0xBADA::UnaryOperatorsTest;

    fun main() {
        UnaryOperatorsTest::test_unary_and_borrow();
    }
}
