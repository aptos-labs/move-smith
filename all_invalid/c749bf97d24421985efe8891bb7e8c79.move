// # publish
address 0xCAFE {
    module Module0 {
        // Public function, should be callable externally via a run command
        public fun public_function(): u64 {
            42
        }

        // Internal (default) function: script main functions must not expose public/package/friend visibility,
        // but module functions can be public for testing here.
        fun internal_helper(): u64 {
            7
        }

        // A function that converts a location's range (start and end positions) to a range of byte positions.
        // We simulate this by accepting start_offset and end_offset and returning a tuple.
        public fun location_range_to_bytes(start_offset: u64, end_offset: u64): (u64, u64) {
            // Assume start_offset and end_offset correspond directly to byte positions for testing.
            (start_offset, end_offset)
        }

        // Runner function that does not require signers or arguments
        public fun runner(): u64 {
            // For test purposes, just call public_function and internal_helper and sum results
            public_function() + internal_helper()
        }
    }
}
// # run 0xCAFE::Module0::runner
// # run 0xCAFE::Module0::location_range_to_bytes --args 10u64 20u64 --signers 0xCAFE

// # publish
// Declare a named address to test named address syntax
address 0xBEEF {
    module Module1 {
        public fun return_magic(): u8 {
            0xFE
        }
    }
}

// # publish
// Declare named address aliases with explicit named_address declarations. 
// This tests referencing modules with named address syntax.
address 0xCAFE {
    // Named address declaration for testing referencing another module by named address syntax.
    named_address BE := 0xBEEF;

    module Module2 {
        // This module references another module via named address BE.
        // We reference 0xBEEF::Module1::return_magic

        public fun call_be_module(): u8 {
            BE::Module1::return_magic()
        }

        public fun runner(): u8 {
            call_be_module()
        }
    }
}
// # run 0xCAFE::Module2::runner

// # run
script {
    // This script has no visibility specifier on its main function (by design).
    // This tests that script functions do NOT have public/package/friend visibility.
    fun main() {
        // Call a module function from within a script
        let x = 0xCAFE::Module0::public_function();
        let y = 0xCAFE::Module2::call_be_module();
        // Do some dummy operations
        let _sum = x + (y as u64);
    }
}

// Featurres:
// d6b18feb62bf10640ad30fdeb701a653: Ensure that script functions do not use public, package, or friend visibility, as scripts must only contain internally visible functions.
// 88b39f65af0c16f5a55e26ae3f405a74: Convert a location's range to a range of byte positions within a source file.
// ed76520c813b9347b95ad8df42fbf757: Reference named address syntax (`address_name::module_name`) to access a module in your Move code if the named address is declared.
