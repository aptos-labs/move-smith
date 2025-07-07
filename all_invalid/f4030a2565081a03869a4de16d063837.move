//# publish
module 0xCAFE::IdentifiersAndAbilities {
    use std::signer;

    /// Define a struct with specific AbilitySet: copy, drop, store, key
    struct MyResource has copy, drop, store, key {
        x: u64,
    }

    /// A private function that cannot be called from scripts
    fun private_internal_function(): u64 {
        42u64
    }

    /// A public function to call the private function internally and return its result
    public fun call_private_internal_function(): u64 {
        private_internal_function()
    }

    /// Public function to create and move the resource to signer address
    public fun create_resource(account: &signer) {
        let resource = MyResource { x: 10u64 };
        move_to(account, resource);
    }

    /// Public function to read the resource from storage
    public fun read_resource(addr: address): u64 {
        let resource_ref = borrow_global<MyResource>(addr);
        resource_ref.x
    }

    /// Runner function to test the create_resource and call_private_internal_function
    public fun runner(account: &signer) {
        create_resource(account);
        let val = call_private_internal_function();
        // use val to prevent compiler warnings, but no assert needed
        let _ = val;
    }
}
//# run 0xCAFE::IdentifiersAndAbilities::runner --signers 0xCAFE

//# run
script {
    use std::signer;
    use 0xCAFE::IdentifiersAndAbilities;

    fun main(account: signer) {
        // Create the resource in account storage
        IdentifiersAndAbilities::create_resource(&account);

        // Read the resource back
        let value = IdentifiersAndAbilities::read_resource(signer::address_of(&account));
        // Use value to avoid unused variable warning
        let _ = value;

        // Call function that internally calls private function
        let result = IdentifiersAndAbilities::call_private_internal_function();
        let _ = result;
    }
}

// Featurres:
// c50322efa66d5a827bf3371f8bffc792: Define and use specific identifiers (such as variable or function names) in Move code.
// d6650481eccee5becbae263795cef757: Use AbilitySet to specify a collection of abilities for a Move resource or type.
// 15ce9e7f9305f9876b822522ee6ab7ad: Prevent non-public functions from being called from scripts.
