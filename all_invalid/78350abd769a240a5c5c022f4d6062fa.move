
//# publish
module 0xDEAD::Debugger {
    use std::string;

    // Function to simulate attaching custom annotation formatters
    public fun register_formatter(_name: string::String): bool {
        // Intentionally do nothing, just return true for success
        true
    }
}


//# publish
module 0xBADD::ErrorDiagnostics {
    use std::string;

    // Function to simulate attaching error diagnostics for unlinked modules
    public fun attach_error_diag(module_name: string::String): bool {
        // As a dummy, always succeed
        true
    }
}


//# publish
module 0xFEED::SourceMap {
    use std::string;

    // Function to simulate attaching source map modules
    public fun attach_source_map(source_map_id: u64): bool {
        // Dummy implementation
        true
    }
}


//# run
script {
    // Register custom annotation formatter for debugging
    let _ = 0xDEAD::Debugger::register_formatter(s"TestFormatter");
}


//# run
script {
    // Attach error diagnostic due to missing linked module
    let _ = 0xBADD::ErrorDiagnostics::attach_error_diag(s"UnlinkedModule");
}


//# run
script {
    // Attach a source map with an arbitrary ID
    let _ = 0xFEED::SourceMap::attach_source_map(42);
}


// Featurres:
// 42a04f2d7ad1e606a3c6e4b55fb0522f: Debug and test lifetime annotations by registering custom annotation formatters on Move functions
// 1d5769bf49a3a94cdb66fa91c361bd45: Attach error diagnostics when specification modules cannot be linked to a target module, preventing standalone compilation of specs.
// 31814c30074ca60af14f830ebab8f9c5: Attach compiled modules or scripts with their source maps for further processing if the experimental feature is enabled.
