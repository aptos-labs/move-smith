//# publish
module 0x123::logical_ops {

    // This module tests the basic and complex logical operations in Move.
}

//# run 0x123::logical_ops::test_logical_expressions

script {
    // Basic AND and OR operations
    const and_tt: bool = true && true;
    const and_tf: bool = true && false;
    const and_ft: bool = false && true;
    const and_ff: bool = false && false;

    const or_tt: bool = true || true;
    const or_tf: bool = true || false;
    const or_ft: bool = false || true;
    const or_ff: bool = false || false;

    // Negation tests
    const not_true: bool = !true;
    const not_false: bool = !false;

    // Complex boolean expression
    // Evaluates to true if either:
    // - Not (both true and false) which is true, or
    // - (false or true) and true which is true, then OR with true
    // The overall should be true.
    const complex_expr: bool = !((true && false) || (false || true) && true) || true;

    fun main() {
        // Assertions for AND
        assert!(and_tt, 42);
        assert!(!and_tf, 42);
        assert!(!and_ft, 42);
        assert!(!and_ff, 42);

        // Assertions for OR
        assert!(or_tt, 42);
        assert!(or_tf, 42);
        assert!(or_ft, 42);
        assert!(!or_ff, 42);

        // Assertions for NOT
        assert!(!not_true, 42);
        assert!(not_false, 42);

        // Assertion for complex expression
        assert!(complex_expr, 42);
    }
}

//# publish
module 0x124::vector_mutation {

    use 0x1::vector;

    // This module tests mutably iterating over a vector with a while loop, updating each element to 42.
}

//# run 0x124::vector_mutation::test_vector_update

script {
    fun main() {
        // Initialize a vector with distinct elements
        let v = vector[10, 20, 30, 40];
        let len = vector::length(&v);
        let mut i = 0;
        // Mutable borrow of the vector for iteration
        let vr = &mut v;
        while (i < len) {
            let elem = vector::borrow_mut(vr, i);
            *elem = 42;
            i = i + 1;
        }
        // Verify all elements are updated
        assert!(v == vector[42, 42, 42, 42], 0);
    }
}