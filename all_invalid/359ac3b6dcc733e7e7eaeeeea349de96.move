// #publish
module 0xCAFE::SpecPatterns {

    /// A dummy struct to have something in the module.
    struct Dummy has store, key {
        val: u64,
    }

    /// A public constructor for Dummy.
    public fun new_dummy(val: u64): Dummy {
        Dummy { val }
    }

    /// A runner function testing spec patterns usage.
    /// This will exercise the compiler's spec pattern matching.
    public fun runner() {
        // Dummy usage to have effect in spec.
        let _d = new_dummy(42);
        // Note: No actual code is in spec here, but they exist for verification tools.
    }

    spec dummy_specifiers {
        /// Spec pattern with multiple adjacent fragments and wildcards:
        /// - This pattern matches any spec with fragments "dummy", "*" (wildcard), "specifiers"
        ///
        /// This tests the pattern "dummy*specifiers" with no spaces between fragments.
        pattern dummy*specifiers {
            // specification content (empty here)
        }

        /// Another spec pattern with multiple wildcards in sequence:
        /// pattern matching "dummy*spec*ifiers"
        pattern dummy*spec*ifiers {
            // specification content (empty here)
        }
    }

    /// An example of rewriting specifications is tested by having specs that overlap or that can be
    /// rewritten by the compiler. Since we do not execute specs, but the test compiles and publishes,
    /// this acts as a test of compiler spec rewriting logic.
}

// #run 0xCAFE::SpecPatterns::runner --signers 0xCAFE
script 0xCAFE::SpecPatternRunnerScript {
    use 0xCAFE::SpecPatterns;

    /// The main function supports "modifiers" and "documentation comments"
    /// but note in Move scripts these are mostly a comment and syntax.
    /// We demonstrate here typical style with doc comments and modifiers.
    /// Modifier here is 'public' which is typical for entry point scripts.
    ///
    /// @modifier example_modifier
    public fun main() {
        // Call the runner function to exercise compiler and VM.
        SpecPatterns::runner();
    }
}

// Featurres:
// 88dca79f95b17eb21aa1ebb720089622: Define the main function of your script with support for modifiers and documentation comments.
// beed001108a54ff28941535d37c42e3d: Create specification patterns with a name pattern composed of identifier fragments and asterisks, allowing adjacent identifier fragments or wildcards without spaces.
// f3ed1b5746a89b81a2e291455118a7ae: Rewrite specifications in Move modules during compilation for improved analysis or verification.
