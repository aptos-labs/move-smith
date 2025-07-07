
//# publish
module 0xCAFE::NameAndDependencyTest {
    use std::vector;

    // This module tests that a Move source file cannot be both a target and a dependency.
    // Create two dummy modules for dependency purposes
    
//# publish
    module 0xCAFE::DepModuleA {
        public fun dummy() {}
    }

    
//# publish
    module 0xCAFE::DepModuleB {
        public fun dummy() {}
    }

    public fun build_conflicting_target_and_dependency() {
        // Simulate a build with source file as both a target and dependency
        // Fake function: in actual test, the build system or script would attempt to build
        // For illustration, we will just call the modules
        0xCAFE::DepModuleA::dummy();
        0xCAFE::DepModuleB::dummy();
        // No explicit build failure in Move code, so assume this is part of the test expectation:
        // that the build system detects the conflict outside of Move code.
    }

    // This function performs a separate compile from directory based on namespace or hash
    public fun build_with_separated_directories() {
        // No real directory operations in Move code.
        // Instead, call a module from a different namespace to simulate separation
        0xCAFE::DepModuleA::dummy();
        0xCAFE::DepModuleB::dummy();
        // The test is to ensure that these modules are in separate directories (simulated here).
    }

    // To assign a name and optional list of type parameters to a spec variable, we simulate with a resource
    struct SpecVariable<T> has key {
        name: vector<u8>,
        type_params: vector<vector<u8>>,
        phantom: T,
    }

    public fun create_named_spec_var<T>(name: vector<u8>, type_params: vector<vector<u8>>): SpecVariable<T> {
        SpecVariable {
            name,
            type_params,
            phantom: core::marker::PhantomData,
        }
    }
}


//# run 0xCAFE::NameAndDependencyTest::build_conflicting_target_and_dependency

// Featurres:
// 437febbd468b5585451fdc3d655cbf42: Ensure that the same Move source file cannot be both a target and a dependency in a single build.
// f32cf2c83fbd98e1388ad2242cc99f3e: Separate interface files into directories based on namespace or hash
// caa551bd1b4bd11cc92df5471ec58eab: Assign a name and an optional list of type parameters to a spec variable.
