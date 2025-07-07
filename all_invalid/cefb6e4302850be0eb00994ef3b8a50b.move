// This transactional test is designed for Aptos Move compiler and VM testing.
// It tests forward references, named addresses, and unit names in filenames.

//# publish
address 0xCAFE {
    module ModuleB_Unit2 {
        // module that ModuleA_Unit1 depends on, but defined before it to allow forward referencing

        // Simple function returns 62, called by ModuleA_Unit1
        public fun return_sixty_two(): u64 {
            62u64
        }

        // A runner with no args to test the function directly
        public fun runner(): u64 {
            return_sixty_two()
        }
    }
}
//# run 0xCAFE::ModuleB_Unit2::runner --signers 0xCAFE

//# publish
address 0xCAFE {
    module ModuleA_Unit1 {
        // This module references ModuleB_Unit2 which is now defined above (no forward reference error)
        public fun call_b(): u64 {
            // call function in ModuleB_Unit2
            ModuleB_Unit2::return_sixty_two()
        }

        // A runner function with no args that calls call_b()
        public fun runner(): u64 {
            call_b()
        }
    }
}
//# run 0xCAFE::ModuleA_Unit1::runner --signers 0xCAFE

//# run
script {
    use 0xCAFE::ModuleA_Unit1;

    fun main(_signer: signer) {
        // Call the runner function inside module A that in turn calls module B
        let res = ModuleA_Unit1::runner();
        // Use res in some "experimental" expression to assure parsing binding works
        // For instance, add some literal to it
        let _final: u64 = res + 10u64;
    }
}