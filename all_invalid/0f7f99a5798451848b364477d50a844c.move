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
        // For testing, instantiate a resource if T is MyResource
        // Since move cannot instantiate resources directly in this context,
        // we simulate the type constraints and assume resource creation elsewhere.
        // For test purposes, return any value. Here, just use a dummy value.
        // But in Move, actual resource instantiation must happen with move_to.
        // To exercise abilities constraints, declare function with 'has' bounds.
        // As a placeholder, do no operation and return default value.
        // The main point is the ability constraints in function signature.
        // So we just return a dummy value (unit).
        // Alternatively, define a dummy function with constraints.
        // To directly test 'has' in parameters, run such a function.
        ()
    }

    // Function with ability constraints
    public fun requires_ability<T: store + drop>(&'static T) {
        // Function that requires T to have specific abilities
        // No operation needed
        ()
    }
}

//# run 0xCAFE::TestAbilities::requires_ability --signers 0xCAFE --args 0xCAFE::TestAbilities::MyResource

// Featurres:
// 41f8c7258935ea12ed715b21888bd747: Assign an expression to a named variable using a 'let' binding in Move.
// 174d59b515e152fb0baa3c51ee032552: Annotate function-type parameters or function types with ability constraints using the 'has' keyword
// 6be5d216e95d58b1065723dbea670849: Ensure that module member names and aliases are unique within each namespace.
