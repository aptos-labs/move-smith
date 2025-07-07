// This transactional test covers:
// 1. Using native structs without field declarations
// 2. Setting environmental variables for compiler backtraces
// 3. Attempting to define two modules with the same name in one package should error on compile

// Use 0xCAFE for publishing and execution

// -------------
// 1. Test native structs without field declarations
//# publish
module 0xCAFE::NativeStructs {
    // Declare a native struct without any field
    native struct NativeEmpty has copy, drop, store;

    // A normal struct with fields to contrast
    struct RegularStruct has copy, drop, store {
        x: u64,
        y: u64,
    }

    public fun new_regular(): RegularStruct {
        RegularStruct { x: 42, y: 24 }
    }

    // Runner function: no arguments, just demonstrate usage of native struct type in Move
    public fun runner() {
        // create a regular struct
        let _r = new_regular();

        // cannot create native struct directly. But can declare variables with native struct type.
        let _n: NativeEmpty;

        // no operations but validates compiler recognizing native struct
    }
}
//# run 0xCAFE::NativeStructs::runner --signers 0xCAFE

// -------------
// 2. Test enabling and disabling Move compiler backtraces by environment variables

// This cannot be done inside Move code - environment variables are set outside
// But we simulate a module that tries to read an environment variable (CAN'T do directly in Move)
// Instead, we write a script that expects to be run with environment variables set externally,
// and inside the script, we force a panic to trigger backtrace and see if it appears (conceptually)
//
// So this step is actually outside Move's capabilities to query env vars inside Move code,
// but we still write a script that panics to force backtrace, user sets env var externally.
//
// We'll simulate this:
// Publish a module with a function that panics, then run a script that calls it.
//
//# publish
module 0xCAFE::BacktraceTest {
    public fun cause_panic(): u64 {
        assert!(false, 42); // Force panic with abort code 42
        0 // unreachable but needed to satisfy return type
    }
}
//# run 0xCAFE::BacktraceTest::cause_panic --signers 0xCAFE

//# run
script {
    use 0xCAFE::BacktraceTest;

    fun main() {
        // Calling a function which will always abort to test backtrace printing
        BacktraceTest::cause_panic();
    }
}

// -------------
// 3. Test defining two modules with the same name should error

// This is a compile-time error,
// so for test we do two publish commands consecutively with the same module name,
// the compiler should error.

//# publish
module 0xCAFE::DuplicateModule {
    public fun f(): u64 { 1 }
}

//# publish
module 0xCAFE::DuplicateModule {
    public fun f(): u64 { 2 }
}


// Featurres:
// e09532b2122bc1456e92219e9f2a0683: Include native structs without field declarations.
// c0b463c645a069228809bdbae2525b35: Enable or disable move compiler backtraces by setting specific environment variables.
// b624817f176acbc46aef772f9a0cdaed: Receive an error when defining two modules with the same name in a Move package.
