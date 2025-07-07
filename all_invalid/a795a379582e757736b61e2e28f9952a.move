// This is a Move transactional test file (with `.move` extension) that exercises:
// 1. Conditional branches using `if_else` in specs,
// 2. Using numerical and symbolic addresses in annotations,
// 3. Adding attributes to modules via spec modules and verifying they merge.

// Filename: ConditionalAndAttributesTest.move

address 0x1 {
    module ConditionalIf {
        use std::signer;
        use std::vector;

        /// A simple function that returns 1 if input is positive, else 0
        public fun positive_flag(x: i64): u8 {
            if x > 0 {
                1
            } else {
                0
            }
        }

        /// Test function to be called transactionally
        public entry fun test_positive_flag(s: &signer, x: i64): u8 {
            positive_flag(x)
        }

        /// Module spec attributes using symbolic named address
        #[module_attr(address = @0x1, name = "example")]
        spec module {
            /// Spec for positive_flag showing use of if_else expression
            spec fun positive_flag(x: i64): u8 {
                ensures if x > 0 { result == 1 } else { result == 0 }
            }
        }
    }
}

// Another module with numerical and symbolic addresses as attributes in specs
address 0x2 {
    /// Spec module that adds attributes to the target module 0x1::ConditionalIf
    #[spec_module(address = 0x1, name = "ConditionalIf", version = 1)]
    module ConditionalIfSpecExt {
        #[module_attr(priority = 10)]
        spec module {}
    }

    /// A dummy module with numeric and symbolic addresses in attributes
    #[module_attr(numbers = [1, 2, 3], owner = @0x2, description = "Dummy Module")]
    module DummyModule {
        public fun dummy(): bool {
            true
        }

        spec module {
            ensures true;
        }
    }
}

// Transactional test script invoking the tested module and verifying results
script {
    use 0x1::ConditionalIf;

    fun test_case(signer: &signer) {
        // Test positive_flag with positive input
        let res1 = ConditionalIf::test_positive_flag(signer, 10);
        assert(res1 == 1, 1);

        // Test positive_flag with zero input
        let res2 = ConditionalIf::test_positive_flag(signer, 0);
        assert(res2 == 0, 2);

        // Test positive_flag with negative input
        let res3 = ConditionalIf::test_positive_flag(signer, -5);
        assert(res3 == 0, 3);
    }
}

// Featurres:
// 817f78ceb6c33c6b4c3aab22d5889843: Write conditional branches using the `if_else` expression with then and optional else branches.
// 6944f68830d8207340ad171d16b914ef: Use both numerical and symbolic (named) addresses as attribute values in annotations.
// a4e33a282cae3cdb894d91b180870d57: Add attributes to modules via spec modules and have those attributes appear on the merged module.
