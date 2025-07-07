
//# publish
module 0xDEADBEEF::TestModule {
    // A simple public function to exercise built-in function call with location and name
    public fun call_built_in(location: vector<u8>, function_name: vector<u8>, type_args: vector<@>, args: vector<u128>) {
        // For illustration, just mimic a call, no actual behavior
        // In a real test, this could invoke some native or std built-in
        // For test purpose, this is kept simple
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


// Featurres:
// 5a520cf07a0f696135381fdd5e8fd426: Create a built-in function call with a specified location, name, optional type arguments, and list of expressions as arguments.
// 0b3188b910069a5f4cc923ef2dc33263: Include nested function bodies within spec blocks for detailed specifications.
// 752981d9b3e9a6a13ea7834c2e4b5abe: Verify that the inner function `foo` can correctly shadow and assign to the outer variable `_x` through a lambda parameter.
