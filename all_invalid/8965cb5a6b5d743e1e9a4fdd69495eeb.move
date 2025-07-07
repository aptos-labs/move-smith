// Transactional test to exercise Move compiler and VM as required.

// === 1. FOR LOOP WITH INVARIANT PROPERTY ===

//# publish
module 0xA::ForLoopInvariant {
    // A function that iterates a vector, expecting all elements to be less than 10.
    public fun check_invariant(v: vector<u8>) {
        let i = 0;
        let len = Vector::length(&v);
        while (i < len) {
            // Ensure all elements < 10
            let x = *Vector::borrow(&v, i);
            assert!(x < 10, 1001);
            i = i + 1;
        }
    }

    // runner to test violation case
    public fun runner() {
        let v = vector[1u8, 2u8, 12u8, 3u8];
        // will abort at the third element (12u8 >= 10)
        Self::check_invariant(v);
    }

    // runner to test valid case
    public fun runner_ok() {
        let v = vector[2u8, 3u8, 4u8];
        Self::check_invariant(v);
    }
}
//# run 0xA::ForLoopInvariant::runner --signers 0xA    // should abort
//# run 0xA::ForLoopInvariant::runner_ok --signers 0xA  // should succeed

// === 2. NAME ACCESSIBILITY CHECK RULES ===

//# publish
module 0xB::NameRules {
    use std::string::String;
    use std::vector;

    // is_valid returns true if the name is [A-Za-z_][A-Za-z0-9_]* and not a reserved word
    public fun is_valid(name: &String): bool {
        // no reserved word logic for brevity, just simple character check
        let bytes = String::utf8(name);
        if (Vector::is_empty(&bytes)) {
            return false;
        };
        let first = *Vector::borrow(&bytes, 0);
        if (!(Self::is_letter(first) || first == 95)) { // 95 == '_'
            return false;
        };
        let i = 1;
        let n = Vector::length(&bytes);
        while (i < n) {
            let b = *Vector::borrow(&bytes, i);
            if (!(Self::is_letter(b) || Self::is_digit(b) || b == 95)) {
                return false;
            };
            i = i + 1;
        };
        true
    }

    fun is_letter(ch: u8): bool {
        (ch >= 65 && ch <= 90) || (ch >= 97 && ch <= 122)
    }

    fun is_digit(ch: u8): bool {
        ch >= 48 && ch <= 57
    }

    // runner for various test cases (valid/invalid)
    public fun runner() {
        let n1 = String::utf8(b"test_name");
        let n2 = String::utf8(b"_abc99");
        let n3 = String::utf8(b"7bad");
        let n4 = String::utf8(b"goodName3");
        let n5 = String::utf8(b"-invalid");

        assert!(Self::is_valid(&n1), 1002);
        assert!(Self::is_valid(&n2), 1002);
        assert!(!Self::is_valid(&n3), 1003);
        assert!(Self::is_valid(&n4), 1002);
        assert!(!Self::is_valid(&n5), 1003);
    }
}
//# run 0xB::NameRules::runner --signers 0xC

// === 3. CONFIGURE LOGGING ===

//# publish
module 0xC::AppLogger {
    use std::debug;
    use std::string::{self, String};
    use std::signer;

    // Simple logging configuration: set log level and emit log
    public fun setup_logging_and_log(msg: String, level: u8, acc: &signer) {
        // Simulate setting a log level (for illustration - in practice, Move logging
        // is not configurable like in Rust, but exercise the concept)
        let sender = signer::address_of(acc);
        let prefix = string::concat(string::utf8(b"[LVL "), string::from_u8(level));
        let prefix = string::concat(prefix, string::utf8(b"] "));
        let log_msg = string::concat(prefix, msg);
        debug::print(&log_msg);
        // No assertion, just show that logging compiles and runs
    }

    public fun runner(acc: &signer) {
        let msg = string::utf8(b"Testing log system");
        Self::setup_logging_and_log(msg, 2u8, acc)
    }
}
//# run 0xC::AppLogger::runner --signers 0xC

// === 4. PROGRAM DEFINITION VIA MOVE COMPILER API - PROGRAM STRUCTURE DEMONSTRATION ===

//# publish
module 0xD::ProgramDefinition {
    // Pretend program structure (not executable here, but illustrates syntax tree/structure)

    /// Represents a source "unit" and dependency, like MoveCompiler API might see.
    struct Package has copy, drop {
        name: vector<u8>,
        major: u8,
        minor: u8,
    }

    public fun runner() {
        let pkg = Package {
            name: b"MyApp".to_vec(),
            major: 1u8,
            minor: 0u8,
        };
        let n = Vector::length(&pkg.name);
        // Trivial check to exercise the type
        assert!(n > 0, 9901);
    }
}
//# run 0xD::ProgramDefinition::runner --signers 0xDEAD