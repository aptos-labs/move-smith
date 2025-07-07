
//# publish
module 0xCAFE::EffectsAnalysisTest {
    // Deliberate syntax error in module header (missing 'has' clause)
    // should produce a diagnostics error during compilation
    // use `//` comments to describe intention, actual invalid code skipped for real test

    // Correct modules for controlled tests
    use std::signer;
    use std::vector;

    // Valid simple struct and functions
    struct Data has store, key {
        value: u64,
    }

    public fun dummy_function() {
        // a pure function with no side effects
        42u64
    }

    public fun pure_expression_chain() : u64 {
        // All leaf expressions and pure function calls
        // No state change, should be side-effect free
        let value1 = 10u64;
        let value2 = dummy_function();
        let sum = value1 + value2;
        sum
    }

    public fun effecting_function(s: sign): () {
        // Function that performs a state change
        move_to(&s, Data { value: 1 });
        move_from<Data>(signer::address_of(&s));
    }

    // A function with side effects that should be detected as impure
    public fun detect_side_effect(s: signer): () {
        effecting_function(s)
    }

    // Compose a program with both side-effect-free parts and side effects,
    // to test if purity analysis isolates pure parts
    public fun combined_effects(s: signer) {
        // Pure expressions
        let _res1 = pure_expression_chain();
        // Side-effect operation
        detect_side_effect(s);
        // Another pure expression, should be recognized as pure
        let _pure_val = dummy_function();
        // All above should be analyzed for effects correctly
    }

    // Illustrate misuse: syntax error (e.g., misspelled keyword)
    // This syntax error should emit diagnostics
    public fun syntax_error_function() {
        // invalid syntax below: missing closing parenthesis
        // let _ = 5 + ; // purposely invalid
    }

    // Invalid type usage (type mismatch) should produce an error
    public fun type_mismatch() {
        // Assigning u64 to a u8 variable, should error
        let small: u8 = 255u64; // intentionally incorrect
    }

    // Show case of pure functions called within expressions
    public fun nested_pure_calls() : u64 {
        let (a, b) = f2(15u64); // intentional error, f2 expects u16, passing u64
        // Should produce compile-time type mismatch error
        a + b
    }

    // Function with global invariants: no side effects, but complex expressions
    public fun invariant_check() {
        let c = dummy_function();
        let d = pure_expression_chain();
        // No state modification; should be analyzed as effect-free
        assert!(c != 0, 999);
        assert!(d != 0, 999);
    }
}


//# run 0xCAFE::EffectsAnalysisTest::pure_expression_chain


//# run 0xCAFE::EffectsAnalysisTest::combined_effects --signers 0x1234


//# run 0xCAFE::EffectsAnalysisTest::detect_side_effect --signers 0x1234


//# run 0xCAFE::EffectsAnalysisTest::syntax_error_function


//# run 0xCAFE::EffectsAnalysisTest::type_mismatch


//# run 0xCAFE::EffectsAnalysisTest::nested_pure_calls --signers 0x1234


//# run 0xCAFE::EffectsAnalysisTest::invariant_check


// Featurres:
// 96d4c3b1a71e8daf7d449420521fa7f2: Compile Move code and receive detailed errors at multiple pipeline stages.
// e0857c203b7fb353aa193912b35ecaf7: Write Move expressions that are guaranteed to be free of side effects by using only leaf expressions or pure calls.
// 5941dd503b9dcc73e363012d080654d1: Treat the entire program as a target for comprehensive analysis.
