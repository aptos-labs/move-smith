//# publish
module 0x1::VarInitTest {
    use std::debug;
 
    public fun runner_if_else_var_assign(s: signer) {
        let x: u8; // declared without an initial value
        let y = true;
        if (y) {
            x = 42;
        } else {
            x = 21;
        };
        debug::print<u8>(&x); // x should be 42
        // (Feature 1) x is declared without an initial value, assigned in if/else, and used after
        // Live vars: [x, s], then [s] after x is consumed.
        // Explicit trailing unit here (returns ()), for feature 2.
        ()
    }

    public fun runner_implicit_unit(_s: signer) {
        let n = 100;
        debug::print<u8>(&n);
        // Feature 2: No explicit trailing unit, should auto-append `()`
        // Live vars: [n, _s] at start, then [_s]
    }

    //<-- Live variable annotation style pseudo-comments [for feature 3]
    // 0: let x: u8;                // live: []
    // 1: let y = true;             // live: [x]
    // 2: if (y) { x = 42; } else { x = 21; }  
    //                              // live: [x, y]
    // 3: debug::print<u8>(&x);     // live: [x]
    // 4: ()                        // live: []
    
    // For runner_implicit_unit:
    // 0: let n = 100;              // live: []
    // 1: debug::print<u8>(&n);     // live: [n]
    // 2: (implicit) ()             // live: []

}

//# run 0x1::VarInitTest::runner_if_else_var_assign --signers 0x2
//# run 0x1::VarInitTest::runner_implicit_unit --signers 0x3

//# publish
module 0x1::ScriptUnitTest {
    use std::debug;

    // Feature 2: script with no explicit trailing unit.
    public fun runner_script_no_unit() {
        let a = 7;
        debug::print<u8>(&a);
        // (no explicit ())
        // Live vars: [a]
    }
}

//# run 0x1::ScriptUnitTest::runner_script_no_unit

//# run
script {
    use std::debug;
    fun main() {
        let x: u64;
        if (false) {
            x = 999;
        } else {
            x = 111;
        };
        debug::print<u64>(&x);
        // Feature 1: declared without initial value, assigned in if/else.
        // Feature 2: No explicit () at end; compiler must add it.
        // Live vars: [x]
    }
    main();
}