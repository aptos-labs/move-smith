//# publish
module 0xCAFE::PatternShadowTest {
    use std::signer;

    struct Container has copy, drop, store {
        value: u8,
    }

    public fun nested_match_preserves_outer_value(x: u8): u8 {
        let outer = x;

        // Outer match binding
        let result = match (outer) {
            0 => {
                let inner_val = 42u8;
                let inner_result = match (inner_val) {
                    42 => 100,
                    _ => 0,
                };
                inner_result
            },
            _ => 1,
        };
        // outer must still be unchanged here
        let outer_after = copy outer;
        outer_after + result
    }

    public fun create_container_and_copy(v: u8): Container {
        let c = Container { value: v };
        let c_copy = copy c;
        c_copy
    }
}

//# run 0xCAFE::PatternShadowTest::nested_match_preserves_outer_value --args 0u8

//# run 0xCAFE::PatternShadowTest::create_container_and_copy --args 123u8

//# run
script {
    use std::spec;

    #[spec]
    module 0xCAFE::SpecModule {
        #[spec(fun)]
        public fun spec_fun(x: u8) : bool {
            x > 0
        }
    }

    #[spec]
    fun spec_script_fun(x: u8) : bool {
        0xCAFE::SpecModule::spec_fun(x)
    }

    #[spec]
    fun main() {
        let _b: bool = spec_script_fun(5);
    }
}

// Featurres:
// 7243deaa06ec1f8386be9e48903cc283: Test that pattern matching inside nested scopes does not leak or shadow variables, ensuring the outer variable value is preserved after the inner match expression.
// 1715850c94f7704ef136e2b985ca1fac: Include specifications in the script with attributes
// e91128c92c2f7bc28deae05eaaf74620: Use 'copy' to create a copy expression of a variable.
