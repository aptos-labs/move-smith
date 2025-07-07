
//# publish
module 0xCAFE::AccessControl {
    use std::vector;

    struct HiddenStruct has copy, drop, store, key {
        secret_field: u64,
    }

    public fun create_hidden_struct(secret: u64): HiddenStruct {
        HiddenStruct { secret_field: secret }
    }

    public fun get_secret_field(s: &HiddenStruct): u64 {
        s.secret_field
    }
}


//# run 0xCAFE::AccessControl::create_hidden_struct --args 42u64


//# run 0xCAFE::AccessControl::get_secret_field --signers 0xCAFE --args 0xCAFE::AccessControl::create_hidden_struct 42u64


//# publish
module 0xCAFE::ModuleA {
    use std::vector;
    use 0xCAFE::AccessControl;

    struct PublicStructA has copy, drop, store, key {
        field_a: u128,
    }

    // This is a private function, should not be accessible from other modules
    fun private_helper_function(value: u8): u8 {
        value + 10
    }

    public fun instantiate_struct_a(): PublicStructA {
        PublicStructA { field_a: 999u128 }
    }

    // This inline pure function calls another pure function transitively
    public fun caller_of_impure(): u64 acquires AccessControl.HiddenStruct {
        let secret_struct = AccessControl::create_hidden_struct(1234);
        // call to getter
        let secret = AccessControl::get_secret_field(&secret_struct);
        // Impure function call inside; this is okay in Move as long as it doesn't violate access rules
        // but the call flow should be considered for restrictions
        let val = impure_helper(secret);
        val
    }

    // Impure helper function that is not publicly accessible
    fun impure_helper(value: u64): u64 {
        // This simulates an impure function, e.g., reading global state or side-effects
        value + 1
    }

    // Function to test access control - trying to access private helper from outside (should fail if attempted)
    public fun test_private_access(): u64 {
        private_helper_function(5)
    }
}


//# run 0xCAFE::ModuleA::instantiate_struct_a


//# run 0xCAFE::ModuleA::caller_of_impure


//# run 0xCAFE::ModuleA::test_private_access


//# publish
module 0xCAFE::ModuleB {
    use std::vector;
    use 0xCAFE::AccessControl;
    use 0xCAFE::ModuleA;

    // Struct with unique field names to prevent conflicts
    struct StructUnique_bhas copy, drop, store, key {
        unique_field_x: u64,
    }

    // Attempt to access a private function - should be infeasible, so simulate a test of access restrictions
    public fun attempt_private_access(): u64 {
        // Should not compile if access restrictions are enforced
        ModuleA::private_helper_function(10)
    }

    // Declaring a struct that contains a nested struct from ModuleA (which is public)
    struct ComplexStruct has copy, drop, store, key {
        nested_struct: ModuleA::PublicStructA,
        unique_id: u128,
    }

    // A function transitively calling a pure function within the module (Public) that calls an impure function from the other module
    public fun transitively_call(): u64 {
        let a_struct = ModuleA::instantiate_struct_a();
        // Access individual field if needed
        a_struct.field_a as u64
    }
}


//# run 0xCAFE::ModuleB::attempt_private_access


//# run 0xCAFE::ModuleB::transitively_call --signers 0xCAFE


// Featurres:
// b065906c726fb886e203372b2972b161: Restrict cross-module access to non-public members to prevent access violations.
// 710703c953f311df9ce8062916134825: Quickly identify where an impure Move function is being called transitively from within specification functions.
// 257f6fba09c4b0194f47f4da95e4709d: Declare struct and resource fields with unique names.
