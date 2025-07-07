
//# publish
module 0xCAFE::TestAliasesAndGenerics {
    use std::vector;

    // Alias module members with custom names when importing them
    use 0xCAFE::MyModule as MM;

    // Define package metadata using optional package names (simulate via comment, as actual package metadata is handled outside code)
    // package_name: "TestPackage", version: "1.0.0"

    // Use the imported module members with aliases
    public fun call_f1_from_alias(x: u8, y: bool): u8 {
        MM::f1(x, y)
    }

    // Generic struct to test type parameter usage
    struct Wrapper<T> has copy, drop {
        value: T,
    }

    // Generic function that operates on any type T with copy, drop abilities
    public fun operate_on_wrapper<T: copy + drop>(w: Wrapper<T>): T {
        w.value
    }

    // Main runner function to test features
    public fun run_tests() {
        // Call the aliased function
        let result1 = call_f1_from_alias(5u8, false);

        // Instantiate generic struct with u16
        let w_u16 = Wrapper<u16> { value: 42u16 };
        let val_u16 = operate_on_wrapper(w_u16);

        // Instantiate generic struct with bool
        let w_bool = Wrapper<bool> { value: true };
        let val_bool = operate_on_wrapper(w_bool);

        // Use the result to prevent optimizations
        if (result1 == 5u8 && val_u16 == 42u16 && val_bool) {
            // no-op
        };
    }
}


//# run 0xCAFE::TestAliasesAndGenerics::run_tests

// Featurres:
// 2d689e2dc477bc7337c64758629a63b5: Alias module members with custom names when importing them
// 3ddca82693f12dd3cbb44d4d9a619e18: Define package metadata using optional package names.
// d6bfc12445a3e71a2f3add7f4a83133f: Use type parameters to define generic types and functions that can operate on various data types.
