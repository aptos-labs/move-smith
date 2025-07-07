
//# run 0xBADD::ComplexFeatureInteraction::nested_if_continue_loop --args 2u8 --signers 0xCAFE


//# run 0xBADD::ComplexFeatureInteraction::nested_if_continue_loop --args 4u8 --signers 0xCAFE


//# run 0xBADD::ComplexFeatureInteraction::get_nested_u8 --type-args --args "MyEnum::VariantA" --signers 0xCAFE


//# run 0xBADD::ComplexFeatureInteraction::get_nested_u8 --type-args --args "MyEnum::VariantB" --signers 0xCAFE


//# run 0xBADD::ComplexFeatureInteraction::get_nested_u8 --type-args --args "MyEnum::VariantC" --signers 0xCAFE

// Initialize global state


//# run 0xBADD::ComplexFeatureInteraction::initialize_global --signers 0xCAFE

// Test updating global counter via expression


//# run 0xBADD::ComplexFeatureInteraction::update_global_counter_via_expr --args 5 --signers 0xCAFE

// Verify the global counter has been updated correctly (simulate via getting value)


//# run 0xBADD::ComplexFeatureInteraction::get_global_counter --signers 0xCAFE

// Test calling the inline wrapper that calls a private non-inline function


//# run 0xBADD::ComplexFeatureInteraction::inline_wrapper_call --args 15u8 --signers 0xCAFE

// Test update expression on a struct
struct TestStruct has store {
    a: u8,
    b: bool,
}



//# run 0xBADD::TestStructModule::create_test_struct --signers 0xCAFE


//# run 0xBADD::TestStructModule::update_test_struct --args 42 true --signers 0xCAFE
