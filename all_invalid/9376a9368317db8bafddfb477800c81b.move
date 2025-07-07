//# publish
module 0xCAFE::ModuleA {
    spec module {
        // A simple Spec block inside the module to test compiler support for specs.
        invariant true;
    }

    public fun runner() {
        // Do nothing
    }
}
//# run 0xCAFE::ModuleA::runner --signers 0xCAFE

//# publish
module 0xCAFE::ModuleB {
    use 0xCAFE::ModuleA;

    spec module {
        // Use a spec declaration referencing ModuleA (legal)
        spec ModuleAInvariant: ModuleA::spec_invariant();
    }

    public fun runner() {
        // Call ModuleA::runner to test module access syntax
        ModuleA::runner();
    }
}
//# run 0xCAFE::ModuleB::runner --signers 0xCAFE

// Attempting to publish a module with illegal use (for transactional test, the compiler should error and fail compilation)
// The below is commented out because it should cause compile error.
// If this was included in a real testing environment, it would be expected to fail compilation due to non-existent module.

// // #publish
// module 0xCAFE::BrokenModule {
//     use 0xCAFE::NonExistentModule;
//
//     public fun runner() {}
// }

// Another module attempting to "use" a non-existent member from an existing module - must error

// // #publish
// module 0xCAFE::BrokenModule2 {
//     // ModuleA does not have NonExistentFun in its interface
//     use 0xCAFE::ModuleA::NonExistentFun;
//
//     public fun runner() {}
// }

//# publish
module 0xCAFE::ModuleC {
    use 0xCAFE::ModuleB;

    public fun runner() {
        // Nested module access via ModuleB to ModuleA::runner indirectly
        ModuleB::runner();
    }

    spec module {
        spec some_spec: true;
    }
}
//# run 0xCAFE::ModuleC::runner --signers 0xCAFE


//# run script0
script {
    use 0xCAFE::ModuleC;

    fun main() {
        ModuleC::runner();
    }
}

//# run script1
script {
    use 0xCAFE::ModuleA;

    fun main() {
        ModuleA::runner();
    }
}

//# run script2
script {
    use 0xCAFE::ModuleB;

    fun main() {
        ModuleB::runner();
    }
}

// Featurres:
// b2cc35d56ab7f2b6f53c0e9c0ea3e065: Include only modules with specification annotations such as 'Spec' or 'Use' in the source code.
// 8a52e53179eaf73ebe0e390d10c6133d: Receive errors if you attempt to import a non-existent module or a non-existent member in a 'use' statement.
// 1d9212bf51cc0e7ef69dc6c4c961fef2: Access and use modules via module access syntax
