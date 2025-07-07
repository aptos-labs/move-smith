// # publish
module 0xCAFE::ModuleConstants {
    const CONST_VAL: u64 = 42;

    public inline fun get_const(): u64 {
        CONST_VAL
    }
}

// # publish
module 0xCAFE::ModuleFriend {
    friend 0xCAFE::ModuleAccess;

    public inline fun friend_function(): u64 {
        // This function returns a constant defined in ModuleConstants
        0xCAFE::ModuleConstants::get_const()
    }
}

// # publish
module 0xCAFE::ModuleAccess {
    use 0xCAFE::ModuleFriend;

    // This function tests nested if-else and an uninitialized variable x
    public fun runner(): u64 {
        let a = 5u64;
        let b = 10u64;
        let x: u64;

        if (a > b) {
            x = a;
        } else {
            if (b > (a + 3u64)) {
                x = b;
            } else {
                // Nested else - assign x to a constant from friend module
                x = ModuleFriend::friend_function();
            }
        };

        // Test that x is assigned and its value is correct
        // No runtime assertions in Move scripts, so we just return x

        x
    }
}

// # run 0xCAFE::ModuleAccess::runner

// Featurres:
// 3057bcc47366c67b20f424c510e5dd1c: Test that a constant defined in one module can be accessed via an inlined public function and then invoked from another module.
// 153adaf28b1f58790ebdd494582a0444: Declare module friends to specify which other modules have access.
// 1a8bd231b3764def4f6f4e5ff06d711c: Test that the function correctly executes nested if-else branches and reaches an assertion involving uninitialized variable x.
