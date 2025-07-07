//# publish
module 0xCAFE::NamingAndAxiom {
    use std::vector;

    // Avoid restricted names like 'Self', 'self', 'true', 'false', in various cases for identifiers
    // Also avoid all-uppercase or starting with a number for field names or variables

    // A struct with properly named fields
    struct Data has copy, drop, store {
        field1: u64,
        fieldTwo: u64,
    }

    // Function to test that all identifiers must be lowercase or camelCase, no restricted names
    public fun test_names(xValue: u8, isValid: bool): u8 {
        // Correct use of variable names, no reserved words or restricted names
        let result = if (isValid) {
            xValue + 1
        } else {
            xValue
        };
        result
    }

    // Define a function body in braces even when not native
    public fun do_nothing() {
        {};
    }

    // Define an axiom with an optional type parameter for condition parametrization
    // Dummy usage since Move does not have native axiom support, we emulate an invariant check function
    public fun invariant_for_type<T>(x: u64): bool {
        // For demonstration, the axiom-like condition is that x must not be zero for type T
        x != 0
    }
}

//# run 0xCAFE::NamingAndAxiom::test_names --args 5u8 true

//# run 0xCAFE::NamingAndAxiom::do_nothing

//# run 0xCAFE::NamingAndAxiom::invariant_for_type<u64> --args 10u64

//# run 0xCAFE::NamingAndAxiom::invariant_for_type<u8> --args 0u64

// Featurres:
// 7f309b1d317c696ec20e796d42585e07: Avoid using restricted names for declared identifiers based on context and naming case
// 679323963cd74ae828c4beb0207d5793: Specify optional type parameters for the 'axiom' to parameterize its conditions.
// 560244dd82d11bf77636ba489a52fb2c: Define the function body in braces when not native.
