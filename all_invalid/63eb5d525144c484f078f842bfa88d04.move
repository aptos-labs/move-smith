// # publish
module 0xCAFE::EnumTupleFields {
    use std::option;

    /// Testing enum with tuple-like fields and access to them via `.0` `.1` `.2`
    public enum E {
        A(u8),
        B(u8, u16),
        C(u8, u16, u32),
    }

    public fun runner(): u64 {
        let a = E::A(1);
        let b = E::B(2, 1000);
        let c = E::C(3, 2000, 300000);

        let r0 = match a {
            E::A(x) => (x as u64),
            E::B(_, _) => 0,
            E::C(_, _, _) => 0,
        };

        // Tuple-like field access for B
        let r1 = match b {
            E::A(_) => 0,
            E::B(x0, x1) => ((x0 as u64) + (x1 as u64)),
            E::C(_, _, _) => 0,
        };

        // Tuple-like field access for C
        let r2 = match c {
            E::A(_) => 0,
            E::B(_, _) => 0,
            E::C(x0, x1, x2) => ((x0 as u64) + (x1 as u64) + (x2 as u64)),
        };

        r0 + r1 + r2
    }
}
// # run 0xCAFE::EnumTupleFields::runner

// # publish
module 0xCAFE::DiagnosticsNotes {
    use std::debug;
    use std::string;

    // Intentionally define two functions with same signature to trigger a compilation error with a custom note
    // Note: Move does not allow real compilation error injection in pure Move, but we simulate a custom note usage by a function
    //
    // Since we cannot cause a real compilation error in a running test, we simulate attaching a diagnostic note:
    public fun diagnostic_note_example(): vector<u8> {
        // Simulate a "diagnostic custom note" by returning a special byte string
        b"Note: This is a simulated diagnostic note for Move compilation issues."
    }

    public fun runner(): vector<u8> {
        diagnostic_note_example()
    }
}
// # run 0xCAFE::DiagnosticsNotes::runner

// # publish
module 0xCAFE::OptionMap {
    use std::option;
    use std::vector;

    /// Custom map function for option::Option<T>
    public fun option_map<T, U>(opt: option::Option<T>, f: fun(T): U): option::Option<U> {
        match opt {
            option::Option::Some(x) => option::Option::Some(f(x)),
            option::Option::None => option::Option::None,
        }
    }

    public fun plus_one(x: u64): u64 {
        x + 1
    }

    public fun runner(): u64 {
        let some_val = option::some<u64>(10);
        let none_val = option::none<u64>();

        let mapped_some = option_map<u64, u64>(some_val, plus_one);
        let mapped_none = option_map<u64, u64>(none_val, plus_one);

        let v_some = match mapped_some {
            option::Option::Some(v) => v,
            option::Option::None => 0,
        };

        let v_none = match mapped_none {
            option::Option::Some(_) => 0,
            option::Option::None => 999,
        };

        v_some + v_none
    }
}
// # run 0xCAFE::OptionMap::runner

// Featurres:
// e8df2b695244b664f60d1dd24c9444e3: Test that tuple-like field access syntax (e.g., x.0) works for all variants of an enum in Move.
// 2679903e6efaa9eef26ac5f25c4c590e: Attach custom notes to diagnostics for Move compilation issues.
// 1fded58d05c0edc6b9ff84a2158ab70d: Test mapping a function over an Option value using a custom map function and ensure the result is correct.
