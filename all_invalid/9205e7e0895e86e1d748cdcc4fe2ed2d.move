//# publish
module 0x1::AbilitiesExample {
    // Test 1: Declare abilities with 'has' keyword.
    // Define a struct with multiple abilities.
    struct S has copy, drop, store {
        value: u64,
    }

    // Define a resource struct with only store ability.
    struct R has store {
        counter: u8,
    }

    // Runner function to ensure module compiles and structs are recognized.
    public fun runner() {
        let _ = S { value: 10 };
        let _ = R { counter: 5 };
    }
}
//# run 0x1::AbilitiesExample::runner


//# publish
module 0x1::InlineFunctionCalling {
    use 0x1::AbilitiesExample;

    // An inline helper function, pure computation.
    // Returns x + 10.
    public inline fun add_ten(x: u64): u64 {
        x + 10
    }

    // Another inline function that calls add_ten and adds 5.
    public inline fun nested_add(x: u64): u64 {
        let base = add_ten(x);
        base + 5
    }

    // Public function which uses nested inline functions and returns result.
    public fun compute_value(x: u64): u64 {
        nested_add(x)
    }

    // Runner function calls compute_value with an example.
    public fun runner(): u64 {
        compute_value(7)
    }
}
//# run 0x1::InlineFunctionCalling::runner


//# run
script {
    use 0x1::InlineFunctionCalling;

    fun main() {
        // Test 3: Operator precedence and logical assertions.
        // Logical NOT and AND precedence check
        let a = true && !false;  // true && true == true
        let b = (true || false) && !false; // (true) && true == true
        let c = 4 + 3 * 2;       // 4 + (3*2) = 4 + 6 = 10
        let d = (4 + 3) * 2;     // (7)*2 = 14
        let e = (5 & 3) == 1;    // 5 (0b0101) & 3 (0b0011) == 1 (0b0001), true
        let f = (8 >> 1) == 4;   // 8 >> 1 = 4, true
        let g = (15 ^ 7) == 8;   // 15 (0b1111) ^ 7 (0b0111) == 8 (0b1000)
        
        assert!(a);
        assert!(b);
        assert!(c == 10);
        assert!(d == 14);
        assert!(e);
        assert!(f);
        assert!(g);

        // Also check logical combination
        let h = !((false || false) && (3 > 5));
        assert!(h);
    }
}

//# publish
module 0x1::EnvironmentBacktrace {
    use std::debug;

    /// This function attempts to generate backtrace conditionally based on environment.
    /// Under certain env variable, it prints backtrace.
    public fun maybe_print_backtrace() {
        // If the environment variable "APTOS_BACKTRACE" is "1", then print backtrace.
        let env = debug::get_env("APTOS_BACKTRACE");
        // env is Option<vector<u8>>
        if (debug::option::is_some(&env)) {
            let val = debug::option::borrow(&env);
            let s = debug::string::utf8(val);
            if (debug::string::eq(&s, "1")) {
                debug::print_backtrace();
            }
        }
    }

    public fun runner() {
        // call maybe_print_backtrace, no assertion needed.
        maybe_print_backtrace();
    }
}
//# run 0x1::EnvironmentBacktrace::runner


//# publish
module 0x1::BytecodeLabelRemover {
    /// This module simulates removing the leading label from a bytecode instruction list.
    /// For testing purposes, we treat a vector<u8> as bytecode and remove the leading label prefix.

    /// Removes the leading label (prefix bytes) if present.
    /// For simplicity, assume label prefix is a single byte 0xFF followed by a length byte,
    /// and the label bytes follow. We remove the full prefix.
    public fun remove_leading_label(code: vector<u8>): vector<u8> {
        let len = Vector::length(&code);
        if (len < 2) {
            // Too short, no label
            return code;
        };
        let first_byte = *Vector::borrow(&code, 0);
        if (first_byte != 0xFF) {
            // No label prefix
            return code;
        };
        let label_len = *Vector::borrow(&code, 1) as u8;
        let skip = 2 + label_len as u64;
        if (skip > len) {
            // Invalid label length, return code as is
            return code;
        };
        Vector::sub_vector(&code, skip, len)
    }

    /// Runner function constructs a vector<u8> with a leading label and tests removal.
    public fun runner() {
        let label_bytes = vector[0xAA, 0xBB, 0xCC];
        let mut labeled_code = vector[0xFF, 3u8];
        Vector::append(&mut labeled_code, label_bytes);
        let code_bytes = vector[0x01, 0x02, 0x03, 0x04];
        Vector::append(&mut labeled_code, code_bytes);

        let cleaned = remove_leading_label(labeled_code);
        // Expect cleaned to be equal to code_bytes (0x01,0x02,0x03,0x04)
        // No assertion needed per instructions.
        let _ = cleaned;
    }
}
//# run 0x1::BytecodeLabelRemover::runner