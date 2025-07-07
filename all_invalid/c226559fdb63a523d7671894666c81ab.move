// Feature 1: Test function call cycles in modules

//# publish
module 0xC0DE::CycleTest {
    /// Simple function that calls another, creating no cycle
    public fun a() {
        b();
    }

    public fun b() {
        c();
    }

    public fun c() {
        // No call to a, so no cycle in this path
    }
}

//# run 0xC0DE::CycleTest::a --signers 0xC0DE

//# publish
module 0xFEED::DirectCycleTest {
    /// This module contains a direct cycle: f1 calls f2, and f2 calls f1.

    public fun f1() {
        f2();
    }

    public fun f2() {
        f1();
    }

    /// "runner" function that triggers the cycle (will fail in interpretation)
    public fun run_cycle() {
        f1();
    }
}

//# run 0xFEED::DirectCycleTest::run_cycle --signers 0xFEED

// Feature 2: Test collecting checker names from mock external checkers

//# publish
module 0xBEEF::CheckerCollector {
    /// Mock representation of checker names
    const EXPRESSION_CHECKERS: vector<vector<u8>> = vector[
        b"ExprChecker1",
        b"ExprChecker2"
    ];
    const BYTECODE_CHECKERS: vector<vector<u8>> = vector[
        b"BytecodeCheckerA",
        b"BytecodeCheckerB"
    ];

    /// Returns the names of registered expression checkers
    public fun get_expression_checkers(): vector<vector<u8>> {
        EXPRESSION_CHECKERS
    }

    /// Returns the names of registered stackless bytecode checkers
    public fun get_bytecode_checkers(): vector<vector<u8>> {
        BYTECODE_CHECKERS
    }

    /// Runner function to test getting checkers
    public fun run() {
        let _ec = get_expression_checkers();
        let _bc = get_bytecode_checkers();
        // just dummy use
        ()
    }
}
//# run 0xBEEF::CheckerCollector::run --signers 0xBEEF

// Feature 3: Test declared resource acquisition in function environment

//# publish
module 0xCAFE::ResourceTest {
    struct R has key {}

    /// Function declares acquisition of R
    public fun acquires_r(s: &signer) acquires R {
        // create as new resource and store it under the signer
        move_to<R>(s, R {});
    }

    /// Reads R to simulate a function that requires the resource
    public fun read_r(addr: address) acquires R {
        let _x = borrow_global<R>(addr);
        // Just demonstrating the borrow
    }

    /// Dummy runner function: publish then access resource
    public fun run(s: &signer) {
        acquires_r(s);
        let addr = signer::address_of(s);
        read_r(addr);
    }
}
//# run 0xCAFE::ResourceTest::run --signers 0xCAFE