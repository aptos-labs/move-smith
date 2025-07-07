//# publish
module 0xCAFE::TestAbilities {
    use std::debug;

    #[test]
    public fun ability_debug_test() {
        // Variables with different abilities
        let x = 42; // primitive, has debug
        let b = true; // primitive, has debug

        // Correct struct declaration: Move requires explicit struct definitions at the module level
        // with the struct defined outside of function. Also, structs cannot be declared inside functions.
        // So, define the struct outside fun, then instantiate it inside fun.

    }
}

// Define the struct outside the test function, at module scope
struct CopyDropStruct {
    val: u64,
    flag: bool,
}

//# run 0xCAFE::TestAbilities::ability_debug_test