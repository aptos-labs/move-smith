//# publish
module 0x1::LogSpec {
    use std::string;
    use std::vector;
    use std::option;

    /// LogLevel enum
    #[derive(copy, drop, store, key)]
    public enum LogLevel {
        DEBUG,
        INFO,
        WARN,
        ERROR,
    }

    /// Parsed log specification struct
    struct LogSpec has copy, drop, store {
        pub levels: vector<LogLevel>,
        pub modules: vector<string::String>,
    }

    /// Parses a log specification string of the form:
    /// "level=DEBUG,INFO;module=mod1,mod2"
    public fun parse_log_spec(config: string::String): LogSpec {
        let mut levels = vector::empty<LogLevel>();
        let mut modules = vector::empty<string::String>();

        let parts = string::split(&config, ';');
        let length = vector::length(&parts);
        let mut i = 0;
        while (i < length) {
            let part = *vector::borrow(&parts, i);
            let key_values = string::split(&part, '=');
            if (vector::length(&key_values) == 2) {
                let key = *vector::borrow(&key_values, 0);
                let values = *vector::borrow(&key_values, 1);
                let values_vec = string::split(&values, ',');
                if (string::equals(&key, &string::utf8(b"level"))) {
                    let len_v = vector::length(&values_vec);
                    let mut j = 0;
                    while (j < len_v) {
                        let lvl_str = *vector::borrow(&values_vec, j);
                        if (string::equals(&lvl_str, &string::utf8(b"DEBUG"))) {
                            vector::push_back(&mut levels, LogLevel::DEBUG);
                        } else if (string::equals(&lvl_str, &string::utf8(b"INFO"))) {
                            vector::push_back(&mut levels, LogLevel::INFO);
                        } else if (string::equals(&lvl_str, &string::utf8(b"WARN"))) {
                            vector::push_back(&mut levels, LogLevel::WARN);
                        } else if (string::equals(&lvl_str, &string::utf8(b"ERROR"))) {
                            vector::push_back(&mut levels, LogLevel::ERROR);
                        }
                        j = j + 1;
                    }
                } else if (string::equals(&key, &string::utf8(b"module"))) {
                    let len_v = vector::length(&values_vec);
                    let mut j = 0;
                    while (j < len_v) {
                        let mod_str = *vector::borrow(&values_vec, j);
                        vector::push_back(&mut modules, mod_str);
                        j = j + 1;
                    }
                }
            }
            i = i + 1;
        }
        LogSpec { levels, modules }
    }

    /// Test function to exercise parsing and applying a log specification string
    public fun test_parse_run() {
        let config = string::utf8(b"level=DEBUG,INFO;module=mod1,mod2");
        let spec = parse_log_spec(config);
        // no error expected, no asserts needed
        let count_levels = vector::length(&spec.levels);
        let count_modules = vector::length(&spec.modules);
        // dummy use to avoid unused variable warnings
        let _ = count_levels + count_modules;
    }
}

//# run 0x1::LogSpec::test_parse_run


//# publish
module 0x1::InitMapping {
    use std::vector;
    use std::option;

    /// Storage for mapping results keyed by u8
    struct KeyValueMap has store {
        keys: vector<u8>,
        values: vector<u8>,
    }

    /// Initialize mapping by mapping keys to their lengths + 2, and each value + 3
    /// keys are bytes, so length here means number of keys??
    /// Interpretation: keys vector will be replaced by their length + 2, values incremented by 3
    public fun init(keys: &mut vector<u8>, values: &mut vector<u8>) {
        let len_keys = vector::length(keys);
        let mut i = 0;
        while (i < len_keys) {
            *vector::borrow_mut(keys, i) = (len_keys as u8) + 2;
            i = i + 1;
        }

        let len_vals = vector::length(values);
        let mut j = 0;
        while (j < len_vals) {
            let val = *vector::borrow(values, j);
            *vector::borrow_mut(values, j) = val + 3;
            j = j + 1;
        }
    }

    public fun run() {
        let mut keys = vector::empty<u8>();
        vector::push_back(&mut keys, 1);
        vector::push_back(&mut keys, 2);
        vector::push_back(&mut keys, 3);
        let mut values = vector::empty<u8>();
        vector::push_back(&mut values, 10);
        vector::push_back(&mut values, 20);
        vector::push_back(&mut values, 30);

        init(&mut keys, &mut values);

        // dummy uses to prevent unused variable warnings
        let _ = *vector::borrow(&keys, 0);
        let _ = *vector::borrow(&values, 0);
    }
}

//# run 0x1::InitMapping::run


//# publish
module 0x1::LogFormatter {
    use std::string;
    use std::vector;
    use std::u64;
    use std::ascii;

    /// Log level enum
    #[derive(copy, drop, store)]
    public enum LogLevel {
        DEBUG,
        INFO,
        WARN,
        ERROR,
    }

    /// A log record struct
    struct LogRecord has copy, drop, store {
        timestamp: u64,
        level: LogLevel,
        module_path: string::String,
        message: string::String,
    }

    /// Format log records into a string:
    /// <timestamp> [<level>] <module_path>: <message>
    public fun format_log(record: &LogRecord): string::String {
        let mut out = string::int_to_string(record.timestamp);
        string::append(&mut out, string::utf8(b" ["));

        let level_str = log_level_to_string(record.level);
        string::append(&mut out, level_str);
        string::append(&mut out, string::utf8(b"] "));
        string::append(&mut out, record.module_path.clone());
        string::append(&mut out, string::utf8(b": "));
        string::append(&mut out, record.message.clone());
        out
    }

    /// Convert LogLevel to string
    public fun log_level_to_string(level: LogLevel): string::String {
        match level {
            LogLevel::DEBUG => string::utf8(b"DEBUG"),
            LogLevel::INFO => string::utf8(b"INFO"),
            LogLevel::WARN => string::utf8(b"WARN"),
            LogLevel::ERROR => string::utf8(b"ERROR"),
        }
    }

    /// Runner function to test formatting
    public fun run() {
        let record = LogRecord {
            timestamp: 1627846384,
            level: LogLevel::WARN,
            module_path: string::utf8(b"My::Module"),
            message: string::utf8(b"Something happened"),
        };
        let formatted = format_log(&record);

        // dummy usage to prevent warnings
        let _len = string::length(&formatted);
    }
}

//# run 0x1::LogFormatter::run


//# run
script {
    use 0x1::LogSpec;
    use 0x1::InitMapping;
    use 0x1::LogFormatter;
    use std::string;
    use std::vector;

    fun main() {
        // Test LogSpec parsing from config string
        LogSpec::test_parse_run();

        // Test init mapping function with vectors
        let mut keys = vector::empty<u8>();
        vector::push_back(&mut keys, 42);
        vector::push_back(&mut keys, 5);
        let mut values = vector::empty<u8>();
        vector::push_back(&mut values, 10);
        vector::push_back(&mut values, 20);
        InitMapping::init(&mut keys, &mut values);

        // Compose a log record and format it
        let record = LogFormatter::LogRecord {
            timestamp: 1234567890,
            level: LogFormatter::LogLevel::INFO,
            module_path: string::utf8(b"ScriptModule"),
            message: string::utf8(b"Testing log formatting"),
        };
        let formatted = LogFormatter::format_log(&record);

        // dummy usage to keep vars alive
        let _ = formatted;
    }
}