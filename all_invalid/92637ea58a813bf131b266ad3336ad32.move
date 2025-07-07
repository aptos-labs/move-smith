
//# run 0xCAFE::AbilityHandlingTests::create_struct_with_abilities


//# run 0xCAFE::AbilityHandlingTests::use_ability_check_to_copy --args 0xCAFE::AbilityHandlingTests::create_struct_with_abilities


//# run 0xCAFE::AbilityHandlingTests::requires_copy_arg --args 0xCAFE::AbilityHandlingTests::create_struct_with_abilities


//# run 0xCAFE::AbilityHandlingTests::test_nested_attribute

// Featurres:
// f1c17907be8ea222f783a0a1ab20a0a7: Encourage proper handling of abilities via ability checks on types and function signatures.
// 650d1a969194484aec64b8e2ec07ef3f: Report diagnostics and then terminate the compilation process.
// 804086704d5d248f2db052a475b4e622: Annotate Move items with parameterized attributes containing a list of sub-attributes.
