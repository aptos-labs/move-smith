//# publish
address 0xCAFE {
    #[pragma(author = b"AptosTest", version = 1u8, tested = true)]
    module TestPragmaAndGas {
        // Public struct for demonstration
        struct Dummy has copy, drop {}

        // A function that returns no value (unit type)
        public fun do_nothing(): () {
            // Nothing here; returns unit
        }

        // Another function returning unit, takes one argument
        public fun takes_dummy(_d: Dummy): () {
            // Does nothing, returns unit
        }

        // Internal function with infinite loop.
        fun loop_forever() {
            let x = 0u64;
            // Intentionally infinite loop to consume gas
            while (true) {
                let _ = x + 1;
            }
        }

        // A public runner to call infinite loop for test run.
        public fun runner_loop_forever(): () {
            // Call the internal function to cause infinite loop
            loop_forever();
        }

        // A function to test unit return
        public fun test_unit_return(): () {
            let d = Dummy {};
            do_nothing();
            takes_dummy(d);
        }
    }
}

//# run 0xCAFE::TestPragmaAndGas::test_unit_return --signers 0xCAFE

//# run 0xCAFE::TestPragmaAndGas::runner_loop_forever --signers 0xCAFE

//# run
script {
    fun main(account: &signer) {
        // Script with a unit-return function; does nothing.
    }
}

//# run
script {
    fun main(account: &signer) {
        // Explicit call to a unit-return function in the module
        0xCAFE::TestPragmaAndGas::do_nothing();
    }
}

// Featurres:
// 5e8718f398ecaa6b846b41df1b08ebe6: Define pragma properties with comma-separated key-value pairs within the '#[pragma]' annotation.
// 2b95d63253347d971b7a478f76be295d: Test that executing an infinite loop consumes gas until it runs out and causes a transaction failure.
// 51e3106c44fe63a72d5df881bff4490e: Declare functions that return no values (unit type)
