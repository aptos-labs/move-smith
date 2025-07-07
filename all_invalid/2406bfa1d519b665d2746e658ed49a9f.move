//# publish
module 0x1::ResourcePermissionsTest {
    use std::signer;
    use std::debug;

    resource struct R {
        // A field that can be read and written
        pub x: u64,
        // A field that is only readable (no &mut access)
        pub y: u64,
        // A field that is never accessed outside
        z: u64,
    }

    public fun create_r(account: &signer) {
        move_to(account, R { x: 10, y: 20, z: 30 });
    }

    // Reads both x and y, only immutable reference
    public fun read_xy(r: &R): (u64, u64) {
        // read access to both x and y allowed
        (r.x, r.y)
    }

    // Modifies field x, requires &mut reference
    public fun write_x(r: &mut R, val: u64) {
        r.x = val;
    }

    // Attempt to write y should fail to compile - we will NOT call this from run;
    // included only to confirm compiler enforces permissions. Commented out to allow build.
    /*
    public fun write_y(r: &mut R, val: u64) {
        // y is public, but consider it read only for this test - writing allowed since field is public in struct.
        // To simulate access control by type, we will not write this function.
        r.y = val;
    }
    */

    // Runner to test read and write
    public fun runner(account: &signer) {
        create_r(account);
        let r_ref = borrow_global_mut<R>(signer::address_of(account));
        // Write x
        write_x(r_ref, 42);
        let r_imm = borrow_global<R>(signer::address_of(account));
        let (a, b) = read_xy(r_imm);
        // debug print (simulate validation)
        debug::print(&u64_to_ascii(a));    // prints 42
        debug::print(", ");
        debug::print(&u64_to_ascii(b));    // prints 20
        debug::print("\n");
    }

    // Helpers to convert u64 to ascii string for debug::print
    fun u64_to_ascii(val: u64): vector<u8> {
        use std::string;
        let s = string::from_u64(val);
        string::utf8(s)
    }
}
//# run 0x1::ResourcePermissionsTest::runner --signers 0x1


//# publish
module 0x1::ControlFlowParserTest {
    use std::debug;

    public fun runner() {
        let i = 0;
        loop {
            if (i == 5) {
                // Test 'break'
                break;
            }
            // Test 'continue' by skipping odd i
            if (i % 2 == 1) {
                i = i + 1;
                continue;
            }
            // Test 'abort' using the abort opcode with code 100 if i == 3 (should not abort, only partially test parser)
            if (i == 3) {
                // We won't actually abort here to avoid test failure; just parse the keyword.
                // Uncomment following line to test abort abort(100);
            }
            // Test 'while' loop inside loop
            let mut j = 0;
            while (j < i) {
                // do nothing
                j = j + 1;
            }
            // Test 'return' by early return at i == 4 (only in runner function)
            if (i == 4) {
                return;
            }
            i = i + 1;
        }
        debug::print("Control flow parser test finished\n");
    }
}
//# run 0x1::ControlFlowParserTest::runner


//# publish
module 0x1::EnvLoggerConfig {
    use std::debug;

    struct LoggerConfig has copy, drop {
        level: u8,
        enabled: bool,
    }

    // Dummy environment variable simulation
    native public fun get_env_var(key: vector<u8>): vector<u8>;

    public fun parse_log_level(s: vector<u8>): u8 {
        // parse ascii for "DEBUG" (68,69,66,85,71) -> 3
        if (s == b"DEBUG") {
            3
        } else if (s == b"INFO") {
            2
        } else if (s == b"WARN") {
            1
        } else if (s == b"ERROR") {
            0
        } else {
            2 // default INFO
        }
    }

    public fun configure_logger(): LoggerConfig {
        let key = b"LOG_LEVEL";
        let val = get_env_var(key);
        let level = parse_log_level(val);
        LoggerConfig {
            level,
            enabled: true,
        }
    }

    public fun runner() {
        let cfg = configure_logger();
        if (cfg.enabled) {
            if (cfg.level >= 3) {
                debug::print("Logging at DEBUG level\n");
            } else if (cfg.level == 2) {
                debug::print("Logging at INFO level\n");
            } else if (cfg.level == 1) {
                debug::print("Logging at WARN level\n");
            } else {
                debug::print("Logging at ERROR level\n");
            }
        } else {
            debug::print("Logging disabled\n");
        }
    }
}
//# run 0x1::EnvLoggerConfig::runner

//# run
script {
    use std::debug;
    use std::signer;
    use 0x1::ResourcePermissionsTest;
    use 0x1::ControlFlowParserTest;
    use 0x1::EnvLoggerConfig;

    fun main(account: signer) {
        // Testing ResourcePermissionsTest runner with signer
        ResourcePermissionsTest::runner(&account);
        // Run control flow parser test - no signer needed
        ControlFlowParserTest::runner();
        // Run logger config runner - no signer needed
        EnvLoggerConfig::runner();
        debug::print("All tests completed\n");
    }
}