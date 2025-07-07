//# publish
module 0xCAFE::TestParamsAndLogger {

    use aptos_framework::event::{EventHandle, emit_event};

    // Declare a constant
    const MAX_VALUE: u64 = 1000;

    // A global resource to hold an event handle for logging
    struct Logger has key {
        handle: EventHandle<u64>,
    }

    /// Initialize the logger, but if the logger already exists, do nothing.
    public fun init_logger(account: &signer) {
        if (!exists<Logger>(signer::address_of(account))) {
            let handle = event::new_event_handle<u64>(account);
            move_to(account, Logger { handle });
        }
    }

    /// Emit a log event with the given value.
    public fun log_value(account: &signer, value: u64) {
        // Make sure logger is installed
        init_logger(account);
        let logger = borrow_global_mut<Logger>(signer::address_of(account));
        emit_event(&mut logger.handle, value);
    }

    /// A function that takes explicit parameters with explicit types and does some checks
    public fun process_value(value: u64, threshold: u64): bool {
        // Use the const in computation
        if (value > MAX_VALUE || threshold > MAX_VALUE) {
            false
        } else {
            // Just a simple check, returns true if value >= threshold
            value >= threshold
        }
    }

    /// Runner function to call process_value with some parameters.
    public fun runner() {
        let res = process_value(500, 400);
        let _ = res;
    }
}
 //# run 0xCAFE::TestParamsAndLogger::runner

//# run
script {
    use 0xCAFE::TestParamsAndLogger;
    use std::signer;

    fun main(account: &signer) {
        // Init logger multiple times to test idempotency
        TestParamsAndLogger::init_logger(account);
        TestParamsAndLogger::init_logger(account);

        // Log some values
        TestParamsAndLogger::log_value(account, 10);
        TestParamsAndLogger::log_value(account, 20);

        // Test process_value function with explicit parameters
        let check1 = TestParamsAndLogger::process_value(300, 200);
        let check2 = TestParamsAndLogger::process_value(2000, 10); // Exceeds MAX_VALUE, expect false

        let _ = check1;
        let _ = check2;
    }
}

// Featurres:
// 90412034e9d821593c8fc32a21266754: Declare function parameters with explicit variable names and types using the syntax 'name: Type'.
// eb6cca76eb76d49ed4fba425009e8264: Rely on the function to handle the case where a logger is already installed without failing.
// 0d49c5405f091725093600f2b952af65: Declare constants inside modules using the 'const' keyword for global constant values.
