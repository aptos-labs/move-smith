//# publish
address 0xCAFE {
    /// Test module with attributes and metadata on module, struct and functions
    /// We will define a UnitTest module with some attributes and metadata
    #[doc = b"This is the UnitTest module for testing metadata and attributes"]
    module UnitTest {
        use std::signer;

        /// Struct with attributes and metadata
        #[store]
        #[key]
        #[doc = b"Test struct to check attributes and metadata"]
        struct TestStruct has store, key {
            value: u64,
        }

        /// Function with attributes, a "runner" function to test locals initialization
        #[inline]
        #[doc = b"Runner function to check uninitialized locals and basic usage"]
        public fun run_local_init(_signer: &signer) {
            // Define some locals without initial assignment
            let a: u8;
            let b: u16;

            // Initialize locals conditionally
            a = 10u8;
            b = (a as u16) * 2;

            // Local not initialized explicitly here but assigned before usage
            let c: u64 = 123;

            // Return nothing explicitly
        }

        /// Runner function with no arguments that can be called to cover function calls
        public fun runner(_signer: &signer) {
            run_local_init(_signer);
        }
    }
}
//# run 0xCAFE::UnitTest::runner --signers 0xCAFE

//# run
script {
    use 0xCAFE::UnitTest;

    fun main(account: signer) {
        // Run the runner function that tests locals initialization and attributes
        UnitTest::runner(&account);
    }
}