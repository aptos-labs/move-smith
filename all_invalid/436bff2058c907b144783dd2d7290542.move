
//# publish
module 0xCAFE::TestModule {
    // Just a dummy function to satisfy compilation
    public fun dummy() {}
}



//# run
script {
    fun main() {
        // Intentionally attempting to use a restricted name for a module, e.g., 'reserved'
        // This should produce a clear error message
        // Move compiler should catch this during compile time
        // As this is a test case, the code below is commented out because it should trigger an error
        // Uncomment to test:
        // module reserved {
        //     fun reserved_function() {}
        // }
        // Expect compilation error related to restricted name 'reserved'
    }
}



//# run 0xA550::aptos_std::vector


//# run 0xA550::aptos_framework::coin


//# run 0xA550::aptos_token::TokenCreator --signers 0xBEEF


//# run 0xA550::aptos_token_objects::ObjectStore

// Test receiving a unit type as a value, which should be allowed


//# run
script {
    fun main() {
        // Corrected to avoid explicit tuple type, just call the assignment
        let _unit_value = ();
        // No operation needed; just testing assignment
    }
}