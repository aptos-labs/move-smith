
//# publish
module 0xCAFE::AdvancedFeaturesTest {
    use std::vector;

    // Struct for pattern matching tests
    struct Point has copy, drop, store {
        x: u8,
        y: u8,
    }

    // A simple enum to test pattern matching in block expressions
    enum Status has copy, drop {
        OK,
        Error(u8),
        Pending{code: u8},
    }

    /// A function to test unbound names handled via expressions and shadowing inside blocks
    public fun unbound_name_handling(x: u8): u8 {
        // Unbound name 'y' resolved inside block
        let y = 5u8;
        let result = {
            let y = x + y; // shadows outer y
            y
        };
        result // should be x + 5
    }

    /// Test block expressions variable scoping, shadowing and mutation
    public fun block_expr_scoping_and_mutation(x: u8): u8 {
        let z = 10u8;

        let w = {
            // 'z' is accessible here
            let z = z + 1;  // shadows outer z
            let y = z; // shadowing and mutability inside block
            y = y + x;
            y
        };

        // Outer z is still 10, inner z inside block does not leak
        z + w // 10 + ( (10+1)+x )
    }

    // Pattern matching introduced within block expressions with let bindings
    public fun pattern_matching_in_block(s: Status): u8 {
        let result = {
            let code = match s {
                Status::OK => { 0 },
                Status::Error(e) => { e },
                Status::Pending{code} => { code },
            };
            code + 1
        };
        result
    }

    /// A function demonstrating variables do not leak outside blocks
    public fun no_leaking_vars(x: u8): u8 {
        {
            let a = 5u8;
            let z = a + x;
            z;
        };
        // cannot use `a` or `z` here, must declare new variable
        let a = 20u8;
        a + x
    }

    /// Function illustrating conditional compilation with test-only code
    // test_only]
    public fun test_only_function(x: u8): u8 {
        x + 100
    }

    /// Function illustrating conditional compilation with verification only code
    // verification_only]
    public fun verification_only_function(x: u8): u8 {
        x + 200
    }

    /// A combined test fulfilling all requirements:
    /// - unbound names resolved inside block
    /// - pattern matching inside block
    /// - let-bindings and shadowing
    /// - conditional compilation blocks
    public fun combined_test(s: Status, input: u8): u8 {
        // test_only]
        let test_val = {
            let out = match s {
                Status::OK => input,
                Status::Error(e) => e,
                Status::Pending{code} => code,
            };
            let out = out + 1; // shadowing, let-bindings in block
            out
        };

        // verification_only]
        let verif_val = {
            let v = input + 50;
            v
        };

        // unbound name 'temp' resolved here
        let temp = 10u8;

        // block expression with shadowing
        let result = {
            let temp = temp + input;
            // test_only]
            let val = test_val + temp;

            // verification_only]
            let val = verif_val + temp;

            val
        };

        result
    }
}


//# run 0xCAFE::AdvancedFeaturesTest::unbound_name_handling --args 7u8


//# run 0xCAFE::AdvancedFeaturesTest::block_expr_scoping_and_mutation --args 5u8


//# run 0xCAFE::AdvancedFeaturesTest::pattern_matching_in_block --args 0xCAFE::AdvancedFeaturesTest::Status::OK


//# run 0xCAFE::AdvancedFeaturesTest::pattern_matching_in_block --args 0xCAFE::AdvancedFeaturesTest::Status::Error(42u8)



//# run 0xCAFE::AdvancedFeaturesTest::pattern_matching_in_block --args 0xCAFE::AdvancedFeaturesTest::Status::Pending{code: 99u8}


//# run 0xCAFE::AdvancedFeaturesTest::no_leaking_vars --args 10u8


//# run 0xCAFE::AdvancedFeaturesTest::test_only_function --args 5u8


//# run 0xCAFE::AdvancedFeaturesTest::verification_only_function --args 7u8


//# run 0xCAFE::AdvancedFeaturesTest::combined_test --args 0xCAFE::AdvancedFeaturesTest::Status::Error(3u8) 7u8


// Featurres:
// daa5a0eae4e10acd12e7cd84902cf1cc: Use expressions to unblock and handle unbound names in your Move code.
// b8a9c1c10b3e492d4bf690d9499d4e07: Use block expressions with let-bindings and pattern matching that can introduce new variable scopes and potentially modify variables within those scopes.
// 895e8135296d048d3ab43409b23b1fb0: Include or exclude test and verification code sections during Move compilation.
