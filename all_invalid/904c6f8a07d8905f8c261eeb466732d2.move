
//# publish
module 0xCAFE::TestModule {
}


//# run 0xCAFE::TestModule::test_function_visibility
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


//# run 0xCAFE::TestModule::test_function_visibility



//# run 0xCAFE::TestModule::test_nested_loops
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

        // No assertion needed, just execution
    }
}


//# run 0xCAFE::TestModule::test_nested_loops



//# run 0xCAFE::TestModule::test_for_loop_range
script {
    fun test_for_loop_range() {
        let sum = 0;
        for i in 0..10 {
            sum = sum + i;
        }
        // No assertion, just execution
    }
}