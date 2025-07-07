
//# publish
module 0xCAFE::ControlFlowAndValidation {
    use std::debug;
    use std::string;
    use std::vector;

    // Function with nested if-continue inside a loop
    public fun nested_loop_controlwise(limit: u64): u64 {
        let acc: u64 = 0;
        let i: u64 = 0;
        while (i < limit) {
            if (i % 2 == 0) {
                if (i % 4 == 0) {
                    // Continue if multiple of 4
                    i = i + 1;
                    continue;
                } else {
                    // Only add if not multiple of 4
                    acc = acc + i;
                };
            } else {
                // Break on odd numbers
                break;
            };
            i = i + 1;
        };
        acc
    }

    // Environment simulation: get log filename from environment variable
    // Note: Since Move doesn't interact with actual environment variables, simulate via parameters
    struct Logger has store {
        file_name: vector<u8>,
        logs: vector<vector<u8>>,
    }

    public fun init_logger(file_name: vector<u8>): Logger {
        let logger = Logger {
            file_name,
            logs: vector::empty<vector<u8>>(),
        };
        logger
    }

    public fun log_message(logger: &mut Logger, message: vector<u8>) {
        vector::push_back(&mut logger.logs, message);
    }

    // Validation of address assignment string containing exactly one '='
    public fun validate_address_string(addr_str: vector<u8>): bool {
        let count_eq: u8 = 0;
        let len = vector::length(&addr_str);
        let idx = 0;
        while (idx < len) {
            let ch = *vector::borrow(&addr_str, idx);
            if (ch == b'=' ) {
                count_eq = count_eq + 1;
            };
            idx = idx + 1;
        };
        if (count_eq != 1) {
            false
        } else {
            // Additional validation: check format, e.g., not empty before or after '='
            let idx_eq = match vector::index_of(&addr_str, b'=') {
                option::some(pos) => pos,
                option::none => {
                    false
                }
            };
            // Ensure not empty before '='
            if (idx_eq == 0) {
                false
            } else {
                // Ensure not empty after '='
                if (idx_eq + 1 >= len) {
                    false
                } else {
                    true
                }
            }
        }
    }

    // Helper function to simulate setting environment variable (for testing)
    public fun get_env_variable(envs: &vector<(vector<u8>, vector<u8>)>, key: vector<u8>): option<(vector<u8>, vector<u8>)> {
        let len_envs = vector::length(envs);
        let idx = 0;
        while (idx < len_envs) {
            let (k, v) = *vector::borrow(envs, idx);
            if (string::equal(&k, &key)) {
                option::some((k, v))
            } else {
                idx = idx + 1;
            }
        };
        option::none()
    }

    // Main test function combining all parts
    public fun test_sequence(envs: &vector<(vector<u8>, vector<u8>)>) {
        // 1. Run nested control flow function
        let result_control_flow = nested_loop_controlwise(10);
        debug::print(&b"Control flow result:\n" as &vector<u8>);
        debug::print(&vector::to_string(&result_control_flow));

        // 2. Setup logging using env variable (simulate)
        let env_name = b"LOG_FILE";
        let env_value_opt = get_env_variable(envs, env_name);
        let logger = match env_value_opt {
            option::some((_, filename)) => {
                init_logger(filename)
            }
            option::none() => {
                init_logger(b"default_log.txt" as &vector<u8>)
            }
        };

        // 3. Write log message
        let _ = log_message(&mut logger, b"Test log entry" as &vector<u8>);
        debug::print(&b"Logged messages count:\n" as &vector<u8>);
        debug::print(&vector::to_string(&vector::length(&logger.logs)));

        // 4. Validate address assignment strings
        let valid_str = b"0x1234=0xABCD" as &vector<u8>;
        let invalid_str1 = b"0x1234==0xABCD" as &vector<u8>;
        let invalid_str2 = b"0x12340xABCD" as &vector<u8>;
        let invalid_str3 = b"=0xABCD" as &vector<u8>;
        let invalid_str4 = b"0x1234=" as &vector<u8>;

        // Valid string should return true
        let valid_check = validate_address_string(valid_str);
        debug::print(&b"Valid address string check:\n" as &vector<u8>);
        debug::print(&vector::to_string(&valid_check));

        // Invalid strings should return false
        let invalid_check1 = validate_address_string(invalid_str1);
        let invalid_check2 = validate_address_string(invalid_str2);
        let invalid_check3 = validate_address_string(invalid_str3);
        let invalid_check4 = validate_address_string(invalid_str4);
        debug::print(&b"Invalid address string checks:\n" as &vector<u8>);
        debug::print(&vector::to_string(&invalid_check1));
        debug::print(&vector::to_string(&invalid_check2));
        debug::print(&vector::to_string(&invalid_check3));
        debug::print(&vector::to_string(&invalid_check4));
    }
}


//# run 0xCAFE::ControlFlowAndValidation::test_sequence --args (empty options for envs)
// Here, simulate environment variables with correct and incorrect address strings


// Featurres:
// 312e4630fd94dea2ace81bdc0229c624: Test that nested if-continue statements correctly interact with an outer loop, allowing the loop to break when the condition is false.
// 56a82df6b40d543d56a4081aa298c444: Set up file logging by specifying a file name from the environment variable.
// 38c8fed9c8f68f65a6ce8f0a9b4bc138:  Validate that the address assignment string is correctly formatted with exactly one '=' character.
