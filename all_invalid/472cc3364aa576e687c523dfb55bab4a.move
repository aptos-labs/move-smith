
//# publish
module 0xCAFE::test_module {
    // A constant to check the module magic number
    const MODULE_MAGIC: u32 = 0xCADE;

    // Public function to return the magic number, to verify module presence
    public fun get_magic(): u32 {
        MODULE_MAGIC
    }

    // A function that performs addition and intentionally aborts if sum exceeds a threshold
    public fun add_or_abort(x: u64, y: u64): u64 {
        let sum = x + y;
        if (sum > 1000) {
            abort 42;
        }
        sum
    }

    // A private function for testing access restrictions
    fun private_function(): bool {
        true
    }

    // A friend function to demonstrate access between modules
    public fun friend_function(): bool {
        true
    }
}



//# run
script {
    // Since Move scripts don't directly load modules by code, simulate checking module presence
    // Typically, in test, you'd retrieve the module info or call a public function
    // here, just assume the module is available.
}

 

//# run 0xCAFE::test_module::get_magic --signers 0xCAFE



//# run 0xCAFE::test_module::add_or_abort --signers 0xCAFE --args 500u64 400u64



//# run 0xCAFE::test_module::add_or_abort --signers 0xCAFE --args 600u64 500u64



//# run 0xCAFE::test_module::private_function --signers 0xCAFE
// Expect failure: cannot call private function outside of module



//# run 0xCAFE::test_module::friend_function --signers 0xCAFE
// Expect success: public function, accessible outside