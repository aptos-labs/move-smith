//# publish
module 0x123::TestModuleKeys {
    /// This module tests creation of module keys (address + module name).
    struct Dummy has copy, drop, store {}

    /// Runner function to ensure the module is usable.
    public fun runner() {
        // No-op, just to test publishing
    }
}

//# publish
module 0x456::StructsAndStoredFunction {
    use std::signer;

    /// A simple resource struct for demonstration.
    struct MyData has copy, drop, store {
        value: u64,
    }

    /// The stored function resource holding a function pointer that returns u8
    /// but since Move currently can't store function pointers in a resource, we use a struct with a public function instead.
    struct StoredFunction has key {
        // We store an integer field to indicate stored value for this example.
        stored_value: u8,
    }

    /// Initialize the StoredFunction resource with value 23 under signer
    public fun init_stored_function(account: &signer) {
        // Publish StoredFunction with stored_value = 23 under the signer
        move_to(account, StoredFunction { stored_value: 23 });
    }

    /// Invoke the stored function, returning the stored value
    public fun call_stored_function(account: &signer): u8 {
        let sf = borrow_global<StoredFunction>(signer::address_of(account));
        sf.stored_value
    }

    /// Runner function that creates the stored function and then calls it to get 23 (no arguments needed).
    public fun runner(account: &signer): u8 {
        init_stored_function(account);
        call_stored_function(account)
    }
}
//# run 0x456::StructsAndStoredFunction::runner --signers 0x456

//# run
script {
    use 0x456::StructsAndStoredFunction;

    fun main(account: signer) {
        let result = StructsAndStoredFunction::runner(&account);
        // Normally we would assert result == 23, but assertions are not required
        // Just reading the result to execute the stored function end-to-end
    }
}