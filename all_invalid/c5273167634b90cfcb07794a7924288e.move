
//# run 0xCAFE::AdvancedFeatures::variable_scope_test --signers 0xBADD --args

//# run 0xCAFE::AdvancedFeatures::create_and_modify_struct --signers 0xBADD --args 5, b"Test", true

//# run 0xCAFE::AdvancedFeatures::capture_copy_var --signers 0xBADD --args 10

//# run 0xCAFE::AdvancedFeatures::capture_drop_var --signers 0xBADD --args 0xDropResource{ state: 1 }

//# run 0xCAFE::AdvancedFeatures::shadowing_test --signers 0xBADD
