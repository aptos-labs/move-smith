// # publish
address 0xCAFE {
    module SpecChecker {
        use std::signer;
        use std::vector;

        /// Spec struct to mimic specification annotations presence
        struct Spec has copy, drop, store {
            marker: u8,
        }

        /// Internal struct to test resource acquisition environment
        struct AcquiredResource has key, store {
            dummy: u64,
        }

        /// A resource to be acquired to test compiler environment acquisitions
        struct AcquiredResource2 has key, store {
            val: u8,
        }

        /// Function that declares it acquires AcquiredResource from storage
        public fun acquire_resource(s: &signer) {
            // Emulate acquiring AcquiredResource resource -- this declares resource in environment
            move_to<AcquiredResource>(copy *s, AcquiredResource { dummy: 123 });
        }

        /// Function that acquires two different resources
        public fun acquire_two(s: &signer) {
            move_to<AcquiredResource>(copy *s, AcquiredResource { dummy: 456 });
            move_to<AcquiredResource2>(copy *s, AcquiredResource2 { val: 7 });
        }

        /// Runner function without arguments to run above acquires
        public fun runner(s: &signer) {
            acquire_resource(s);
            acquire_two(s);
        }

        /// Dummy function to simulate retrieving all registered external expression checkers
        public fun get_external_expression_checkers() : vector<u8> {
            // Return a dummy vector to simulate checkers
            vector::empty<u8>()
        }
    }
}
 //# run 0xCAFE::SpecChecker::runner --signers 0xCAFE

//# run
script {
    use std::signer;
    use 0xCAFE::SpecChecker;

    fun main(s: signer) {
        // Run runner function that exercises acquiring resources in function environments
        SpecChecker::runner(&s);

        // Call function that returns registered external expression checkers
        let checkers = SpecChecker::get_external_expression_checkers();
        // do nothing with checkers per instruction
    }
}

// Featurres:
// b2cc35d56ab7f2b6f53c0e9c0ea3e065: Include only modules with specification annotations such as 'Spec' or 'Use' in the source code.
// 14a417963e5cadd10041053181e8b6a8: Declare acquired resources in function environments that can be inspected by compiler checks
// b483f22d87a652baafe2edd66436de65: Retrieve all registered external expression checkers for the current module.
