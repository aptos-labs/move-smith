
//# publish
module 0xCAFE::TestModule {
}

 
//# run
script {
    fun test_function_visibility() {
        // Function with public visibility
        public fun public_func() {
            // do nothing
        }

        // Function with private visibility (default)
        fun private_func() {
            // do nothing
        }
    }
}

 
//# run 0xCAFE::test_function_visibility


//# run
script {
    fun test_nested_loops() {
        let counter = 0;

        // Outer for loop
        for i in 0..5 {
            // Inner while loop
            let inner_counter = 0;
            while inner_counter < 3 {
                counter = counter + 1;
                inner_counter = inner_counter + 1;
            }
        }

        // Check the value of counter should be 5 * 3 = 15
        // No assertion here, just executing to test control flow
    }
}
 
//# run 0xCAFE::test_nested_loops


//# run
script {
    fun test_for_loop_range() {
        let sum = 0;
        for i in 0..10 {
            sum = sum + i;
        }
        // The value of sum should be 45 (0+1+2+...+9)
        // No assertion; just test loop execution
    }
}
 
//# run 0xCAFE::test_for_loop_range

// Featurres:
// 71b968922f8d2301ebac449cae520150: Declare a function within a script with a valid name and body, and enforce visibility restrictions.
// 9307adeeb1968dd3002e2f6a7a5b46d8: Test that nested for and while loops execute correctly and update variables as expected.
// d3fa72cc69505d29275ee408acad95a3: Test that a for loop with a range (0..10) executes without errors in a script.
