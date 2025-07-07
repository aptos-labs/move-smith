
//# publish
module 0xCAFE::SpecNativeTest {
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
