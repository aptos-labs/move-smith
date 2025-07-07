
//# publish
module 0xCAFE::FunctionParameterTest {
    // Aptos Move currently does not support function types or passing anonymous functions directly.
    // Instead, simulate by passing a wrapper function or use generics with functors (not supported yet).

    // Workaround: define the lambda function separately and pass it by calling directly.

    public fun runner() {
        let result = Self::call_with_lambda(8u8);
        let _ = result;
    }

    // Since Move does NOT support function types as parameters, define the function here:
    public fun lambda(x: u8): u8 {
        x + 42u8
    }

    public fun call_with_lambda(v: u8): u8 {
        // call the lambda directly
        Self::lambda(v)
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
        // This aborts with 101 as intended
        // The branching short-circuits the division and prevents panic
        assert!(divisor != 0 && 42 / divisor > 1, 101);
    }
}



//# run 0xCAFE::AssertTest::runner_success



//# run 0xCAFE::AssertTest::runner_abort_div_zero



//# publish
module 0xCAFE::ModuleAnalyzer {
    use std::debug;

    public fun runner() {
        // No illegal copy of primitive literal, just print message
        debug::print(&b"ModuleAnalyzer running\n");
    }
}



//# run 0xCAFE::ModuleAnalyzer::runner
