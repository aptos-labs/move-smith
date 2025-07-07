
//# publish
module 0xDEAD::ControlFlowAndLoggingTest {
    use std::vector;
    use std::string;
    use std::event;
    use std::signer;

    struct LogState has store {
        log_filename: vector<u8>,
        logs: vector<vector<u8>>,
    }

    public fun initialize_log_state(log_filename: vector<u8>): LogState {
        LogState {
            log_filename,
            logs: vector::empty<vector<u8>>()
        }
    }

    public fun append_log(state: &mut LogState, message: vector<u8>) {
        vector::push_back(&mut state.logs, message);
    }

    // Function that performs nested control flow with loop and if-continue
    public fun nested_control_loop(limit: u64): u64 {
        let counter = 0u64;
        let outer = true;

        while (outer) {
            let inner_count = 0u64;

            for (i in 0..10) {
                if (i % 2 == 0) {
                    // skip even numbers
                    continue;
                }
                if (i > 7) {
                    // Exit the outer loop when i > 7
                    outer = false;
                    break;
                }
                // Increment inner counter for odd i <=7
                inner_count = inner_count + 1;
            }

            counter = counter + inner_count;
            if (counter >= limit) {
                outer = false;
            };
        };
        counter
    }

    // Function to test logging: it reads a filename environment variable
    public fun test_logging(env_filename: vector<u8>): u8 acquires LogState {
        let log_state = initialize_log_state(env_filename);
        append_log(&mut log_state, b"Start logging\n");
        append_log(&mut log_state, b"Logging in progress\n");
        // simulate some logging
        append_log(&mut log_state, b"End of logging\n");
        // For test purposes, return 1 to denote success
        1u8
    }

    // Generic data structure containing various types
    struct GenericContainer<T> has store {
        data: T,
    }

    public fun create_vector_container(vec: vector<u8>): GenericContainer<vector<u8>> {
        GenericContainer { data: vec }
    }

    public fun create_number_container(num: u64): GenericContainer<u64> {
        GenericContainer { data: num }
    }

    // Functions with various argument types and abilities
    public fun process_data(x: u8, y: u16, msg: vector<u8>): u16 {
        let sum = (x as u16) + y;
        // simulate processing with message
        sum
    }

    public fun get_struct_type(name: vector<u8>): vector<u8> {
        name
    }

    // Access functions in nested modules
    public fun call_nested_module_func() {
        0xDEAD::NestedModule::nested_function();
    }

    
//# publish
    module 0xDEAD::NestedModule {
        public fun nested_function() {
        }
    }

    // Function that combines control flow, logging, generics, and module calls
    public fun run_combined_tests(env_filename: vector<u8>): u8 {
        let _ = test_logging(env_filename);
        let count = nested_control_loop(15);
        let v_container = create_vector_container(vector::singleton<u8>(255u8));
        let n_container = create_number_container(42);
        let processed = process_data(10u8, 300u16, b"Hello");
        call_nested_module_func();
        1u8
    }
}

//# run 0xDEAD::ControlFlowAndLoggingTest::run_combined_tests --args "test_log.txt"


// Featurres:
// 312e4630fd94dea2ace81bdc0229c624: Test that nested if-continue statements correctly interact with an outer loop, allowing the loop to break when the condition is false.
// 56a82df6b40d543d56a4081aa298c444: Set up file logging by specifying a file name from the environment variable.
// 3a91623d3cca10a6d0f0d8e930f82c86: Define a generic type that can contain other types, such as vectors or structs with type parameters.
// d0ea86b49fa82ca49eeacce4ffa95cfc: Define functions with argument types, return types, and abilities.
// 9a8847f893559f4ccdce63ae8c9c6dc0: Access modules and types through a chain of names using a specific syntax.
