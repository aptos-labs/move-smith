// #publish
module 0xCAFE::ModuleA {
    spec inline fun foo(): bool for_inline {
        true
    }

    public fun runner(): bool {
        // calling the inline spec function here
        spec {
            // calling foo should inline it
            assert!(foo());
        }
        true
    }
}

// #run 0xCAFE::ModuleA::runner

// #publish
module 0xCAFE::ModuleB {
    use 0xCAFE::ModuleA;

    public fun call_a_runner(): bool {
        // call function from ModuleA
        ModuleA::runner()
    }
}

// #run 0xCAFE::ModuleB::call_a_runner


// The following module intentionally repeats ModuleA to test compiler error
// If the test framework captures duplicate module error, it should trigger here
// #publish
module 0xCAFE::ModuleA {
    public fun dummy(): bool {
        true
    }
}

// Featurres:
// 0826263e309bbe8ed6cee2b0c62077ac: Create inline specification functions by setting the 'for_inline' parameter, resulting in functions with 'inline_' prefix in their names.
// 19bdefef557fa1dd4f87aed112b1ff88: Prevent multiple modules with the same name from being defined in the same compilation context
// fd4b1b73077e99bf22a55a18ee5a78fa: Declare 'use' statements in modules to import members from other modules.
