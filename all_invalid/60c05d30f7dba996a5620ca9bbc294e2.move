//# publish
module 0x1::ModuleA {
    use std::debug;

    // A simple struct
    struct Data has store {
        value: u64,
    }

    public fun runner() {
        let id = identifier::from_bytes(b"ModuleA");
        // Print the module's identifier (Address + Module name) using debug::print
        debug::print(&id);
    }
}

//# run 0x1::ModuleA::runner --signers 0x1

//# publish
module 0x2::ModuleB {
    use std::debug;
    use std::identifier;

    public fun runner() {
        // Accessing ModuleA's identifier by specifying address and module name
        let module_a_id = identifier::from_bytes(b"ModuleA");
        let addr = @0x1;

        // Compose a representation combining address and module name to debug print
        // We'll just print the tuple (address, module_name_identifier)
        debug::print(&(addr, module_a_id));
    }
}

//# run 0x2::ModuleB::runner --signers 0x2

//# run
script {
    use std::debug;
    use std::identifier;

    fun main(account: signer) {
        // Create an identifier from bytes
        let id = identifier::from_bytes(b"ScriptID");

        // Print the identifier directly
        debug::print(&id);

        // Print a tuple of primitive and identifier to test complex debug printing
        debug::print(&(123u64, id));
    }
}