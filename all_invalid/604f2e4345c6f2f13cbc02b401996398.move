
//# publish
module 0xCAFE::PatternStructTest {
    use std::signer;

    struct Inner has copy, drop, store {
        a: u8,
        b: u16,
    }

    struct Outer has copy, drop, store {
        x: Inner,
        y: u8,
    }

    struct NewFields has copy, drop, store {
        p: u8,
        q: u16,
        r: u8,
    }

    public fun unwrap_and_construct(o: Outer): NewFields {
        let Outer { x: Inner { a, b }, y } = o;
        // Construct and return NewFields from unwrapped values
        NewFields { p: a, q: b, r: y }
    }

    public fun runner() {
        let inner = Inner { a: 10, b: 500 };
        let outer = Outer { x: inner, y: 20 };
        let _ = unwrap_and_construct(outer);
    }
}


//# run 0xCAFE::PatternStructTest::runner



//# publish
module 0xCAFE::DiagnosticsTest {
    use std::debug;

    // A function that intentionally triggers safe abort with a diagnostic code
    public fun trigger_abort() {
        // Abort with a specific error code to generate diagnostic info
        debug::abort(1234);
    }

    public fun runner() {
        trigger_abort();
    }
}


//# run 0xCAFE::DiagnosticsTest::runner



//# publish
module 0xCAFE::ScriptAnnotationTest {
    use std::signer;

    // A sample function to be called from script
    public fun add_numbers(a: u64, b: u64): u64 {
        a + b
    }

    // Default specs like preconditions can be added here
    spec fun add_numbers_spec(a: u64, b: u64) {
        ensures result == a + b;
    }

    public fun runner() {
        let _ = add_numbers(15, 25);
    }
}


//# run 0xCAFE::ScriptAnnotationTest::runner



//# run 0xCAFE::PatternStructTest::unwrap_and_construct --args 0xCAFE::PatternStructTest::Outer{ x: 0xCAFE::PatternStructTest::Inner{ a: 7u8, b: 42u16 }, y: 3u8 }


//# run 0xCAFE::DiagnosticsTest::trigger_abort


//# run 0xCAFE::ScriptAnnotationTest::add_numbers --args 100u64 200u64


// Featurres:
// e1edb0b78d698d134e8bac8aefa5afdb: Construct and return a new fields structure from assignable values after unwrapping pattern fields.
// 22dc5a71e4f920aae3d8a5ee670ff17e: Generate colored diagnostic output for Move compiler diagnostics
// a77c8f3e6cf2b64e2b4a2eb5303e8e69: Annotate scripts with their source locations and include function information with default specifications.
