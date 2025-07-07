// transactional_test.move
module 0x1::transactional_test {

    use std::debug;
    use std::env;

    /// Example Move struct to use in tests.
    struct MyStruct has copy, drop, store {
        value: u64,
    }

    /// Function that manipulates MyStruct and returns a value
    public fun increment(s: &mut MyStruct): u64 {
        s.value = s.value + 1;
        s.value
    }

    // ----- 1: #[test] attributes with key-value pairs -----

    // Since Move does not have native attributes like Rust,
    // simulate test metadata using well-known comments or doc comments.
    //
    // The Aptos Move framework allows specifying test attributes as meta data, e.g.:
    // #[test(name = "increment_test", description = "Test increment function", should_panic = false)]
    //
    // Here we simulate it by adding metadata in comments and test function names.

    #[test(name = "increment_test", description = "Tests increment function behavior", should_panic = false)]
    public entry fun test_increment(addr: &signer) {
        let mut s = MyStruct { value: 42 };
        let new_value = increment(&mut s);
        assert!(new_value == 43, 1001);
    }

    // ----- 2: Configure logger according to environment variable -----

    // Since Move does not have environment variables, 
    // simulate environment variable through a config parameter passed in the test.
    //
    // For demonstration, we will simulate reading a logging level passed to a logger setter.
    //
    // We assume existence of std::env::var which is not standard in Move,
    // but Aptos-ecosystem may have similar functionality.

    #[test(name = "logger_config_test", description = "Configure logger from env var", should_panic = false)]
    public entry fun test_logger_configuration(addr: &signer) {
        // Simulate getting environment variable "LOG_LEVEL"
        // For demonstration, use a fixed value or expose a helper to simulate env var:
        let log_level = get_env_var("LOG_LEVEL");
        configure_logger(log_level);

        // Log some messages according to log level
        log_debug("This is a DEBUG message");
        log_info("This is an INFO message");
        log_warn("This is a WARN message");

        // The test just asserts that logger's current level corresponds to the env var
        // Here, because Move spec is limited, assume configure_logger stores internally
        assert!(current_log_level() == log_level, 1002);
    }

    // Simulated environment variable getter (stub)
    public fun get_env_var(name: &vector<u8>): u8 {
        // Just simulate "DEBUG" = 1, "INFO" = 2, "WARN" = 3, default INFO=2
        if vector::equals(name, b"LOG_LEVEL" as vector<u8>) {
            // Normally would inspect env - for test return INFO (2)
            2
        } else {
            2
        }
    }

    // Logger state (simulate global logger config)
    resource struct LoggerConfig {
        level: u8,
    }

    // Store logger config globally under account 0x1
    public fun configure_logger(level: u8) {
        if (exists<LoggerConfig>(@0x1)) {
            move_to(&signer::borrow_address(&signer::borrow_global_mut::<LoggerConfig>(&@0x1)), LoggerConfig { level });
        } else {
            move_to(&signer::borrow_address(&signer::borrow_global_mut::<LoggerConfig>(&@0x1)), LoggerConfig { level });
        }
    }

    public fun current_log_level(): u8 {
        if (!exists<LoggerConfig>(@0x1)) {
            // default
            2
        } else {
            borrow_global<LoggerConfig>(@0x1).level
        }
    }

    // Logging functions simulate log output based on log level
    public fun log_debug(message: &vector<u8>) {
        if (current_log_level() <= 1) {
            debug::print(message);
        }
    }

    public fun log_info(message: &vector<u8>) {
        if (current_log_level() <= 2) {
            debug::print(message);
        }
    }

    public fun log_warn(message: &vector<u8>) {
        if (current_log_level() <= 3) {
            debug::print(message);
        }
    }

    // ----- 3: Automatically generate spec functions omitting references -----

    /// Original function that takes references (cannot be called in specs directly)
    public fun add_one_ref(x: &u64): u64 {
        *x + 1
    }

    /// Generated spec function that abstracts away references by taking by-value
    #[spec]
    public fun add_one_spec(x: u64): u64 {
        x + 1
    }

    /// Test calling the spec function in asserts
    #[test(name = "spec_function_test")]
    public entry fun test_spec_call(addr: &signer) {
        // Use add_one_ref normally in code
        let val = 10;
        let result = add_one_ref(&val);
        assert!(result == 11, 1003);

        // Use specification function in asserts (simulate with pure function call)
        let spec_result = add_one_spec(20);
        assert!(spec_result == 21, 1004);
    }
}

// Featurres:
// 49b7a8368d3cf383a8162ffa3806d4f6: Annotate tests with #[test] attributes that can take key-value pairs with literal values for test configuration.
// 00a758f7eefd851999ccfa4a6d092ab0: Configure the logger based on an environment variable and apply the specified log settings.
// 106a2bb706ab7fa01d829d1a39612d4a: Automatically generate specification functions that omit reference types in parameter and return types, abstracting away references in specs.
