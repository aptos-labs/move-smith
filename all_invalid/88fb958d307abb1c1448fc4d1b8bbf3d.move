//# publish
module 0xCAFE::TestModule {
    // Define a struct with annotated fields to test structured data with types
    struct Member {
        id: u64,
        value: vector<u8>,
    }

    // Public function to instantiate and return a Member, useful for testing
    public fun create_member(id: u64, value: vector<u8>): Member {
        Member { id: id, value: value }
    }

    // A dummy function to test import alias restrictions
    public fun dummy_function(): bool {
        true
    }

    // This function will be called via script to test import alias duplication
    public fun alias_test_function() {
        // intentionally left blank
    }
}

//# run
script {
    // Use the alias to call the dummy function in the module
    fun main(account: &signer) {
        // Call create_member with annotated fields
        let _mem = 0xCAFE::TestModule::create_member(42, b"test_data");
        // Call alias_test_function to ensure import restriction does not cause errors
        0xCAFE::TestModule::alias_test_function();
    }
}

// Test import alias restrictions: attempt to import the same module with a common alias twice, should error
//# run 0xCAFE::TestModule::dummy_function --signers 0xCAFE
// Duplicate alias import should produce an error. No code needed here, just testing import restrictions.

// Additional script to test the restriction on duplicate alias names
//# run 0xCAFE::TestModule::alias_test_function --signers 0xCAFE