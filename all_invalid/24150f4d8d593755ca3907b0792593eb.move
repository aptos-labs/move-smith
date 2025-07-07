
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



//# run
script {
    fun main() {
        // Call functions from modules
        let _ = 0xCAFE::TestModule::valid_function();
        let _ = 0xABCD::AnotherModule::another_valid_function();
    }
}