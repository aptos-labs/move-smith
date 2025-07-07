//# publish
module 0x1::diagnostics_config {
    /// Configures compiler environment variables for warnings
    public fun set_deprecated_warning(enabled: bool) {
        // Placeholder for setting environment variable, typically done outside runtime
    }
}

//# publish
module 0x1::diagnostics {
    import 0x1::diagnostics_config;

    resource struct Environment {
        deprecated_warning: bool,
    }

    public fun init_env(account: &signer) {
        move_to(account, Environment { deprecated_warning: false });
    }

    public fun configure_deprecated_warning(env_addr: address, enable: bool) {
        // Pseudo-code: set environment variable for compiler warnings
        diagnostics_config::set_deprecated_warning(enable);
    }

    // Function that issues warning if deprecated API is used
    public fun use_deprecated_api() {
        // simulate usage of deprecated API
        // If warnings are enabled, the compiler should issue warnings
    }

    // Function to remove duplicate diagnostics before rendering
    public fun remove_duplicate_diagnostics(diagnostics: vector<string>): vector<string> {
        let unique_diagnostics = vector::empty<string>();
        let seen = vector::empty<string>();

        let len = vector::length(&diagnostics);
        let i = 0;
        while (i < len) {
            let diag = *vector::borrow(&diagnostics, i);
            if (!vector::contains(&seen, &diag)) {
                vector::push_back(&mut seen, diag);
                vector::push_back(&mut unique_diagnostics, diag);
            }
            i = i + 1;
        };
        unique_diagnostics
    }

    // Function that issues diagnostics
    public fun emit_diagnostics(diagnostics: vector<string>) {
        let filtered = remove_duplicate_diagnostics(diagnostics);
        // render filtered diagnostics
    }
}

//# publish
module 0x1::axiom {
    // Generic axiom declaration with optional type parameters
    struct Axiom<T> {
        condition: bool,
        _marker: phantom<T>,
    }

    // Function to create an axiom with optional type parameters for condition
    public fun create_axiom<T>(condition: bool): Axiom<T> {
        Axiom { condition, _marker: phantom() }
    }
}

//# run
script {
    use 0x1::diagnostics;
    use 0x1::axiom;

    fun run() {
        // Initialize environment
        let sender = signer::address_of(&signer::borrow_signer());
        diagnostics::init_env(&signer::borrow_signer());

        // Enable warnings for deprecated APIs
        diagnostics::configure_deprecated_warning(sender, true);

        // Use deprecated API to see if warning is issued during compilation
        diagnostics::use_deprecated_api();

        // Test diagnostics deduplication
        let diagnostics_msgs = vector::empty<string>();
        vector::push_back(&mut diagnostics_msgs, "Warning: deprecated API used".to_string());
        vector::push_back(&mut diagnostics_msgs, "Warning: deprecated API used".to_string()); // duplicate
        vector::push_back(&mut diagnostics_msgs, "Error: mismatched types".to_string());

        diagnostics::emit_diagnostics(diagnostics_msgs);

        // Test optional type parameter in axiom
        let _axiom1 = axiom::create_axiom::<u64>(true);
        let _axiom2 = axiom::create_axiom::<string>("condition_met".length() > 0);
    }
}