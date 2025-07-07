
    // test_attribute]
//# publish
    module AnnotatedModule {
        // Demonstrate an address block with a custom attribute
        public fun dummy(): u8 {
            42
        }
    }
}


//# publish
module 0xCAFE::ErrorModuleIdentifier {
    // Attempt usage of module identifier in invalid places to provoke errors.

    // WRONG: Use module name as a type (should produce error)
    // Uncomment to see compile error:
    // public fun use_module_as_type(): ErrorModuleIdentifier {
    //     // error: expected a type, found module identifier
    //     abort 1;
    // }

    // WRONG: Use module name as expression (should produce error)
    // Uncomment to see compile error:
    // public fun use_module_as_expr(): u8 {
    //     let x = ErrorModuleIdentifier;
    //     0
    // }

    public fun call_internal(): u8 {
        7u8
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::ErrorModuleIdentifier;

    // Function that calls another function inside the same module
    public fun call_internal_func(): u8 {
        let val = ErrorModuleIdentifier::call_internal();
        val
    }
}


//# run 0xCAFE::AnnotatedModule::dummy


//# run 0xCAFE::CallerModule::call_internal_func


// Featurres:
// e30b6d6876139e1eee8c37c6d43041e2: Annotate Move address blocks with custom attributes.
// 27b5c8e4883490f2937d6c88b04c7869: Receive clear error messages when attempting to use a module identifier in place of a type or expression in your Move code.
// c275d7b911cf739ee3d9b05d148790bf: Identify functions within module M that are called by the current function. 
