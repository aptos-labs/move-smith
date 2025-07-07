
//# publish
module 0xCAFE::SpecNativeTest {
    use std::signer;

    const MAX_LIMIT: u64 = 1000;

    spec native fun native_spec_function(x: u64): bool;

    public fun check_limit(limit: u64): bool {
        native_spec_function(limit)
    }

    public fun use_custom_param_names(a_number: u64, is_enabled: bool): u64 {
        if (is_enabled) {
            a_number + MAX_LIMIT
        } else {
            a_number
        }
    }

    public fun runner() {
        let _ = check_limit(500u64);
        let _ = use_custom_param_names(42u64, true);
    }
}


//# run 0xCAFE::SpecNativeTest::runner


// Featurres:
// 36c72e3edbdbc4d4c017c081addfe2f5: Annotate spec functions with the 'native' keyword to indicate that their implementation is external or unavailable.
// 33ddd0111d3c9d597d4b3aef770ce646: Declare constants at the module level.
// f371913de31c787dc4fa217de3c252df: Use custom local variable names for function parameters (subject to name validity checks)
