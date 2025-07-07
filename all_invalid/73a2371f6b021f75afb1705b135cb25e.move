//# publish
module 0xCAFE::UnitTest {
    use std::signer;
    use std::vector;

    /// Expose new checker names as public constants for external use
    public const CHECKER_NAME_1: vector<u8> = b"checker_one";
    public const CHECKER_NAME_2: vector<u8> = b"checker_two";

    /// A function that uses quantifiers in spec
    spec {
        // The forall quantifier example: for all u in 0..10, u < 20
        forall u: u8::u8 {
            (u < 20) && (u >= 0)
        }

        // The exists quantifier example: exists u in 0..10 with u == 5
        exists u: u8::u8 {
            u == 5
        }
    }

    /// A simple function with specs using quantifiers
    public fun check_quantifiers() {
        // Nothing in code, all in specs.
    }

    /// A runner function callable without arguments
    public fun runner() {
        // Call check_quantifiers for completeness
        check_quantifiers();
    }
}

//# run 0xCAFE::UnitTest::runner --signers 0xCAFE

// Featurres:
// 4c1004e16d45b2b625df1cd00661b686: Expose new checker names for use in external module and bytecode validation.
// 7bd5a885ef12418255344b5ea730c563: Define modules named 'UnitTest' in your package.
// 42600b5bbe8ce664466b1a6ee2ac08db: Write quantifier expressions (`forall`, `exists`, etc.) in specification contexts.
