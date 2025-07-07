//# publish
module 0xA11::InlineFunctionTest {
    // Define an inline function 'operate' that takes two function parameters 'f' and 'g'
    // Each function takes two u64 arguments and returns a u64
    // 'operate' applies 'f' and 'g' to the arguments and sums their results
    inline fun operate(
        f: |u64, u64| u64,
        g: |u64, u64| u64,
        a: u64,
        b: u64
    ): u64 {
        f(a, b) + g(a, b)
    }

    // Main test function to verify 'operate' with different inline functions
    public fun run_tests() {
        // Define a function that adds the two inputs
        let add_fn = |x: u64, y: u64| x + y;

        // Define a function that multiplies the inputs
        let mul_fn = |x: u64, y: u64| x * y;

        // Call 'operate' with 'add_fn' and 'mul_fn' passing arguments 5 and 10
        let result1 = operate(add_fn, mul_fn, 5, 10);
        // Expected: add_fn(5,10)=15, mul_fn(5,10)=50, sum=65

        // Call 'operate' with 'mul_fn' and 'add_fn' passing arguments 3 and 7
        let result2 = operate(mul_fn, add_fn, 3, 7);
        // Expected: mul_fn(3,7)=21, add_fn(3,7)=10, sum=31

        // Use assertions to verify correctness
        assert!(result1 == 65, 1);
        assert!(result2 == 31, 2);
    }
}

//# run 0xA11::InlineFunctionTest::run_tests