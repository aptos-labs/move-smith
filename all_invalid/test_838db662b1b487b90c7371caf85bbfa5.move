//# publish
module 0xabcde::closure_test {
    // Helper function to perform addition
    fun add4(a: u8, b: u8, c: u8, d: u8): u8 {
        a + b + c + d
    }

    public fun test_closures() {
        // Closure capturing local variables and no args
        let base = 5;
        let f1 = || add4(base, 1, 1, 1);
        assert!(f1() == 8);

        // Closure with one argument passing to function
        let f2 = |x| add4(x, 2, 2, 2);
        assert!(f2(3) == 9);

        // Closure with multiple arguments, capturing nothing
        let f3 = |x, y| add4(x, y, 3, 3);
        assert!(f3(2, 4) == 12);

        // Closure capturing outer variable and passing additional args
        let multiplier = 2;
        let f4 = |x| add4(x, multiplier, 0, 0);
        assert!(f4(4) == 6);

        // Define a function calling closure with captured variable
        fun run_closure_with_capture(c: &signer) {
            let captured = "outer";
            let f5 = || {
                // We simulate capturing by closure environment
                assert!(*captured == "outer");
            };
            f5();
        }
        run_closure_with_capture(&signer);

        // Chained closure calls
        let outer = || {
            let inner = || 42u8;
            inner()
        };
        assert!(outer() == 42);

        // Closure with multiple captures and arguments
        let v1 = 10;
        let v2 = 20;
        let complex_closure = |x, y| {
            // capturing v1 and v2
            add4(x, v1, y, v2)
        };
        assert!(complex_closure(1, 2) == 33);
    }
}

//# run 0xabcde::closure_test::test_closures