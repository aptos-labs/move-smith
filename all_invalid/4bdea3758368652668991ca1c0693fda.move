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

    spec minimal_choice_example {
        // let y be the minimal value in get_values greater than 2
        choose min y: u64: exists i: u64 where i < 5 && get_values()[i] > 2 {
            y == get_values()[i]
        };
    }

    // A function demonstrating use of expressions with unresolved names in their spec.
    public fun speculative_ref_example(x: u64): u64 {
        x + 2
    }

    spec speculative_ref_example {
        // Reference to an unresolved name 'z' (not yet bound during parsing).
        ensures result == x + 2; // x is bound, but let's try referencing 'z'
        // The next line references 'z', which is not declared anywhere
        // This exercises unresolved name handling in specs.
        ensures z > 0 ==> result > 2;
    }

    // A function with an update clause in specification.
    public fun update_clause_example(x: &mut u64) {
        *x = *x + 10;
    }

    spec update_clause_example {
        // Use the old value of *x and an update clause
        update *x = old(*x) + 10;
        ensures *x == old(*x) + 10;
    }

    // "Runner" method to test all functions above on-chain.
    public fun run_all() {
        let mut y = 10u64;
        let _v = Self::minimal_choice_example();
        let _z = Self::speculative_ref_example(15);
        Self::update_clause_example(&mut y);
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
        let mut val = 100u64;
        0xCAFE::ChoiceQuantifierTest::update_clause_example(&mut val);
    }
}

// Featurres:
// 7d659b239afc3a6eb1b7ff0ac8f5c922: Declare choice quantifiers using the syntax 'choose' and specify whether to select minimal elements with 'min'.
// d9d6e7f1900fbbcf402e295c7ef20f6e: Write expressions that may reference names not yet bound during parsing
// 3f21251b015ca290bfdf351bb6dccc09: Define update clauses within specifications.
