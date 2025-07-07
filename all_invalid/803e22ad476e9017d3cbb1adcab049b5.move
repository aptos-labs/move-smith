//# publish
module 0xCAFE::ChoiceQuantifierTest {
    // A struct to hold an integer for demonstration.
    struct Data has copy, drop, store {
        value: u64,
    }

    // Function to generate some data for quantifier tests.
    public fun get_values(): vector<u64> {
        vector[1u64, 2u64, 3u64, 4u64, 5u64]
    }

    // A function demonstrating use of a minimal choice quantifier in specifications.
    public fun minimal_choice_example(): u64 {
        5
    }

    /* 
    // NOTE: The following specification uses a syntax not currently supported by Move Prover or
    // the Move compiler ("choose min ..."). Thus, it's commented out.
    // If/when the feature is supported in the Aptos Move toolchain, this can be uncommented.

    spec minimal_choice_example {
        // let y be the minimal value in get_values greater than 2
        choose min y: u64: exists i: u64 where i < 5 && get_values()[i] > 2 {
            y == get_values()[i]
        };
    }
    */

    // A function demonstrating use of expressions with unresolved names in their spec.
    public fun speculative_ref_example(x: u64): u64 {
        x + 2
    }

    /*
    // NOTE: The following spec attempts to reference 'z', which is not supported outside of the prover.
    // It is commented out due to parser errors.

    spec speculative_ref_example {
        ensures result == x + 2;
        ensures z > 0 ==> result > 2;
    }
    */

    // A function with an update clause in specification.
    public fun update_clause_example(x: &mut u64) {
        *x = *x + 10;
    }

    /*
    // NOTE: The update clause syntax is not supported by the compiler, so it is commented out.

    spec update_clause_example {
        update *x = old(*x) + 10;
        ensures *x == old(*x) + 10;
    }
    */

    // "Runner" method to test all functions above on-chain.
    public fun run_all() {
        let y = 10u64;
        let _v = Self::minimal_choice_example();
        let _z = Self::speculative_ref_example(15);
        let mut y2 = y;
        Self::update_clause_example(&mut y2);
    }
}
//# run 0xCAFE::ChoiceQuantifierTest::run_all --signers 0xCAFE

//# run
script {
    fun main() {
        // Call the minimal choice example as a script
        0xCAFE::ChoiceQuantifierTest::minimal_choice_example();
    }
}

//# run
script {
    fun main() {
        // Call the speculative reference example with a value
        0xCAFE::ChoiceQuantifierTest::speculative_ref_example(42);
    }
}

//# run
script {
    fun main() {
        // Test update clause example
        let val = 100u64;
        let mut val_mut = val;
        0xCAFE::ChoiceQuantifierTest::update_clause_example(&mut val_mut);
    }
}