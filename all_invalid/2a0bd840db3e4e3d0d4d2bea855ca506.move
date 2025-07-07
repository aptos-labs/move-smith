//# publish
module 0xCAFE::VectorLiterals {
    // A function to create and return a vector<u8> literal
    public fun get_u8_vector(): vector<u8> {
        vector<u8>[1u8, 2u8, 3u8]
    }

    // A function to create and return a vector<bool> literal
    public fun get_bool_vector(): vector<bool> {
        vector<bool>[true, false, true]
    }

    // Function demonstrating type starting with '(' (tuple type)
    public fun tuple_type_identity(x: (u8, bool)): (u8, bool) {
        (x.0, x.1)
    }

    // Function demonstrating type starting with '&' (reference)
    public fun ref_identity(x: &u64): u64 {
        *x
    }

    // Function demonstrating type starting with '& mut' (mutable reference)
    public fun ref_mut_add_one(x: &mut u64) {
        *x = *x + 1;
    }

    // Runner function that exercises above features
    public fun runner(account: &signer) {
        let v1 = get_u8_vector();
        let v2 = get_bool_vector();
        let t = tuple_type_identity((42u8, true));
        let mut value = 10u64;
        let r = &value;
        let rm = &mut value;

        let _ = ref_identity(r);
        ref_mut_add_one(rm);
    }
}

//# run 0xCAFE::VectorLiterals::runner --signers 0xCAFE

// Featurres:
// 12524dcd31b15977843a22b52fbacaaf: Define vector literals using the 'vector' identifier followed by type arguments and a list of expressions inside brackets.
// d76b9ce10a67c45edb4d1950c476495c: Start a type with an opening parenthesis '(' or an ampersand '&' or '& mut' for mutable references.
// 9eb7776ed6f83b78d2fb06e2e874c32c: Rely on the compiler to remove unnecessary trailing jump instructions from bytecode blocks
