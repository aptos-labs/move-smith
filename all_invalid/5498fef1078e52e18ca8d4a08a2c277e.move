//# publish
module 0x1::RModule {
    use std::signer;

    struct R has key {
        value: u64,
    }

    public fun create_r(account: &signer): R {
        R { value: 0 }
    }

    public fun update_r(r: &mut R, v: u64) {
        r.value = v;
    }

    public fun get_value(r: &R): u64 {
        r.value
    }
}

//# publish
module 0x1::TestDoFunction {
    use std::signer;
    use 0x1::RModule;

    struct Holder has key {
        r: RModule::R,
    }

    // runner function modifies resource R based on v's value
    public fun do(holder: &mut Holder, v: u64) {
        if (v % 2 == 0) {
            // even v, set value to 100
            RModule::update_r(&mut holder.r, 100);
        } else {
            // odd v, set value to 200
            RModule::update_r(&mut holder.r, 200);
        }
    }

    // runner to test do() with no arguments (hardcoded)
    public fun run_do() {
        // create a signer address for testing
        let addr = @0x1;
        let signer_ref = signer::spec(addr);
        let mut holder = Holder { r: RModule::create_r(&signer_ref) };
        do(&mut holder, 2);
        do(&mut holder, 3);
    }
}

//# run 0x1::TestDoFunction::run_do --signers 0x1

//# publish
// Using #[skip(...)] attribute to skip lint checks for this module
#[skip(vector-indexing, unused-variable)]
module 0x1::LintSkipModule {
    public fun f() {
        let unused = 42; // unused-variable should be skipped
        let v = vector::empty<u8>();
        // vector-indexing issues should be skipped
        if (false) {
            vector::borrow(&v, 0);
        }
    }
}

//# run 0x1::LintSkipModule::f

//# publish
// Spec module that must error if functions, structs, or constants are defined (simulate via comment)
// We define them here to generate compile errors in a spec module (no-run)
#[spec]
module 0x1::SpecModuleErrors {
    // Defining struct - should error in spec module
    struct ShouldError1 { val: u8 }

    // Defining function - should error in spec module
    public fun should_error_fun() {}

    // Defining constant - should error in spec module
    const CONST_ERR: u64 = 42;
}

// (No run, spec module - compile errors expected)

//# publish
module 0x1::NestedInlineFunctions {
    // nested inline functions
    public fun f1(x: u64): u64 {
        x + 5
    }
    inline fun f2(x: u64): u64 {
        x * 2
    }
    public fun compute(): u64 {
        // Applies f2 to 3, then f1 to result: f1(f2(3)) = (3*2)+5 = 11
        let tmp = f2(3);
        f1(tmp)
    }
}

//# run 0x1::NestedInlineFunctions::compute