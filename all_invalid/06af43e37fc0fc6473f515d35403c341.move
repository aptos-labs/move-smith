//# publish
module 0xDEADBEEF::TestModule {
    // A simple public function to exercise built-in function call with location and name
    public fun call_built_in(location: vector<u8>, function_name: vector<u8>, type_args: vector<@>, args: vector<u128>) {
        // For illustration, just mimic a call, no actual behavior
        // In a real test, this could invoke some native or std built-in
        let _ = (location, function_name, type_args, args);
    }

    // Function with nested spec block involving detailed verification
    public fun nested_spec_sample() {
        // Outer variable _x
        let _x = 42u64;

        // Spec block to specify behavior
        spec {
            // Inner function to shadow and assign to _x
            fun foo(x: &mut u64) {
                // shadow _x inside foo
                let _x = 100u64;
                *x = *x + _x;
            }

            // Run the inner function, passing _x by mutable reference
            foo(&mut _x);
        };
        // The expected _x should be 142 now
        assert!(_x == 142, 999);
    }

    // Runner function for the above test case
    public fun run_nested_spec_sample() {
        nested_spec_sample();
    }
}


//# run 0xDEADBEEF::TestModule::call_built_in --args b"location" b"func_name" [] 123456789u128 987654321u128


//# run 0xDEADBEEF::TestModule::nested_spec_sample
