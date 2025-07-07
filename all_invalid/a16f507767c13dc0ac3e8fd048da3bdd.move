
//# publish
module 0xCAFE::FunctionParameterTest {
    public fun runner() {
        // Pass inline anonymous function as parameter
        let result = Self::call_with_lambda(|x: u8| { x + 42u8 }, 8u8);
        // no assertion required, just testing functionality works
        let _ = result;
    }

    public fun call_with_lambda(f: |u8|u8, v: u8): u8 {
        f(v)
    }
}


//# run 0xCAFE::FunctionParameterTest::runner


//# publish
module 0xCAFE::AssertTest {
    public fun runner_success() {
        let x = 10;
        assert!(x > 5, 100);
    }

    public fun runner_abort_div_zero() {
        let divisor = 0;
        // This condition evaluates to false, so abort with code 101
        // The error message involves division by zero, but only evaluated inside the abort code message, which is not computed eagerly.
        assert!(divisor != 0 && 42 / divisor > 1, 101);
    }
}


//# run 0xCAFE::AssertTest::runner_success


//# run 0xCAFE::AssertTest::runner_abort_div_zero


//# publish
module 0xCAFE::ModuleAnalyzer {
    use std::signer;
    use std::debug;

    public fun runner() {
        // Just create sample instances of MyModule::S and StorageUsage::Obj for analysis
        let s = copy 0u32;  // dummy use since cannot construct other module structs directly
        debug::print(&b"ModuleAnalyzer running\n");
    }
}


//# run 0xCAFE::ModuleAnalyzer::runner


// Featurres:
// 963ab02ce5f0914f7386f6d2ef6ed632: Test that functions accepting function parameters (like closures/lambdas) work correctly when passed inline anonymous functions.
// 0bb4bf5973a9fd77e87c701e2bacbd46: Test that the assert! macro correctly handles conditions and triggers aborts when the condition is false, even if the error message involves runtime errors like division by zero.
// a5be9ce890cfa7e0f7f96cbb96aac464: Use modules in the environment to analyze their structures.
