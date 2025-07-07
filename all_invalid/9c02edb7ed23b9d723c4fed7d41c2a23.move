
//# publish
module 0xCAFE::TestModule {
    // Define a simple function with a valid name, not starting with underscore
    public fun valid_function(): bool {
        true
    }

    // Define a function to be called in the script
    public fun runner() {
        // no-op or just return
    }
}


//# run 0xCAFE::TestModule::runner --signers 0xCAFE


//# publish
module 0xABCD::AnotherModule {
    // Define another function
    public fun another_valid_function(): u64 {
        42
    }
}


//# run 0xABCD::AnotherModule::another_valid_function --signers 0xABCD


//# run 0xCAFE::TestModule::valid_function --signers 0xCAFE

// Define a script to interact with the modules

//# run
script {
    fun main() {
        // Call functions from modules
        let _ = 0xCAFE::TestModule::valid_function();
        let _ = 0xABCD::AnotherModule::another_valid_function();
    }
}

// Featurres:
// d4dccfeee89ce45d6510a84b34380f76: Be warned that a spec module without an associated target module in the same compilation unit will result in a compilation error
// 2da1f2b35c702c52170a944bcb8b662f: Define function names that do not start with an underscore ('_').
// 1df11cc43eeec814df9873a5318f87a8: Ensure modules pass the bytecode verifier before publishing or executing.
