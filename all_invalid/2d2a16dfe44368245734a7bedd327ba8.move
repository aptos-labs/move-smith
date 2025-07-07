// Feature 1: Use of phantom type parameters
// Feature 2: Use of attributes (known and unknown)
// Feature 3: Filtered publication (simulated by publishing several modules at different addresses)
// Feature 4: Use of Spec and variable bindings
// Feature 5: Out-of-gas test in a script loop

// We will use test accounts at 0x1, 0x2, 0x3

/////////////////////////////////////////
//# publish
module 0x1::PhantomModule<phantom T, U> {
    // #[test_only]
    /// Uses both a known attribute and an unknown attribute
    #[test_only]
    #[my_custom_attr]
    public fun runner() : u8 {
        42u8
    }
}

//# run 0x1::PhantomModule::runner --signers 0x1

/////////////////////////////////////////
//# publish
address 0x2 {
    module SpecModule {
        // Feature 4: Spec expressions and variable bindings

        fun factorial(n: u64): u64 acquires SpecFact {
            let acc = 1u64;
            let i = 1u64;
            while (i <= n) {
                acc = acc * i;
                i = i + 1;
            };
            acc
        }

        // "Runner" function for testing
        public fun runner(): u64 {
            factorial(5)
        }

        spec module {
            // variable binding in global spec context
            let max_fact = 20;
        }

        spec fun factorial {
            // binds for parameter and some simple expression spec
            ensures result >= 1;
        }
    }
}
//# run 0x2::SpecModule::runner --signers 0x2

/////////////////////////////////////////
//# publish
address 0x3 {
    // Simulate filtered module for compilation tests
    #[filter_me]
    module FilteredModule {
        public fun runner(): bool {
            true
        }
    }
}
//# run 0x3::FilteredModule::runner --signers 0x3

/////////////////////////////////////////
//# run
script {
    use std::signer;

    /// Feature 5: Out-of-gas test with an infinite loop
    fun main(account: &signer) {
        let x = 0u8;
        let i = 0u64;
        // Intentionally unbounded loop to run out of gas
        while (true) {
            i = i + 1;
        }
        // dummy: return i so that the loop isn't eliminated
        i;
    }
}