//# publish
module 0x1::TestModule {
    // A simple function to compute sum of three local variables
    public fun main(a: u64, b: u64, c: u64): bool {
        let sum = a + b + c;
        // Assert that sum is as expected for testing purposes
        // Here, for example, check if sum equals a + b + c (which is trivially true)
        assert!(sum == a + b + c, 42);
        true
    }

    // Additional runner function for testing (no arguments)
    public fun run() {
        // Call main with sample values
        Self::main(10, 20, 30);
    }

    // Function demonstrating pattern matching with '..' syntax
    public fun match_range(n: u64): u64 {
        match n {
            ..=10 => 1,
            11..=20 => 2,
            _ => 3,
        }
    }
}
//# run 0x1::TestModule::run

//# publish
module 0x2::DependencyModule {
    // No specific functions needed for this dependency as per the test requirements
    public fun dummy() {}
}
//# run 0x2::DependencyModule::dummy

//# publish
module 0x3::TargetModule {
    // Placeholder module to ensure target path does not intersect with dependencies
    public fun target_function() {}
}
//# run 0x3::TargetModule::target_function

//# publish
module 0x1::TestRunner {
    use 0x1::TestModule;

    // Runner function to invoke main with specific arguments
    public fun run_test() {
        TestModule::main(3, 4, 5);
        // Call match_range with a value to test pattern matching
        let _ = TestModule::match_range(15);
    }
}
//# run 0x1::TestRunner::run_test --signers 0x1