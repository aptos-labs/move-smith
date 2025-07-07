
//# run 0xCAFE::AbilityHandlingTests::create_struct_with_abilities


//# run 0xCAFE::AbilityHandlingTests::use_ability_check_to_copy --args 0xCAFE::AbilityHandlingTests::create_struct_with_abilities


//# run 0xCAFE::AbilityHandlingTests::requires_copy_arg --args 0xCAFE::AbilityHandlingTests::create_struct_with_abilities


//# run 0xCAFE::AbilityHandlingTests::test_nested_attribute

// Note: The primary issue was with the '--args' parameter. It expects explicit argument values, not just a function call.
// To fix this, provide the correct argument in the '--args' option, such as the expected argument value.

// For example, if 'create_struct_with_abilities' doesn't take any args, you might omit it or pass an empty list.
// If it does take an argument, replace 'args_value' with the correct serialized argument.


// Corrected example, assuming no args needed (adjust if necessary):

// run the test with no args:
task run 0xCAFE::AbilityHandlingTests::create_struct_with_abilities

// run the test with args (replace 'args_value' with actual serialized argument if needed):
// task run 0xCAFE::AbilityHandlingTests::use_ability_check_to_copy --args "args_value"

/* 
Alternatively, if the test does require specific args, provide them explicitly, e.g.:

task run 0xCAFE::AbilityHandlingTests::use_ability_check_to_copy --args "0x1"

Replace '0x1' with the appropriate serialized argument value.
Ensure that the arguments are properly formatted as strings.
*/