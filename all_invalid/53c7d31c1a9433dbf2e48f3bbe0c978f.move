//# publish
module 0xA55A::DebugLoggingTest {
    use std::log;

    // Entry point for testing debug logs with bytecode dump alias
    public fun test_debug_logging() {
        // Enable debug logging for this test
        log::enabled(true);
        // Log a message indicating the start of the test
        log::debug!(b"Starting debug log test with bytecode dump alias");
        // Log detailed bytecode dump info, including the source filename
        log::debug!(b"BcDump: debug_logging_test.move");

        // Simulate using a literal address specifier with a byte sequence
        let literal_address: vector<u8> = vector[
            0x00, 0x01, 0x02, 0x03, // sample bytes representing '(0x1234)'
        ];
        // Log the literal address bytes
        log::debug!(b"Literal address bytes: {:?}", &literal_address);
    }
}

//# run 0xA55A::DebugLoggingTest::test_debug_logging --signers 0xA55A