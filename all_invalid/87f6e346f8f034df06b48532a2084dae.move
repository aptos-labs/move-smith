
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

    // Function to run internal tests
    public fun run_tests() {
        let val1 = return_integer();
        let val2 = call_dep_func();
        // We leave out assertions per instructions
        // just to execute the functions
    }
}


//# run 0xCAFE::TestModule::run_tests


//# publish
module 0xCAFE::DependencyModule {
    // This module is used as a dependency
    // Function with no return
    public fun dep_func(): u64 {
        100u64
    }
}


//# run 0xCAFE::DependencyModule::dep_func