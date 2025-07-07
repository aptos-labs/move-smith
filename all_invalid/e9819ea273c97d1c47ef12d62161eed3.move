
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


//# run 0xCAFE::AbilitiesTest::test_abilities --signers 0xCAFE --args u64

//# run 0xCAFE::AbilitiesTest::unused_params --signers 0xCAFE --args 42u64 true

// Featurres:
// d72e80a8027df807adc8d20303e0a24f: Specify multiple abilities with a colon and plus-separated list.
// 670e265113932ad53e09f0f61d88b59f: Define native structs without declared fields in Move modules
// 5909ed0cbb657584f606bc62ef533156: Check for unused variables and parameters.
