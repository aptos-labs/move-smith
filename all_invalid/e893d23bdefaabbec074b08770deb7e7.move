
//# publish
module 0xDEAD::CrossModuleAccess {
    use std::signer;

    struct PrivObj has store, key {
        value: u64,
    }

    public fun create_priv_obj(s: signer): PrivObj {
        let obj = PrivObj { value: 1234 };
        move_to<PrivObj>(&s, obj)
    }

    public fun get_priv_obj_ref(s: &signer): &PrivObj {
        borrow_global<PrivObj>(signer::address_of(s))
    }
}


//# publish
module 0xBADD::MainModule {
    use std::signer;
    use 0xDEAD::CrossModuleAccess;

    // Enum with multiple variants
    enum Data has copy, drop {
        V1,
        V2 { x: u64, y: u64 }
    }

    /// Function to call create_priv_obj and access PrivObj value
    public fun test_cross_access(s: signer) {
        // Attempt to create PrivObj from CrossModuleAccess module
        CrossModuleAccess::create_priv_obj(&s);
        // Borrow the global PrivObj
        let obj_ref: &CrossModuleAccess::PrivObj = CrossModuleAccess::get_priv_obj_ref(&s);
        // Access value field
        let val = obj_ref.value;
        // Dummy use to prevent unused variable warning
        let _ = val;
    }

    // Function to get x value from Data variant
    public fun get_x(data: Data): u64 {
        match data {
            Data::V1 => abort 1,
            Data::V2 { x, y: _ } => x,
        }
    }

    // Function to get y value from Data variant
    public fun get_y(data: Data): u64 {
        match data {
            Data::V1 => abort 2,
            Data::V2 { x: _, y } => y,
        }
    }

    // Lambda with no parameters (empty list)
    public fun run_lambda() {
        let lambda: || u64 = || { 42 };
        let result = lambda();
        let _ = result;
    }
}


//# run 0xBADD::MainModule::test_cross_access --signers 0xCAFE


//# run 0xBADD::MainModule::get_x --args Data::V2 {x: 5, y: 10}

//# run 0xBADD::MainModule::get_x --args Data::V1


//# run 0xBADD::MainModule::get_y --args Data::V2 {x: 5, y: 10}

//# run 0xBADD::MainModule::get_y --args Data::V1


//# run 0xBADD::MainModule::run_lambda

// Featurres:
// 2c1b54244d0d1552797e210b3c1a2816: Use cross-module access checks to prevent unauthorized access across module boundaries.
// 5a6b0789494b663480d623ed03e6360e: Test that the `Data` enum correctly returns the `x` value for both `V1` and `V2` variants and the `y` value when present, aborting when the variant is `V1`.
// cbffcb1e34692ffcc732b985d60b2ca3: Use empty parameter lists for lambdas by writing '||' instead of specifying bindings.
