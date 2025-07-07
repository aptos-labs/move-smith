//# publish
module 0x1::TestModule {
    // A top-level spec block that defines a dummy feature for testing
    spec schema {
        // Dummy schema for testing top-level spec parsing
        let _dummy_value: u64;
    }

    // Function to log detailed debug info with the bytecode dump name
    public fun log_debug_info() {
        // Log using the Move std API, assuming Debug module
        debug::print("[Debug] Starting debug info log");
        // Access the current file's name for bytecode dump
        let filename = file_name_or_env();
        debug::print("[Debug] Bytecode dump: ", &filename);
    }

    // Helper function to get filename from env variable or fallback
    fun file_name_or_env(): vector<u8> {
        // Try to get environment variable for log file
        // (Assuming standard env variable access, replace with actual if needed)
        let env_value = env::get_string("LOG_FILE").unwrap_or_else(|| b"default.log");
        env_value
    }

    // Declare a literal address specifier with a byte sequence
    const ADDRESS_LITERAL: vector<u8> = b"(0x1234)";

    // Spec block to set up file logging
    spec setup_logging {
        fun initialize() {
            // Suppose to initialize logging with a file name
            let log_file_name = env::get_string("LOG_FILE").unwrap_or_else(|| b"default.log");
            // Call hypothetical initialize function
            // (In reality, this could be a Move logging setup)
            logging::initialize(log_file_name);
        }
    }

    // Function that demonstrates type union (pipe '|' and '||') syntax
    public fun use_type_union(val: u8 || u16 | u32) {
        // Example usage, no actual logic needed
    }

    // Function to get span info of consumed tokens
    public fun get_token_span(token: &Token) : LocationSpan {
        // Hypothetically retrieve token span
        token.span()
    }

    // Runner function to execute all above
    public fun run_all() {
        Self::log_debug_info();
        Self::use_type_union(100u8);
        // Assume token is obtained somehow
        let tok = Token { span: LocationSpan { start: 0, end: 5 } };
        let _span = Self::get_token_span(&tok);
        Self::setup_logging::initialize();
    }
}

//# run 0x1::TestModule::run_all

//# run 0x1::TestModule::use_type_union --args 255u8