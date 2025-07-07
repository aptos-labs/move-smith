//# publish
module 0x1::AccessControlTest {
    /// Test access control modifiers
    public struct Holder has key {
        value: u64
    }

    /// Public function accessible everywhere
    public fun public_function(): u64 {
        42
    }

    /// Friend function accessible within the module (no friend in Move, instead "script" is private)
    script fun script_function(): u64 {
        24
    }

    /// Private function accessible only in this module
    fun private_function(): u64 {
        11
    }

    /// Public entry function to test access control
    public entry fun runner(_signer: &signer) {
        let _ = public_function();
        let _ = script_function();
        let _ = private_function();
        let _holder = Holder { value: 99 };
    }
}
//# run 0x1::AccessControlTest::runner --signers 0x1


//# publish
module 0x1::SpecModules {
    /// Spec module 1
    spec module 0x1::SpecMod1 {
        spec fun spec_fn1(): bool { true }
    }
    /// Spec module 2
    spec module 0x1::SpecMod2 {
        spec fun spec_fn2(): u64 { 100 }
    }
    /// Spec module 3
    spec module 0x1::SpecMod3 {
        spec fun spec_fn3(): u8 { 7 }
    }

    /// A module to merge specification modules into a collection
    /// Note: This is a Rust-level testing pattern, but for Move testing,
    /// we simulate merging spec modules by referencing them via specs
    /// inside this singleton module's spec block.

    spec module 0x1::SpecCollection {
        spec const all_specs_exist: bool = 
            0x1::SpecMod1::spec_fn1()
            && (0x1::SpecMod2::spec_fn2() == 100)
            && (0x1::SpecMod3::spec_fn3() == 7);
    }

    /// Runner function to use the spec collection in a dummy way
    public entry fun runner(_signer: &signer) {
        // Nothing needed here - just compile and link specs together
    }
}
//# run 0x1::SpecModules::runner --signers 0x1


//# publish
module 0x1::CompilerErrorTest {
    /// Function with intentional compiler error: cannot use mutable borrow of immutable variable
    public fun cause_error(): u64 {
        let x = 10;
        let ref mut r = &x;  // Error: cannot borrow immutable local variable `x` as mutable
        *r = 20;
        *r
    }

    /// Runner to attempt to call the error function - will not compile, so the compile fails and 
    /// output goes to standard error, exercising Move compiler error reporting.
    public entry fun runner(_signer: &signer) {
        // Intentionally left empty; cause_error will cause compiler failure
    }
}
// No run command since it fails to compile

//# run
script {
    // Transactional test script to exercise the three modules above at once
    use 0x1::AccessControlTest;
    use 0x1::SpecModules;

    fun test_all() {
        let signer = @0x1;
        AccessControlTest::runner(&signer);
        SpecModules::runner(&signer);

        // The CompilerErrorTest::cause_error() is intentionally left uncompilable
        // to test compiler error emission to stderr.
        // So we do not call it here in Move code.
    }

    test_all();
}