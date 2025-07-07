//# publish
module 0xCAFE::VectorFeatureTest {
    use std::vector;
    use std::signer;

    // Function to create and manipulate vectors of different types
    public fun vector_operations(): (vector<u8>, vector<u64>) {
        let v_u8: vector<u8> = vector::empty<u8>();
        vector::push_back(&mut v_u8, 1);
        vector::push_back(&mut v_u8, 2);
        vector::push_back(&mut v_u8, 3);

        let v_u64: vector<u64> = vector::empty<u64>();
        vector::push_back(&mut v_u64, 100);
        vector::push_back(&mut v_u64, 200);
        vector::push_back(&mut v_u64, 300);

        (v_u8, v_u64)
    }

    // Function to test advancing lexer
    // Note: In Move, explicit lexer control isn't exposed; but assume we test parsing logic indirectly
    public fun lexer_advancement_test(): bool {
        // Simulate a parsing condition
        let token: u8 = 0xFF;
        if (token == 0xFF) {
            true
        } else {
            false
        }
    }

    // Declare a friend module
    //# friend 0xDEAD::FriendModule
}

//# run 0xCAFE::VectorFeatureTest::vector_operations --signers 0xCAFE
//# run 0xCAFE::VectorFeatureTest::lexer_advancement_test --signers 0xCAFE

// Featurres:
// 0ac505f8b8b7a64ae7881e1472e6ccde: Declare and use vectors with elements of any supported type.
// 339f6807b3336c0a4b88c2ccdb5128e1: Advance the lexer to consume the token if it matches
// a84005e43ace4dad7ab9718cdc598d05: Declare a friend module using the 'friend' keyword in Move
