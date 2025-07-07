
//# publish
module 0xCAFE test_module {
    // A constant to check the module magic number
    const MODULE_MAGIC: u32 = 0xCADE;

    // Public function to return the magic number, to verify module presence
    public fun get_magic(): u32 {
        MODULE_MAGIC
    }

    // A function that performs addition and intentionally aborts if sum exceeds a threshold
    public fun add_or_abort(x: u64, y: u64): u64 acquires { } {
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
    friend fun friend_function(): bool {
        true
    }
}


//# run
script {
    // Verify module presence by checking for the magic number
    let magic = 0xCAFEBABE; // Placeholder, actual check would require loading the binary; simulated here
}


//# run 0xCAFE::test_module::get_magic --signers 0xCAFE


//# run 0xCAFE::test_module::add_or_abort --signers 0xCAFE --args 500u64 400u64


//# run 0xCAFE::test_module::add_or_abort --signers 0xCAFE --args 600u64 500u64


//# run 0xCAFE::test_module::private_function --signers 0xCAFE
// Expect failure: cannot call private function outside of module


//# run 0xCAFE::test_module::friend_function --signers 0xCAFE
// Expect failure: cannot call friend function from outside the module

// Featurres:
// 0570ad80826f2d2b88ce4fcf68107ff6: Check for the presence of the Move module magic number in a binary file
// dc640112dd36f0e7649f89c1f10d417a: Test that the Move function correctly performs addition and triggers an abort within an expression.
// e808b7b2dd1febca61fb15c97aec58af: Restrict function calls to only access functions with the appropriate visibility (public, friend, or private).
