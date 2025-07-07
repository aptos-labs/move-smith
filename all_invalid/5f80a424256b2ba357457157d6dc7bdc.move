



//# publish
module 0xC0FF::TestModule {
    use std::vector;
    use 0xCAFE::MyModule::{f1, f3, S, StructWithTypeParameter, E, f2};
    use 0xCAFE::StorageUsage::{store_at_signer_address, inspect_value, update_value, remove_at_signer_address, cross_module_call, several_args};
    use std::signer;

    // Test function parameters with function-typed values (assuming Move version >= 2.2)
    public fun test_function_with_func_param(f: |u8|u8) {
        // call the passed function with some argument
        let result = f(5u8);
        assert!(result == 10u8, 999);
    }

    // Helper wrapper to call the above with a specific function
    public fun run_test() {
        // Inline lambda
        let lambda: |u8|u8 = |a: u8| { a + a };
        test_function_with_func_param(lambda)
    }

    // Test creating parameterized vectors with type parameters
    public fun create_parameterized_vectors() {
        // Vector of u8
        let v_u8: vector<u8> = vector::empty<u8>();
        vector::push_back(&mut v_u8, 1u8);
        vector::push_back(&mut v_u8, 2u8);

        // Vector of u16
        let v_u16: vector<u16> = vector::empty<u16>();
        vector::push_back(&mut v_u16, 100u16);
        vector::push_back(&mut v_u16, 200u16);

        // Vector of structs with type parameter (E)
        let v_e: vector<StructWithTypeParameter<E>> = vector::empty<StructWithTypeParameter<E>>();
        let s1 = StructWithTypeParameter<E> {field: E::V1};
        let s2 = StructWithTypeParameter<E> {field: E::V2(3, 4)};
        vector::push_back(&mut v_e, s1);
        vector::push_back(&mut v_e, s2);

        // Vector of vectors
        let inner_vec: vector<u8> = vector::empty<u8>();
        vector::push_back(&mut inner_vec, 9u8);
        let outer_vec: vector<vector<u8>> = vector::empty<vector<u8>>();
        vector::push_back(&mut outer_vec, inner_vec);
    }
}


//# run 0xC0FF::TestModule::run_test --signers 0xBADC


//# run 0xC0FF::TestModule::create_parameterized_vectors


// Featurres:
// f4128519df48a9f4fd3c1412821dbbeb: Import specific module members (such as structs or functions) using 'use Module::{Member1, Member2}'.
// c9eb5099b0242b7001323e1cb5fc6aa7: Create or use function parameters with function-typed values in non-inline functions if the language version is at least 2.2.
// 0afa4f6963989641601c770b072a0b4d: Use type vectors that may be parameterized by type parameters.
