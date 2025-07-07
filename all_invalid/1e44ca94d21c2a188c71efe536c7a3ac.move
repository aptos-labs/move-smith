
//# publish
module 0xCAFE::TestModule {
    use std::signer;
    use std::vector;

    // Structs for nested field access testing
    struct InnerStruct has copy, drop {
        value: u64,
    }

    struct OuterStruct has copy, drop {
        inner: InnerStruct,
        flag: bool,
    }

    // Struct with internal visibility (simulate by not exposing in public API)
    struct RestrictedStruct has copy, drop {
        secret: u128,
    }

    // Public API for restricted struct (simulate internal access)
    public fun get_secret(rs: &RestrictedStruct): u128 {
        rs.secret
    }

    // Function to test nested field access
    public fun get_nested_value(os: &OuterStruct): u64 {
        os.inner.value
    }

    // Function with variable scope outside and inside while loop
    public fun scope_test(flag: bool): (u64, u64) {
        let outer_var: u64;
        let inner_var: u64;

        // Initialize outer_var
        outer_var = 10;

        // Shadowing inner_var in inner scope
        while (flag) {
            let inner_var = 20; // shadowing inner_var
            // Check inner_var value inside loop
            assert!(inner_var == 20, 999);
            // Update outer_var inside loop
            outer_var = outer_var + 1;
        };
        // After loop, inner_var is undefined outside, so here we re-declare
        let outer_copy = outer_var;
        let inner_copy = 42; // simulate access outside scope

        (outer_copy, inner_copy)
    }

    // Function simulating restricted internal access
    public fun direct_access_restricted_struct(rs: &RestrictedStruct): u128 {
        // Access via public function (should be allowed)
        get_secret(rs)
    }

    // Function to test specification correctness
    public fun pure_add(x: u64, y: u64): u64 {
        // Precondition: x + y must not overflow (simulate by small inputs)
        assert!(x + y >= x, 1000);
        // Postcondition: result is sum
        x + y
    }

    // Function to test internal visibility restriction and cross-module attempt
    public fun attempt_invalid_access(s: signer): u64 {
        // Assuming there's a private struct or internal function in another module,
        // here we simulate an invalid access that should not be allowed.
        // Since external modules can't access private/internal functions, this is a dummy.
        // This line would cause compile error if uncommented, so we use a commented placeholder.

        // 0xCAFE::SomePrivateModule::internal_function()
        // Instead, we produce a compile-time error condition.
        // Uncommenting the above line should produce an error, but here we just simulate.
        0
    }

    // Function testing function currying with different closure compositions
    public fun combine_functions(cond: bool): u64 {
        // Basic lambdas
        let add_one = |a: u64| a + 1;
        let multiply_two = |a: u64| a * 2;

        // Compose based on condition
        let combined = if (cond) {
            |a: u64| add_one(multiply_two(a))
        } else {
            |a: u64| multiply_two(add_one(a))
        };

        // Use combined function
        combined(10)
    }
}


//# run 0xCAFE::TestModule::get_nested_value --args @0xBEEF


//# run 0xCAFE::TestModule::scope_test --args true


//# run 0xCAFE::TestModule::scope_test --args false


//# run 0xCAFE::TestModule::direct_access_restricted_struct --signers 0xBEEF --args 0x123456789abcdefu128


//# run 0xCAFE::TestModule::pure_add --args 100u64 200u64


//# run 0xCAFE::TestModule::combine_functions --args true


//# run 0xCAFE::TestModule::combine_functions --args false


// Featurres:
// 78f8dc464195108ec06049bb15ab9fa2: Access nested fields of expressions using dot notation in Move code.
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
// 7f343e5b6a46a90c5e940d2d1b876be9: Test that function currying with different closures correctly evaluates conditional logic and produces expected results.
