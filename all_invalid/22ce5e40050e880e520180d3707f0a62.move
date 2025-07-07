
//# publish
module 0xCAFE::TestModule {
}

 
//# run 0xCAFE::TestModule::self_referential_function --signers 0xCAFE

 
//# run 0xCAFE::TestModule::assignment_update_test --signers 0xCAFE


//# run 0xCAFE::TestModule::declaring_function_with_visibility --signers 0xCAFE

script {
    // 1. Declare a function within a script with a valid name and body, with visibility restrictions.
    public fun example_function() {
        // function body can be minimal, e.g., empty
    }
}

 
//# run 0xCAFE::TestModule::cyclic_variables --signers 0xCAFE


//# run 0xCAFE::TestModule::variable_update_before_return --signers 0xCAFE


// Featurres:
// 71b968922f8d2301ebac449cae520150: Declare a function within a script with a valid name and body, and enforce visibility restrictions.
// 9d04954a654aceb4b636a9365c219bae: Test that variables can be assigned in a cyclic manner within a function without causing errors or unintended behavior.
// cbbb2abb9b13eae9eec5a0699370e467: Test that assigning a new value to a local variable updates its value correctly before returning it.
