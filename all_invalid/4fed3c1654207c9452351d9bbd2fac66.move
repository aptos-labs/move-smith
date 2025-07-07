
//# publish
module 0xCAFE::SpecModule {

    // Define a struct with invariants and annotations
    #[pragma(meta: "important")]
    struct Data {
        #[spec_property(precondition: "value >= 0")]
        #[spec_property(postcondition: "result >= old(value)")]
        value: u64,
    }

    // Define a function with precondition, postcondition, and spec block
    public fun set_value(data: &mut Data, new_value: u64) {
        // Spec block
        #[spec]
        {
            // Preconditions: new_value >= 0 (implicitly true for u64)
            // Postconditions are specified using move's ensures, but syntax is illustrative
            // The actual Move spec annotations would go here
        }
        data.value = new_value;
    }


    // Define a function with invariants
    public fun increment(data: &mut Data) {
        // Invariant: data.value >= 0 (always true for u64)
        data.value = data.value + 1;
    }
}


//# run 0xCAFE::SpecModule::set_value --signers 0xCAFE --args 10u64

//# run 0xCAFE::SpecModule::increment --signers 0xCAFE

// Featurres:
// 538789966662936199a3ee87a28b6121: Define specifications for functions and structs that include preconditions, postconditions, and invariants.
// df82f3d049ccfcecf80883bfa2494d9d: Specify a custom address for access specifiers in visibility restrictions.
// afa4237eee3de0f7590f7d3a63c5656f: Annotate spec blocks and members with pragma properties for meta-information or tool directives.
