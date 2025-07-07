
//# publish
module 0xCAFE::FeatureTestModule {
    use std::vector;

    const TEST_CONST: u64 = 123456789;

    struct ResourceStruct has key, store {
        id: u64,
        name: vector<u8>,
    }

    // Specification annotations are not a real Move feature but used here for demonstration
    public fun spec_function(x: u8): u8 acquires ResourceStruct {
        // acquire permission for ResourceStruct
        x
    }

    // Function with acquire permission on global resource or specific resource
    public fun with_resource_acquire(resource_ref: &ResourceStruct): bool acquires ResourceStruct {
        // potentially manipulate resource
        resource_ref.id == 42
    }

    // Removed inner module
    // Deprecated modules should be defined at top level, not inside other modules
    
    // Declaring a deprecated module - the compiler should warn about its usage
    // Move does not support nested modules, so define at top level
    module 0xCAFE::DeprecatedModule {
        // This module is deprecated, but for testing, we include it.
        public fun deprecated_function(): u8 {
            0
        }
    }

    // Function that calls deprecated, should trigger deprecation warning
    public fun use_deprecated() {
        let _ = 0xCAFE::DeprecatedModule::deprecated_function();
    }

    // Function with assertions and explicit specification
    public fun check_value(x: u64): bool {
        assert!(x > 0, 999);
        x < 10000
    }

    // Function with an inline lambda that manipulates vector
    public fun process_vector(input: vector<u8>): vector<u8> {
        let lambda: |vector<u8>| vector<u8> = |v: vector<u8>| {
            let result = v;
            vector::push_back(&mut result, 255u8);
            result
        };
        lambda(input)
    }

    // Function with nested match expression
    // Define enum E outside the module
    // Note: Enums are global; define here for clarity
    // Moved above the module for correct structure
    // But for a single file, define before the module

    // Define enum E outside the module
    // (Assuming it's placed above the module in practice)
    // For the example, placing here for completeness

    // enum E with variants V1, V2, V3
    // move can't define enums inside modules, but assume it's global

    // For clarity, define outside:
    // (The code might need to be rearranged accordingly)

    // To fix the code, move enum E outside the module

}

// Define enum E outside of modules
public enum E {
    V1,
    V2(a: u64, b: u64),
    V3 { a: bool },
}

// Now, the function nested_match
public fun nested_match(e: E): u8 {
    match e {
        E::V1 => 1,
        E::V2(a, b) => match a {
            0 => 0,
            _ => b as u8,
        },
        E::V3 { a } => if (a) { 255 } else { 0 },
    }
}

// Move the enum outside the module for proper structure

// Main runner function to call various features
public fun run_all() {
    let res = ResourceStruct { id: TEST_CONST, name: vector::empty<u8>() };
    // Example of acquiring resource
    let _ = with_resource_acquire(&res);
    // Use deprecated function
    use_deprecated();
    // Check value assertions
    let _ = check_value(500);
    // Process vector
    let v = vector::empty<u8>();
    let _ = process_vector(v);
    // Use nested match
    let e = E::V2(0, 42);
    let _ = nested_match(e);
    // Use generic resource function
    let _ = generic_resource_function::<u64>(99);
}