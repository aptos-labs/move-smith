// This transactional test exercises:
// 1. Merge specification modules into the program before further processing.
// 2. Verify sequential variable assignments and copying produce expected struct.
// 3. Define functions for verification with compliance to module docs and compiler rules.


//# publish
module 0xCAFE::SpecModule {
    /// Spec declaration module to be merged (simulation).
    spec module {
        resource struct SpecResource {
            dummy_field: u64;
        }

        fun dummy_spec_fun(): u64 {
            42
        }
    }
}

//# publish
module 0xCAFE::DataModule {
    use std::signer;

    /// A simple struct with two fields.
    struct DataStruct has copy, drop, store {
        a: u64,
        b: u64,
    }

    /// Constructs a DataStruct from two u64 values.
    public fun new_data(a: u64, b: u64): DataStruct {
        DataStruct { a, b }
    }

    /// Sequentially copies values and assigns them to local variables.
    /// Returns a DataStruct that should equal the original input.
    public fun sequential_copy(input: DataStruct): DataStruct {
        let mut x = input.a;
        let mut y = input.b;
        // Sequential assignments keeping values
        let temp_x = x;
        x = y;
        y = temp_x;
        // Swap back to original state
        let temp = x;
        x = y;
        y = temp;
        DataStruct { a: x, b: y }
    }

    /// A runner function that creates a DataStruct and calls sequential_copy on it.
    /// Returns the resulting DataStruct.
    public fun runner(): DataStruct {
        let original = new_data(7, 11);
        sequential_copy(original)
    }
}
 //# run 0xCAFE::DataModule::runner


//# publish
module 0xCAFE::VerifyModule {
    /// Module to define functions that comply with compiler and are suitable for verification.
    /// This module includes a pure function and a function requiring a signer.

    use std::signer;

    /// Pure function that returns the sum of two numbers.
    public fun pure_sum(x: u64, y: u64): u64 {
        x + y
    }

    /// Function that requires a signer and returns the signer's address as u64.
    public fun signer_address(s: &signer): address {
        signer::address_of(s)
    }

    /// Runner function to call pure_sum with fixed literals.
    public fun run_pure_sum(): u64 {
        pure_sum(100, 200)
    }
}
 //# run 0xCAFE::VerifyModule::run_pure_sum
 //# run 0xCAFE::VerifyModule::signer_address --signers 0xCAFE


//# run
script {
    use 0xCAFE::DataModule;
    use std::debug;

    fun main() {
        // Create the struct and test sequential_copy inline as script
        let original = DataModule::new_data(42, 99);
        let copied = DataModule::sequential_copy(original);
        debug::print(&copied);
    }
}

// Featurres:
// 4f191e6be768568f6249de18157b6c37: Merge specification modules into the program before further processing.
// 2b278529463232504c0d1bfc362f60dd: Verify that a sequence of variable assignments correctly retains the original values and results in the expected struct after sequential copying.
// 3b40bd96aea75ce70537ab293569a98b: Define functions that should be verified for compliance with module documentation and compiler rules.
