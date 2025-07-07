//# publish
module 0xA11E::InlineFunctionTest {
    // Inline function that takes two function references and additional arguments,
    // calls the functions with the arguments, and returns their sum
    //@ inline
    inline fun compute_sum(
        f: |u64, u64| u64,
        g: |u64, u64| u64,
        a: u64,
        b: u64
    ): u64 {
        f(a, b) + g(a, b)
    }

    // Runner function to test compute_sum
    public fun run_compute_sum(): u64 {
        // Functions to pass: one adds, one multiplies
        let add_fn = |x: u64, y: u64| { x + y };
        let mul_fn = |x: u64, y: u64| { x * y };
        compute_sum(add_fn, mul_fn, 7, 3)
    }
}

//# run 0xA11E::InlineFunctionTest::run_compute_sum

//# run
script {
    // Test logical operators with more complex expressions
    assert!((true && (false || true)) == true, 200);
    assert!((false || (false && true)) == false, 201);
    assert!(!(!true) == true, 202);
    assert!(!(true && false) == true == false, 203); // Double negation, should be false
    assert!((!(false || true) && true) == false, 204);
    assert!(((true || false) && !(false)) == true, 205);
}