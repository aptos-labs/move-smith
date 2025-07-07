//# publish
module 0xCAFE::ModuleA {
    use std::vector;

    // Define a struct with copy and drop abilities so it can be copied/moved freely.
    // Fields are private by default, so no external access permitted.
    struct Pair has copy, drop, store, key {
        x: u64,
        y: u64,
    }

    // A function that returns a tuple of u8 to test tuple unpacking with lvalues.
    public fun get_u8_pair(): (u8, u8) {
        (10u8, 20u8)
    }

    // A "runner" function to test tuple unpacking and lvalue ranges.
    //
    // We'll assign multiple variables from a tuple using lvalue range list.
    //
    // Move unpacking from tuples does not support underscore assignment,
    // so we assign all values to variables but prefix with underscore to avoid warnings.
    public fun test_unpack_lvalue() {
        let (_a, _b) = get_u8_pair();
        // Also test multiple assignment from a vector of u64 by indexing.
        let arr = vector::empty<u64>();
        vector::push_back(&arr, 100u64);
        vector::push_back(&arr, 200u64);
        // Test lvalue range list assignment (multiple assignment)
        // Since Move does not support direct range assignment syntax (like in Rust),
        // we simulate it by multiple let bindings with tuple unpacking.
        let (_x, _y) = (vector::borrow(&arr, 0), vector::borrow(&arr, 1));
        // Do nothing with _x, _y to keep compiler happy.
        // Hopefully this exercises the compiler paths well.
    }
}

//# run 0xCAFE::ModuleA::test_unpack_lvalue --signers 0xCAFE

//# publish
module 0xCAFE::ModuleB {
    // No need to alias signer from std, it is builtin
    // Public function that takes signer reference argument to test alias.
    public fun test_alias(s: &signer) {
        // Do nothing, just to make sure alias works.
        let _ = *s;
    }

    // Runner function with signer argument.
    public fun runner(s: &signer) {
        test_alias(s);
    }
}

//# run 0xCAFE::ModuleB::runner --signers 0xCAFE

//# publish
module 0xCAFE::ModuleC {
    use 0xCAFE::ModuleA::{Pair, test_unpack_lvalue as test_unpack};

    // Provide public accessor functions to access Pair fields
    public fun get_x(p: &Pair): u64 {
        p.x
    }

    public fun get_y(p: &Pair): u64 {
        p.y
    }

    // Function that creates a Pair and calls test_unpack_lvalue indirectly.
    public fun run_indirect() {
        let p = Pair { x: 1u64, y: 2u64 };
        // Dummy usage of Pair fields via accessor functions
        let _x_val = get_x(&p);
        let _y_val = get_y(&p);
        // Call the aliased function.
        test_unpack();
    }
}

//# run 0xCAFE::ModuleC::run_indirect --signers 0xCAFE

//# run
script {
    use 0xCAFE::ModuleA::{get_u8_pair};
    use 0xCAFE::ModuleB::runner;
    use 0xCAFE::ModuleC::run_indirect;

    fun main(signer: &signer) {
        // Test tuple unpacking with lvalue by calling get_u8_pair and unpacking.
        let (_v1, _v2) = get_u8_pair();

        // Call module B's runner function.
        runner(signer);

        // Call module C's function to test import and aliasing of module members.
        run_indirect();
    }
}