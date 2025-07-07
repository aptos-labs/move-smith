//# publish
module 0xabcdeff::closure_test {
    // Define a function that creates a nested closure to compute a sum with three parameters
    public fun test_multi_param_closures() {
        // Outer closure takes 'a', returns a closure expecting 'b'
        let f = |a| |b| |c| a + b + c;

        // Invoke the nested closures with specific arguments and check the sum
        let result = f(10)(20)(30);
        assert!(result == 60);
    }

    // Define a runner function to test different sums with different inputs
    public fun run_all() {
        // Test with different values to ensure closure interaction
        let sum1 = (|a| |b| |c| a + b + c)(1)(2)(3);
        assert!(sum1 == 6);
        
        let sum2 = (|a| |b| |c| a * b + c)(2)(4)(3);
        assert!(sum2 == 11);
        
        let sum3 = (|a| |b| |c| a + b * c)(5)(2)(3);
        assert!(sum3 == 14);
    }
}
//# run 0xabcdeff::closure_test::test_multi_param_closures
//# run 0xabcdeff::closure_test::run_all