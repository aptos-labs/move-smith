// Testing diagnostic errors by defining custom error codes, reporting errors, 
// using wildcard patterns, and testing address mappings for module and script parsing.

//# publish
module 0xCAFE::DiagTest {
    use std::error;
    use std::signer;

    /// Custom error codes
    const E_CUSTOM: u64 = 0;
    const E_ANOTHER: u64 = 1;

    // Report error if input is zero, or perform match with wildcard '_'
    public fun test_error_or_pattern(s: &signer, val: u8) {
        // Custom error reporting using abort
        if (val == 0) {
            // Raise an error with a custom code (diagnostic error)
            abort E_CUSTOM;
        }
        
        // Use pattern matching with '_'
        let res = match val {
            1 => 10,
            2 | 3 => 20,
            _ => 30,     // The `_` wildcard
        };

        // Do something with res so it's not unused (allowed for runtime, ignored here)
        DiagTest::emit_event(s, res);
    }

    /// Dummy event emitting for side-effect
    struct DummyEvent has drop, store {
        value: u8,
    }
    public fun emit_event(s: &signer, v: u8) {
        // Use event track for demonstration
        let event_handle = DiagTest::event_handle(s);
        event::emit_event<DummyEvent>(&event_handle, DummyEvent { value: v });
    }
    public fun event_handle(s: &signer): event::EventHandle<DummyEvent> acquires DummyEvent {
        // Fake, not implemented: just for compiler to parse wrapper
        // Real test infra will likely inject for event::EventHandle
        abort E_ANOTHER;
    }

    /// "Runner" function for test invocation, avoids arguments.
    public fun run(s: &signer) {
        // Trigger diagnostic error (abort) for val = 0
        // Should produce custom error
        DiagTest::test_error_or_pattern(s, 0);
    }
}

// This exercises error abort and wildcard patterning via 'test_error_or_pattern' and 'run'.

//# run 0xCAFE::DiagTest::run --signers 0xCAFE


//# publish
address 0xBEEF {
    module AddrTest {
        // Demonstrate module and function with dependency/address mapping
        public fun hello(): u8 {
            // Just for usage and test of module parse for address assignment
            42
        }
    }
}

//# run 0xBEEF::AddrTest::hello

//# run
script {
    // A script that uses a module at a mapped address
    use 0xBEEF::AddrTest;
    fun main() {
        let x = AddrTest::hello();
        // Use wildcard pattern in let
        let _ = x;
        // Just returns
    }
}