//# publish
module 0xA::test_module {
    fun modify_and_check() {
        let x = 5;
        let mut y = 10;

        if (false) {
            y = move x;
            y;
            return ()
        };
        y;

        assert!(x == 5, 43);
    }

    fun approximate_test() {
        let a = 100u256;
        let b = 102u256;
        let precision = 2;

        // This should pass: difference within 2%
        assert_approx_the_same(a, b, precision);

        let c = 1000u256;
        let d = 1050u256;
        let big_precision = 3;

        // This should fail: difference more than 3%
        // In a real test environment you'd handle the assertion failure,
        // but for illustration, we call it.
        // Uncomment if you want to run failing test
        // assert_approx_the_same(c, d, big_precision);
    }

    public fun runner() {
        modify_and_check();
        approximate_test();
    }
}

//# run 0xA::test_module::runner