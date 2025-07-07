//# publish
address 0xCAFE {
    module Parser {
        use std::vector;

        /// A simple struct to represent a parsed "token" (for demonstration)
        struct Token has store, copy, drop {
            value: u8, // just hold some ASCII code of token
        }

        /// Parses a comma-separated list of u8 tokens, allowing optional trailing commas.
        /// For example, input vector [1,44,2,44] means 1, ',', 2, ',' -> returns vector [1,2]
        public fun parse_comma_separated(input: vector<u8>): vector<u8> {
            let result = vector::empty<u8>();
            let i = 0u64;      // removed 'mut' keyword
            let len = vector::length(&input);
            let mut result = result;
            let mut i = i;     // shadow i as mutable

            while (i < len) {
                let c = *vector::borrow(&input, i);
                if (c == 44u8) { // comma ascii ','
                    // skip comma
                    i = i + 1;
                    continue;
                }
                result = vector::push_back(result, c);
                i = i + 1;
            }

            // Remove trailing comma elements (if last element(s) was comma, those are not added)
            // So result has just the tokens, ignoring commas.

            result
        }

        /// EXERCISE parsing with trailing comma inputs
        public fun runner(): vector<u8> {
            let input1 = vector::from_bytes(b"1,2,3");
            let input2 = vector::from_bytes(b"1,2,3,");
            let input3 = vector::from_bytes(b",1,2,3,");
            let input4 = vector::from_bytes(b"1,,,2,3,,");

            // Parse each and sum their lengths so VM executes all paths
            let r1 = parse_comma_separated(input1);
            let r2 = parse_comma_separated(input2);
            let r3 = parse_comma_separated(input3);
            let r4 = parse_comma_separated(input4);

            // Just to combine so the return is valid and all parse calls happen
            vector::append(r1, r2);
            vector::append(r3, r4)
        }
    }
}
//# run 0xCAFE::Parser::runner

//# publish
address 0xBEEF {
    module Logger {
        use std::debug;
        use std::vector;

        /// LogLevel enum with copy and store to test enum abilities
        enum Level has store, copy, drop {
            Debug,
            Info,
            Warn,
            Error,
        }

        /// Configuration for logger
        struct Config has store, key {
            level: Level,
            enabled: bool,
        }

        /// Global singleton storing current config
        struct LoggerConfig has store, key {
            config: Config,
        }

        /// Initialize config based on environment variable (stub using a vector<u8> input)
        /// If input == "DEBUG", set level to Debug else Info (default)
        /// enabled=true if input is non-empty
        public fun init_config(env: vector<u8>, acct: &signer) {
            let level = if (vector::length(&env) == 0) {
                Level::Info
            } else if (env == vector::from_bytes(b"DEBUG")) {
                Level::Debug
            } else {
                Level::Info
            };

            let config = Config { level, enabled: true };

            let logger_config = LoggerConfig { config };

            move_to(acct, logger_config);
        }

        /// Get current config (copy returned)
        public fun get_config(): Config acquires LoggerConfig {
            let addr = @0xBEEF;
            if (!exists<LoggerConfig>(addr)) {
                return Config { level: Level::Info, enabled: false };
            };
            let logger_config = borrow_global<LoggerConfig>(addr);
            logger_config.config
        }

        /// Log message if enabled and level appropriate
        public fun log(level: Level, msg: vector<u8>) {
            let config = get_config();

            if (!config.enabled) {
                return;
            }

            // Only log if level >= config.level (Debug < Info < Warn < Error, but here no ord, so just print all)
            // For demo, just print all log messages if enabled
            debug::print(&msg);
        }

        /// Runner function to exercise init_config + logging
        public fun runner(acct: &signer) {
            init_config(vector::from_bytes(b"DEBUG"), acct);
            log(Level::Debug, vector::from_bytes(b"Debug log message\n"));
            log(Level::Info, vector::from_bytes(b"Info log message\n"));
            log(Level::Warn, vector::from_bytes(b"Warn log message\n"));
            log(Level::Error, vector::from_bytes(b"Error log message\n"));
        }
    }
}
//# run 0xBEEF::Logger::runner --signers 0xBEEF

//# run
script {
    use 0xCAFE::Parser;
    use 0xBEEF::Logger;
    use std::vector;

    fun main(account: &signer) {
        // Run parser runner
        let _result = Parser::runner();
        Logger::log(Logger::Level::Info, vector::from_bytes(b"Parser runner executed\n"));

        // Run logger runner
        Logger::runner(account);
    }
}