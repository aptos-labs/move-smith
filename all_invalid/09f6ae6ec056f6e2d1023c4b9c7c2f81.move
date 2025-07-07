//# publish
module 0xCAFE::TestAbort {
    // Function that always aborts with a specific error code
    public fun abort_with_error() {
        abort 42;
    }
}

//# run 0xCAFE::TestAbort::abort_with_error --signers 0xCAFE

//# publish
module 0xCAFE::AccessControl {
    // Define a public function with restricted access via an internal check
    // Move doesn't support access modifiers like 'private' or 'protected' directly,
    // but we can simulate access control via runtime checks.
    public fun restricted_function(caller: address) {
        // For illustration, restrict access to a specific address
        let restricted_address: address = 0xCAFE;
        if (caller != restricted_address) {
            abort 100; // Not authorized
        }
        // Function logic here
    }

    // Provide a runner function that calls restricted_function internally
    public fun call_restricted(caller: address) {
        restricted_function(caller);
    }
}

//# run 0xCAFE::AccessControl::call_restricted --signers 0xCAFE --args 0xCAFE
//# run 0xCAFE::AccessControl::call_restricted --signers 0xDEAD --args 0xDEAD

//# publish
module 0xCAFE::PrimitiveTypesTest {
    // Function to test various primitive types
    public fun test_primitives() {
        let a_u8: u8 = 255;
        let a_u16: u16 = 65535;
        let a_u32: u32 = 4294967295;
        let a_u64: u64 = 18446744073709551615;
        let a_bool: bool = true;

        // Perform simple operations
        let sum_u8 = a_u8 + 1; // Should wrap to 0
        let sum_u16 = a_u16 + 1; // Should wrap to 0
        let sum_u32 = a_u32 + 1; // Wrap
        let sum_u64 = a_u64 / 2;

        let and_bool = a_bool && false;

        // Implicitly return to avoid unused variable warnings
        sum_u8;
        sum_u16;
        sum_u32;
        sum_u64;
        and_bool;
    }

    // Function to test type separation: primitive vs type parameter
    public fun test_type_params<T>() {
        // No operations here; just to ensure primitives are not mistaken
    }
}

//# run 0xCAFE::PrimitiveTypesTest::test_primitives --signers 0xCAFE

//# Run the primitive type test with a type parameter to verify primitives are not mistaken as type params
//# run 0xCAFE::PrimitiveTypesTest::test_type_params<u8> --signers 0xCAFE

// Featurres:
// 608f34dc135470096e01bc769c0aa60d: Test that aborting with a larger number correctly triggers an abort in the Move module.
// 894fc8f7804d6e73ab15b1e587abd535: Define function access specifiers to refine access control beyond basic visibility, such as restricting invocation to specific modules or addresses.
// fed2534c6bacb1af2f3b9a289b5a6b99: Ensure primitive types are not mistaken for type parameters.
