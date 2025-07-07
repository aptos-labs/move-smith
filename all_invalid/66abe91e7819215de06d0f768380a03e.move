//# publish
module 0xCAFE::ModuleA {
    use std::vector;

    // Define a struct with copy and drop abilities so it can be copied/moved freely.
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
    // so we assign all values to variables.
    public fun test_unpack_lvalue() {
        let (a, b) = get_u8_pair();
        // Also test multiple assignment from a vector of u64 by indexing.
        let arr = vector::empty<u64>();
        vector::push_back(&mut arr, 100u64);
        vector::push_back(&mut arr, 200u64);
        // Test lvalue range list assignment (multiple assignment)
        // Since Move does not support direct range assignment syntax (like in Rust),
        // we simulate it by multiple let bindings with tuple unpacking.
        // Actually, the lvalue range is for multiple-variable assignment with tuples,
        // so here we just show multiple let bindings.
        let (x, y) = (arr[0], arr[1]);
        // Do nothing with x, y to keep compiler happy.
        // Hopefully this exercises the compiler paths well.
    }
}

//# run 0xCAFE::ModuleA::test_unpack_lvalue --signers 0xCAFE

//# publish
module 0xCAFE::ModuleB {
    // Import u8 (primitive type) and test aliasing by importing std::signer as a new type name.
    use std::u8;
    use std::signer as AliasSigner;

    // Public function that takes an alias type signer argument to test alias.
    public fun test_alias(s: &AliasSigner) {
        // Do nothing, just to make sure alias works.
        let _ = *s;
    }

    // Runner function with signer argument.
    public fun runner(s: &AliasSigner) {
        test_alias(s);
    }
}

//# run 0xCAFE::ModuleB::runner --signers 0xCAFE

//# publish
module 0xCAFE::ModuleC {
    // Import specific members from ModuleA using braces with alias.
    use 0xCAFE::ModuleA::{Pair, test_unpack_lvalue as test_unpack};

    // Function that creates a Pair and calls test_unpack_lvalue indirectly.
    public fun run_indirect() {
        let p = Pair { x: 1u64, y: 2u64 };
        // Dummy usage of Pair fields
        let x_val = p.x;
        let y_val = p.y;
        // Call the aliased function.
        test_unpack();
    }
}

//# run 0xCAFE::ModuleC::run_indirect

//# run
script {
    use 0xCAFE::ModuleA::{get_u8_pair};
    use 0xCAFE::ModuleB::runner;
    use 0xCAFE::ModuleC::run_indirect;

    fun main() {
        // Test tuple unpacking with lvalue by calling get_u8_pair and unpacking.
        let (v1, v2) = get_u8_pair();

        // Call module B's runner function.
        runner(&signer);

        // Call module C's function to test import and aliasing of module members.
        run_indirect();
    }
}

// Featurres:
// 0615194276ddfa3b8200fc21b79cb2ba: Use lvalue with range lists to assign multiple variables efficiently.
// 6027537863a2e7c5e74d6c3d82e94650: Import specific members of a module enclosed in braces with optional aliases
// 0374e97dd2a856420c4b5b0bc9d974d5: Implement functions in target modules to ensure they are subject to the move compiler checks.
