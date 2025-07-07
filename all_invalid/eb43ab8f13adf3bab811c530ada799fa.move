//# publish
module 0xCAFE::TestAssign {
    public fun set_value(val: u64): u64 {
        let x = val + 10; // Assign expression to variable
        x
    }
}

//# run 0xCAFE::TestAssign::set_value --args 42u64


//# publish
module 0xCAFE::TestAbilities {
    // Define a resource with store and drop abilities
    resource struct MyResource has store, drop {}

    // Function requiring the resource to have store and drop abilities
    public fun create_resource<T: store + drop>(): T {
        // Body intentionally left empty, as creation is not needed for compile-time ability checks
        // This function serves to specify the constraints
        // Note: Can't instantiate resources directly here
        // Usually, resource creation is done with move_to in a real scenario
        // For this test, only ability constraints are exercised
        // So, just leave it empty or return a dummy value if needed
        // For simplicity, just leave it unimplemented as it is not invoked
        // In Move, such functions can be marked as `script` or `public` with no body if no code runs
        // Here, we leave as is
    }

    // Function with ability constraints
    public fun requires_ability<T: store + drop>(&'static T) {
        // no operation needed
        ()
    }
}

//# run 0xCAFE::TestAbilities::requires_ability --signers 0xCAFE