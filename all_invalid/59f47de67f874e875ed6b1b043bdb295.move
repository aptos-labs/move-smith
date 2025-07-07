
//# publish
module 0xCAFE::ByteLiteralModule {
    // No package name specified here
    public fun get_literal(): vector<u8> {
        // Using a byte string literal
        b"Hello, Byte Literal!"
    }
}


//# publish
module 0xCAFE::NamedPackageModule {
    // Simulate package with metadata (not actual Move feature, but for test verification)
    // The package has a specified name "TestPackage"
    public fun get_named_literal(): vector<u8> {
        b"Named Package Byte String"
    }
}


//# publish
module 0xCAFE::MultiModuleGroup {
    // First submodule
//# publish
    module first {
        public fun first_literal(): vector<u8> {
            b"First Module Byte String"
        }
    }
    // Second submodule
//# publish
    module second {
        public fun second_literal(): vector<u8> {
            b"Second Module Byte String"
        }
    }
}


//# publish
module 0xCAFE::TestRunner {

    // Function to invoke ByteLiteralModule::get_literal
    public fun run_byte_literal_module(): vector<u8> {
        0xCAFE::ByteLiteralModule::get_literal()
    }

    // Function to invoke NamedPackageModule::get_named_literal
    public fun run_named_package_module(): vector<u8> {
        0xCAFE::NamedPackageModule::get_named_literal()
    }

    // Function to invoke MultiModuleGroup::first::first_literal
    public fun run_first_module(): vector<u8> {
        0xCAFE::MultiModuleGroup::first::first_literal()
    }

    // Function to invoke MultiModuleGroup::second::second_literal
    public fun run_second_module(): vector<u8> {
        0xCAFE::MultiModuleGroup::second::second_literal()
    }

    // Function to test cross-module calling and data passing
    public fun test_cross_module(): vector<u8> {
        let lit1 = 0xCAFE::MultiModuleGroup::first::first_literal();
        let lit2 = 0xCAFE::MultiModuleGroup::second::second_literal();
        // Concatenate the byte vectors
        let combined = vector::empty<u8>();
        vector::append(&mut combined, &lit1);
        vector::append(&mut combined, &lit2);
        combined
    }
}


//# run 0xCAFE::TestRunner::run_byte_literal_module

//# run 0xCAFE::TestRunner::run_named_package_module

//# run 0xCAFE::TestRunner::run_first_module

//# run 0xCAFE::TestRunner::run_second_module

//# run 0xCAFE::TestRunner::test_cross_module


// Featurres:
// 5f2a00cdcd250456968fb75d1c359440: Use byte string literals to include raw byte sequences within your code.
// 3ddca82693f12dd3cbb44d4d9a619e18: Define package metadata using optional package names.
// 5384dd53cb94407108d41c3fd47a4dc8: Define multiple modules in a single source file.
