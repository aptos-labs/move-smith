
//# publish
module 0xCAFE::TestPatternAndAbilities {
    use std::vector;

    struct ResourceType has key, store {
        id: u64,
        active: bool,
    }

    // A struct with a function as a field, with // persistent] attribute
    struct FuncHolder has store {
        // persistent]
        func: u64,
    }

    // A resource with abilities
    struct AbilitiesResource has copy, drop, store, key {
        value: u8,
    }

    // A resource that stores a function
    struct StoredFunction has store, key {
        fn_id: u64,
    }

    // Compile-time function with // persistent], to be stored
    public fun get_next_id(): u64 {
        42
    }

    public fun create_func_holder(): FuncHolder {
        let f_id = get_next_id();
        let holder = FuncHolder {func: f_id};
        holder
    }

    public fun store_func_holder(signer: signer) {
        let holder = create_func_holder();
        move_to<FuncHolder>(&signer, holder);
    }

    public fun read_func_holder(addr: address): FuncHolder {
        borrow_global<FuncHolder>(addr)
    }

    // Function to test resource abilities
    public fun create_abilities_resource(): AbilitiesResource {
        AbilitiesResource {value: 255}
    }

    // Function to test pattern assignment and variable detection
    public fun pattern_assignment_test(): u64 {
        let (a, b, c) = (1u8, true, 3u64);
        let _d = 4u16;
        let _e = 5u32;
        // Pattern assignment for resource
        let resource = ResourceType {id: 1, active: true};

        // Corrected match syntax: match expression should be a statement, so add semicolon
        let active_state = match resource {
            ResourceType {active: a_state, ..} => a_state,
        }; // <-- ensure semicolon here

        // Final expression returns combined result
        a as u64 + b as u64 + c + active_state as u64
    }
}



//# run 0xCAFE::TestPatternAndAbilities::pattern_assignment_test



//# run 0xCAFE::TestPatternAndAbilities::store_func_holder --signers 0xDEAD --args

// Features:
// 5fc7c03fb100cc78231369da3d433efb: Perform assignments to variables bound in patterns and have the compiler detect which variables are assigned (thus, potentially modified).
// f51671fff84ed4104176c5b5edd707aa: Display the abilities of a Move resource or type with a ' has ' prefix.
// 51563007d945b4343bc81f1c189b7183: Test that a function with the // persistent] attribute can be used as the value of a store-compatible struct and correctly executed after being stored and moved from global storage.