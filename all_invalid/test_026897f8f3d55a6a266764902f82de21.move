//# publish
module 0xA11c::LambdaTest {
    // Inline function that calls the lambda `g` with `a` and `b`, returns the result
    //# publish
    inline fun call_lambda(g: |u128, u128| u128, a: u128, b: u128): u128 {
        g(a, b)
    }

    // Function to test that `call_lambda` properly invokes the lambda with correct arguments
    public fun test() {
        let result = call_lambda(|x, y| x + y, 50u128, 70u128);
        assert!(result == 120u128, 0);
    }
}

//# run 0xA11c::LambdaTest::test

//# run
script {
    // Constants and references to test resource and constant semantics
    const CONST_VAL: u8 = 255;
    const DATA: vector<u8> = b"move";

    fun verify() {
        // Check constants directly
        assert!(CONST_VAL == 255, 42);
        assert!(DATA == b"move", 42);

        // Check references dereferencing constants - should be equal to constant values
        assert!(*&CONST_VAL == 255, 42);
        assert!(*&DATA == b"move", 42);

        // Mutable borrow and mutation of local copy (not constants)
        let mut local_const = &CONST_VAL;
        // *local_const = 100; // Uncomment to test mutable borrow on local (should fail if tried directly)
        // But in move, references to constants cannot be mutated, so simulating mutation by local variable
        let mut local_data = DATA;
        local_data = b"done".to_vec();
        assert!(local_data == b"done", 42);

        // Confirm original constants are unaffected
        assert!(CONST_VAL == 255, 42);
        assert!(DATA == b"move", 42);
    }
}