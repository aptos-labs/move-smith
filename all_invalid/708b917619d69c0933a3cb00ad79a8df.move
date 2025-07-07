
//# publish
module 0xCAFE::LogAndReturnTest {
    use std::string;
    use std::vector;
    use std::signer;

    // A private struct for logging purposes, not exposed outside
    struct LogRecord has copy, drop, store {
        timestamp: u64,
        level: vector<u8>,
        module_path: vector<u8>,
        message: vector<u8>,
    }

    // Simulate a function that returns explicitly typed u64
    public fun get_current_timestamp(): u64 {
        // Use untyped literal 42 for timestamp simulation
        42u64
    }

    // Stores a formatted log record and returns it with explicit return type annotation
    public fun create_log_record(message_value: u64): LogRecord {
        // Explicit return type annotation
        : LogRecord

        let timestamp = get_current_timestamp();
        let level = b"INFO";
        let module_path = b"0xCAFE::LogAndReturnTest";

        // Compose message including an untyped integer literal 100 (no suffix) plus message_value
        // convert u64 to vector<u8> decimal string for composing message
        let msg_prefix = b"Processed count: ";
        let count_str = u64_to_vec(message_value + 100);

        let message = vector::empty<u8>();
        vector::append(&mut message, &msg_prefix);
        vector::append(&mut message, &count_str);

        LogRecord {
            timestamp,
            level,
            module_path,
            message,
        }
    }

    // Helper function to convert u64 to decimal in vector<u8>
    // This is a lightweight utility and also tests arithmetic and loops with untyped literals
    public fun u64_to_vec(mut x: u64): vector<u8> {
        if (x == 0) {
            return vector::from_bytes(b"0");
        };

        let digits = vector::empty<u8>();
        while (x > 0) {
            let d = (x % 10) as u8;
            // ASCII digit = d + '0' (48)
            vector::push_back(&mut digits, d + 48);
            x = x / 10;
        };

        let reversed = vector::empty<u8>();
        let len = vector::length(&digits);
        let i = 0;
        while (i < len) {
            let ch = *vector::borrow(&digits, len - 1 - i);
            vector::push_back(&mut reversed, ch);
            i = i + 1;
        };
        reversed
    }

    // A test function that calls create_log_record with untyped literal argument and uses the log record,
    // explicitly stating return type u64 to confirm correct typing
    public fun test_log_and_return(): u64 {
        : u64
        let log = create_log_record(58);
        // Compose full string for log output format check (not printing but keeping logic)
        let full_log = vector::empty<u8>();
        vector::append(&mut full_log, &u64_to_vec(log.timestamp));
        vector::push_back(&mut full_log, b' ');
        vector::append(&mut full_log, &log.level);
        vector::push_back(&mut full_log, b' ');
        vector::append(&mut full_log, &log.module_path);
        vector::push_back(&mut full_log, b':');
        vector::push_back(&mut full_log, b' ');
        vector::append(&mut full_log, &log.message);

        // Return timestamp to confirm function returns explicitly typed u64
        log.timestamp
    }
}


//# run 0xCAFE::LogAndReturnTest::test_log_and_return


// Featurres:
// cea9992ac91ef8379a6b1f4fd69bea85: Format log records with a timestamp, log level, module path, and message content
// 290d9ace984c73bfe9a12a6153ee5fe7: Specify the return type of a function with a single return value using a colon followed by the signature token.
// 65a8053552ea57ed62634759f6bc35f0: Write integer literals without a type suffix to have them default to an untyped integer value.
