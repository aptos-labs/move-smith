//# publish
module 0xCAFE::PatternMatchTest {
    use std::signer;

    struct Container has copy, drop, store {
        value: u8
    }

    public fun test_outer_variable_preservation(s: signer, input: u8): u8 {
        let outer = input;

        {
            let e = outer;
            let result = match(e, outer) {
                (0, outer_val) => {
                    // Inner scope variable shadows 'outer' but avoid leaking or shadowing the original 'outer'
                    let inner = 42u8;
                    inner + outer_val
                },
                (_, outer_val) => {
                    outer_val
                }
            };
            // result is unused, just for testing scoping and pattern matching as function call
        };

        outer // return original outer, ensuring it was not shadowed or leaked
    }

    // Runner function, just calls test_outer_variable_preservation with fixed args
    public fun runner(s: signer): u8 {
        test_outer_variable_preservation(s, 5u8)
    }
}

//# run 0xCAFE::PatternMatchTest::runner --signers 0xDEAD


// Featurres:
// ca4488945f39209b224527aea0f7ede8: Specify test parameters in the #[test] attribute to bind function parameters to concrete values, including addresses and signers, for parameterized testing.
// 7243deaa06ec1f8386be9e48903cc283: Test that pattern matching inside nested scopes does not leak or shadow variables, ensuring the outer variable value is preserved after the inner match expression.
// e11ee14141353863d01f9dc6bd4c5061: Use 'match' as a function call 'match()' with arguments separated by commas inside parentheses.
