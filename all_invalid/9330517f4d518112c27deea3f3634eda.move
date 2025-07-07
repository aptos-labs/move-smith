
//# publish
module 0xCAFE::TestModule {
    use std::debug;

    public fun create_resource(account: &signer) {
        let resource = 42;
        // Store a resource under the account address
        move_to(account, resource);
        debug::print(&resource);
    }

    public fun access_resource(account_address: address): u64 {
        let resource_ref = borrow_global::<u64>(&account_address);
        *resource_ref
    }
}


//# run
script {
    use 0xCAFE::TestModule;

    fun main() {
        let account = signer::address_of(&signer);
        // Set up file logging
        let log_file = std::env::var("LOG_FILE").unwrap_or_else(|_| "default_log.txt".to_string());

        // Create resource
        TestModule::create_resource(&signer);
    }
} --signers 0x123 --args


//# run 0xCAFE::TestModule::access_resource --signers 0x123 --args 0x123

// Featurres:
// b9ad8da44435f4a319fe70768091b32a: Omit the colon to default to creating a Name expression with access chain 'One'.
// 062c51c830fe9e6081fde75e5921eab7: Use addresses from the module or script's used addresses for referencing resources and code.
// 56a82df6b40d543d56a4081aa298c444: Set up file logging by specifying a file name from the environment variable.
