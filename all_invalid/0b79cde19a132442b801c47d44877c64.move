// 0xCAFE address will be used throughout the test.

//# publish
module 0xCAFE::TestModule {
    // 1. Define a struct with unique field names and types.
    // 2. Intentionally include a duplicate field name to test handling of duplicates.
    //    Note: The Move compiler will reject duplicate field names, so we show the code, but this is expected to fail compilation.
    struct UniqueFields has copy, drop, store {
        field1: u64,
        field2: bool,
        field3: address,
    }

    /*
    // This duplicate field declaration would cause a compile error. Commented out to keep module publishable.
    struct DuplicateFields has copy, drop, store {
        field1: u64,
        field1: bool, // duplicate - should produce error if uncommented
    }
    */

    /// A function to exercise name bindings with code sequences (blocks of statements).
    public fun name_binding_sequences(account: &signer) {
        let x = 10;
        {
            let x = 20;
            let y = x + 5;
            let z = y * 2;
            // Introduce a new name inside block
            let w = {
                let w_inner = z + 1;
                w_inner
            };
            // Use w to prevent optimization away
            let _dummy = w;
        }
        let _outside = x;
    }

    /// Runner function with no arguments.
    public fun runner(account: &signer) {
        Self::name_binding_sequences(account);
    }

    // 3. Module-level specification block with grouped members.
    spec module {
        constant TEST_CONST: u64 = 42;

        structspec UniqueFields {
            field1: u64;
            field2: bool;
            field3: address;
        }

        fun spec_function() {
            // dummy spec function to exercise grouping
        }
    }
}
//# run 0xCAFE::TestModule::runner --signers 0xCAFE


//# run
script {
    use 0xCAFE::TestModule;

    fun main(account: signer) {
        // Call the runner function to exercise bindings and struct use
        TestModule::runner(&account);
    }
}

// Featurres:
// 7894726ff114d24acb3477d244ca380c: Write code sequences (such as blocks of statements) that may introduce new names and bindings
// 8724f88c2ea37e4a139b3af7d6474e05: Declare struct fields with unique names and types, and handle duplicate field definitions properly.
// b44775bbdd8e5ba940595bad7170c885: Group one or more specification block members inside a module-level spec block
