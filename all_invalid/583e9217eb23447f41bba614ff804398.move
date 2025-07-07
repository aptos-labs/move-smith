
//# publish
module 0xCAFE::CrossModuleVisibility {
    // Public function: accessible everywhere
    public fun public_func(): u8 {
        42u8
    }

    // Public(friend): only accessible from friend modules (declare CallerModule as friend)
    public(friend 0xCAFE::CallerModule) fun friend_func(): u8 {
        24u8
    }

    // Script function: only callable by scripts (not public)
    fun script_only_func(): u8 {
        99u8
    }

    // Public function to test calling private function internally
    public fun call_private_func(): u8 {
        private_func()
    }

    fun private_func(): u8 {
        7u8
    }
}



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::CrossModuleVisibility;

    // Calls public function from another module
    public fun call_public(): u8 {
        CrossModuleVisibility::public_func()
    }

    // Calls friend function - now allowed because of friend declaration
    public fun call_friend(): u8 {
        CrossModuleVisibility::friend_func()
    }

    // Calls public function that internally calls private function
    public fun call_internal_private(): u8 {
        CrossModuleVisibility::call_private_func()
    }

    // Test function to call all the above
    public fun runner(): (u8, u8, u8) {
        let a = call_public();
        let b = call_friend();
        let c = call_internal_private();
        (a, b, c)
    }
}



//# publish
module 0xCAFE::EnvBasedLogger {
    use std::vector;
    use std::string;
    use std::debug;

    // Store the log as vector of bytes, simulating file logging
    struct Logger has key {
        logs: vector<u8>,
        file_name: vector<u8>,
    }

    // Initialize logger with file name from environment variable (simulated)
    // Since Move cannot read env vars, we simulate with argument passed by caller
    public fun init_logger(file_name: vector<u8>): Logger {
        Logger {
            logs: vector::empty<u8>(),
            file_name,
        }
    }

    // Append a log message
    public fun log(logger: &mut Logger, msg: vector<u8>) {
        // Append message and newline
        vector::append(&mut logger.logs, msg);
        vector::push_back(&mut logger.logs, 10); // '\n'
    }

    // Return current logs
    public fun get_logs(logger: &Logger): vector<u8> {
        vector::copy(&logger.logs)
    }

    // Dummy function to show logs using debug::print (simulate output)
    public fun print_logs(logger: &Logger) {
        debug::print(&logger.file_name);
        debug::print(b":\n");
        debug::print(&logger.logs);
        debug::print(b"\n");
    }

    // Function that runs logging flow
    public fun runner() {
        let file_name = b"logfile_from_env.log";
        let logger = init_logger(file_name);
        log(&mut logger, b"Log entry 1");
        log(&mut logger, b"Log entry 2");
        print_logs(&logger);
    }
}



//# publish
module 0xDEAD::DefaultAddressModule {
    // Module does not explicitly require caller address - use const default address
    const DEFAULT_ADDR: address = @0xBEEF;

    // Public function that returns the default address constant
    public fun get_default_address(): address {
        DEFAULT_ADDR
    }

    // Public function that returns its own module address using intrinsic function
    public fun get_module_address(): address {
        @0xDEAD
    }

    // Public function calling a function from 0xCAFE::CallerModule
    use 0xCAFE::CallerModule;

    public fun cross_call_caller_module(): u8 {
        CallerModule::call_public()
    }
}



//# run 0xCAFE::CallerModule::runner



//# run 0xCAFE::EnvBasedLogger::runner



//# run 0xDEAD::DefaultAddressModule::get_default_address



//# run 0xDEAD::DefaultAddressModule::get_module_address



//# run 0xDEAD::DefaultAddressModule::cross_call_caller_module
