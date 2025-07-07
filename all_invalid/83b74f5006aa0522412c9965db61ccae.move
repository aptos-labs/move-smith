
//# publish
module 0xCAFE::AdvancedFeatures {
    use std::signer;
    use std::vector;

    // Declare a custom struct with various fields
    struct CustomStruct has copy, drop, store {
        id: u64,
        name: vector<u8>,
        status: bool,
    }

    // Private internal function to add two u64
    fun internal_add(a: u64, b: u64): u64 {
        a + b
    }

    // Internal function to create a CustomStruct
    fun internal_create_struct(id: u64, name: vector<u8>, status: bool): CustomStruct {
        CustomStruct { id, name, status }
    }

    // Public function using qualified name, testing access
    public fun qualified_access_create(id: u64, name: vector<u8>, status: bool): CustomStruct {
        Self::internal_create_struct(id, name, status)
    }

    // Struct with private visibility and a getter
    struct PrivStruct has copy, drop, store {
        secret: u32,
    }

    public fun create_priv_struct(secret: u32): PrivStruct {
        PrivStruct { secret }
    }

    // Function with shadowing variables inside and outside while loops
    public fun variable_scope_test(): (u64, u64) {
        let outer_var: u64 = 0;
        let inner_var: u64 = 0;

        while (outer_var < 3) {
            // Shadowed variable named outer_var
            let outer_var = outer_var + 1;

            // Inner variable inside loop
            let inner_var = 10;
            while (inner_var > 0) {
                // Shadow inner_var again
                let inner_var = inner_var - 1;
                inner_var
            };
            inner_var = outer_var + 5;
        };

        (outer_var, inner_var)
    }

    // Helper to instantiate nested structs and test visibility
    public fun create_and_modify_struct(id: u64, name: vector<u8>, status: bool): (CustomStruct, PrivStruct) {
        let cs = internal_create_struct(id, name, status);
        let ps = create_priv_struct(42);
        (cs, ps)
    }

    // Closure capturing a variable with copy ability
    public fun capture_copy_var(x: u64): (u64, u64) {
        let captured_x = x;
        let lambda = |y: u64| -> u64 {
            captured_x + y
        };
        (lambda(3), captured_x)
    }

    // Closure capturing a variable with drop ability (simulate with a resource)
    struct DropResource { state: u8 }

    public fun capture_drop_var(y: DropResource): (u8, DropResource) {
        let captured_y = y;
        let lambda = |z: u8| -> u8 {
            captured_y.state + z
        };
        (lambda(2), captured_y)
    }

    // Function executing complex nested shadowing and variable updates
    public fun shadowing_test(): u64 {
        let x: u64 = 5;
        let x = x;

        while (x < 10) {
            let x = x + 2; // shadowing inner
            if (x > 8) {
                let x = x - 1; // inner shadow
                x
            };
            x = x + 1; // update outer shadow
        };
        x
    }
}


//# run 0xCAFE::AdvancedFeatures::variable_scope_test --signers 0xBADD --args

//# run 0xCAFE::AdvancedFeatures::create_and_modify_struct --signers 0xBADD --args 5b"Test" true

//# run 0xCAFE::AdvancedFeatures::capture_copy_var --signers 0xBADD --args 10u64

//# run 0xCAFE::AdvancedFeatures::capture_drop_var --signers 0xBADD --args 0xDropResource{ state: 1 }

//# run 0xCAFE::AdvancedFeatures::shadowing_test --signers 0xBADD


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 95fb49dd215ae1c5e517bce9385b5417: Declare custom structs inside a module.
// 430e80f68e9e61c4854110039dc54f29: Use access specifiers that include qualified names as part of your visibility declarations.
// 27c583d0f8b2f0e9e13aa3532a7e0314: Ensure captured variables in lambdas conform to the required Move abilities for the closure and that abilities are not missing.
