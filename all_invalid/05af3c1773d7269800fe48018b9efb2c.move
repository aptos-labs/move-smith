//# publish
module 0xCAFE::ScalarModule {
    use std::vector;

    struct Scalar has copy, drop, store {
        value: u8,
    }

    // Create a new Scalar from u8
    public fun new_scalar_from_u8(val: u8): Scalar {
        Scalar { value: val }
    }

    // Return an empty vector of Scalars
    public fun empty_scalar_vec(): vector<Scalar> {
        vector::empty<Scalar>()
    }

    // Return an empty vector of signers
    public fun empty_signer_vec(): vector<signer> {
        vector::empty<signer>()
    }

    // Return an empty vector of generic type T
    public fun empty_generic_vec<T>(): vector<T> {
        vector::empty<T>()
    }

    // Return a nested empty vector of Scalars: vector<vector<Scalar>>
    public fun empty_nested_scalar_vec(): vector<vector<Scalar>> {
        vector::empty<vector<Scalar>>()
    }

    // Runner function to exercise functions without args
    public fun runner() {
        let _ = new_scalar_from_u8(42);
        let _ = empty_scalar_vec();
        let _ = empty_signer_vec();
        let _ = empty_generic_vec<u64>();
        let _ = empty_nested_scalar_vec();
    }
}

//# run 0xCAFE::ScalarModule::runner --signers 0xCAFE

//# run 0xCAFE::ScalarModule::new_scalar_from_u8 --args 255u8

//# publish
module 0xBEEF::UserModule {
    use std::vector;
    use 0xCAFE::ScalarModule;

    struct Wrapper has copy, drop, store {
        scalar: ScalarModule::Scalar,
        nested_empty: vector<vector<ScalarModule::Scalar>>,
        signer_vec: vector<signer>,
    }

    public fun create_empty_wrapper(s: signer): Wrapper {
        let scalar = ScalarModule::new_scalar_from_u8(0);
        let nested_empty = ScalarModule::empty_nested_scalar_vec();
        let signer_vec = ScalarModule::empty_signer_vec();
        Wrapper {
            scalar,
            nested_empty,
            signer_vec,
        }
    }

    public fun runner(s: signer) {
        let _w = create_empty_wrapper(s);
    }
}

//# run 0xBEEF::UserModule::runner --signers 0xBEEF

// Featurres:
// 339910f3f02845fdff27121f6ce4af96: Use address-qualified paths (e.g. '0x1::Module::Type') to refer to types or members defined in modules under specific account addresses.
// 4d5026678b532d171f786d175597ec07: Test that empty vectors of structs, signers, generics, and nested vectors can be correctly returned from functions without being treated as constants.
// 9e7485c25f9ad8f165c30a6a09dcacd5: Test that the `new_scalar_from_u8` function correctly initializes a Scalar with the specified byte value.
