// Set the language version to ensure compatibility and feature support

//# publish
module 0xCAFE::VersionControl {
    public fun get_version(): u64 {
        1 // simple version number for testing
    }
}

// Define a new module to test untyped numeric literals and version setting
// # publish
module 0xCAFE::NumericLiteralTest {

    // Store a numeric literal directly as a value, testing untyped literals
    public fun test_numeric_literals(): u64 {
        42 // numeric literal directly used as a value
    }

    // Function to get the current language version for testing
    // This function calls the previous VersionControl module
    public fun get_lang_version(): u64 {
        0xCAFE::VersionControl::get_version()
    }
}

// Define a script to convert a ModuleId of a module and demonstrate version access
// # run
script {
    // For illustration: Store the ModuleId for 0xCAFE::NumericLiteralTest
    // Note: In actual tests, optional module name to ModuleId conversion involves standard library or scripting
    let module_id = move_std::language_storage::module_id::<0xCAFE::NumericLiteralTest>();
    // Fetch the version from VersionControl
    let version = 0xCAFE::NumericLiteralTest::get_lang_version();
}

// Run the get_version function from the VersionControl module to verify version control

//# run 0xCAFE::VersionControl::get_version --signers 0xCAFE

// Run the test_numeric_literals function to check how literals are used

//# run 0xCAFE::NumericLiteralTest::test_numeric_literals --signers 0xCAFE

// Featurres:
// 563ea888f47cb7a2f97179804e54fe52: Write untyped numeric literals directly as values.
// a4128e2ba6ab35bdb3bff531d7a2f912: Specify language versions for compiling your Move code to control feature support.
// b40fb666d5acfebe6c67900244b6caa5: Convert an optional module name to a ModuleId, resolving address aliases if necessary.
