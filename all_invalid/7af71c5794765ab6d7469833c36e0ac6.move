
//# publish
module 0xCAFE::AbortBreakSpecTest {
    use std::error;
    use std::string;

    struct State has store {
        count: u64,
        flag: bool,
        message: vector<u8>,
    }

    /// Function 1: abort with code and message, annotated with abort state
    /// Loop with break based on count, check abort triggers only after break.
    public fun abort_with_message(s: &mut State, limit: u64) {
        s.count = 0;
        s.flag = false;
        loop {
            if (s.count >= limit) {
                s.flag = true;
                break;
            };
            s.count = s.count + 1;
        };
        // After break, abort if flag true
        if (s.flag) {
            s.message = b"Abort triggered after break";
            abort 777;
        };
    }

    /// Function 2: while loop with break, no abort
    public fun loop_with_break(max: u64): u64 {
        let i = 0;
        while (true) {
            if (i == max) {
                break;
            };
            i = i + 1;
        };
        i
    }

    /// Function 3: abort with abort code and message using error::abort_with_message
    public fun abort_with_error_code(cond: bool) {
        if (cond) {
            error::abort_with_message(u64::from(1234), b"Explicit abort message");
        };
    }

    /// Function 4: Loop break then abort, testing abort state annotations and spec updates after break and abort
    public fun break_then_abort(s: &mut State, threshold: u64) {
        s.count = 0;
        loop {
            s.count = s.count + 1;
            if (s.count == threshold) {
                break;
            };
        };
        s.flag = true;
        abort 888;
    }

    // Spec block to use update in specification, to specify expected updates
    spec module {
        // Update spec for abort_with_message function
        spec abort_with_message(s: &State, limit: u64) {
            update count = if s.count >= limit { limit } else { s.count };
            update flag = s.count >= limit;
            update message = if s.count >= limit { b"Abort triggered after break" } else { s.message };
        }

        // Spec for loop_with_break
        spec loop_with_break(max: u64): u64 {
            ensures result == max;
        }

        // Spec for abort_with_error_code
        spec abort_with_error_code(cond: bool) {
            update cond == true ==> error::abort_with_message(1234u64, b"Explicit abort message");
        }

        // Spec for break_then_abort
        spec break_then_abort(s: &State, threshold: u64) {
            update count = threshold;
            update flag = true;
        }
    }
}



//# run 0xCAFE::AbortBreakSpecTest::abort_with_message --args 5u64



//# run 0xCAFE::AbortBreakSpecTest::loop_with_break --args 7u64



//# run 0xCAFE::AbortBreakSpecTest::abort_with_error_code --args true



//# run 0xCAFE::AbortBreakSpecTest::break_then_abort --args 3u64
