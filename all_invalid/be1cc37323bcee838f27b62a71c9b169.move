
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
        let resource_ref = borrow_global<u64>(&account_address);
        *resource_ref
    }
}



//# run
script {
    use 0xCAFE::TestModule;
    use std::signer;

    fun main(signer: &signer) {
        let account_address = signer::address_of(signer);
        // Create resource
        TestModule::create_resource(signer);
    }
} --signers 0x123


//# run 0xCAFE::TestModule::access_resource --signers 0x123 --args 0x123