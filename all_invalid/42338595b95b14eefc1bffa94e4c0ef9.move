
//# publish
module 0xCAFE::TestModule {
    use 0xCAFE::DependencyModule;

    // Function with explicit return type
    public fun return_integer(): u64 {
        42u64
    }

    // Function that calls another module's function
    public fun call_dep_func(): u64 {
        DependencyModule::dep_func()
    }

    // Function with package metadata (using optional package name)
    // Note: Move doesn't have explicit syntax for package metadata in source,
    // but for testing, assume a comment or annotation to simulate package info.
    // Alternatively, we can declare optional package name in module declaration if supported.
    // Since the spec mentions optional package names, we simulate this with a comment.
    // e.g., // package_name: MyPackage
}


//# run 0xCAFE::TestModule::return_integer

//# run 0xCAFE::TestModule::call_dep_func


//# publish
module 0xCAFE::DependencyModule {
    // This module is used as a dependency
    // Function with no return
    public fun dep_func(): u64 {
        100u64
    }
}


//# run 0xCAFE::DependencyModule::dep_func

// Featurres:
// 9a746c69b3deda200132aaa80170a57f: Specify return types for functions
// 3ddca82693f12dd3cbb44d4d9a619e18: Define package metadata using optional package names.
// 30cf24c5e166194fa65e2c2380510d3b: Import other modules using 'use' dependencies.
