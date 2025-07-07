
//# publish
module 0xCAFE::AbilitiesTest {
    use std::abi::{Ability, AbilitySet};
    use std::errors::Error;

    // Function to test multiple abilities: copy and drop
    public fun test_abilities<T: copy + drop>() {
        let _value: T;
    }

    // Native struct without declared fields
    native struct NativeStruct;

    // Function to check for unused variables (parameters)
    public fun unused_params(_unused_param1: u64, _unused_param2: bool) {
        // Does nothing
    }
}



//# run 0xCAFE::AbilitiesTest::test_abilities --signers 0xCAFE --args 42u64


//# run 0xCAFE::AbilitiesTest::unused_params --signers 0xCAFE --args 42u64 true