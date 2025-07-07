//# publish
module 0xCAFE::VectorHexTest {
    use std::vector;

    public fun create_vectors(): (vector<u8>, vector<u8>) {
        let explicit_vec = vector[u8][10u8, 20u8, 30u8, 40u8, 50u8];
        let hex_vec = x"0A141E2832"; // hex of 10, 20, 30, 40, 50
        (explicit_vec, hex_vec)
    }

    public fun check_index(vec1: &vector<u8>, vec2: &vector<u8>): (u8, u8) {
        // Return elements at index 2 (3rd element) from both vectors
        (*vector::borrow(vec1, 2), *vector::borrow(vec2, 2))
    }
}

//# run 0xCAFE::VectorHexTest::create_vectors

//# run 0xCAFE::VectorHexTest::check_index --args 0x0000000000000000000000000000000000000000000000000000000000000005 0x0000000000000000000000000000000000000000000000000000000000000005


//# publish
module 0xCAFE::TypeParamTest {
    struct Wrapper<T> has copy, drop {
        value: T,
    }

    public fun get_type_name<T>(_: &Wrapper<T>): u8 {
        // Dummy function to "use" the type parameter T
        42u8
    }

    public fun use_type_param() {
        let wrapped_u8 = Wrapper<u8> { value: 123u8 };
        let _code = get_type_name(&wrapped_u8);
    }
}

//# run 0xCAFE::TypeParamTest::use_type_param

//# publish
module 0xCAFE::AssertionTest {
    public fun test_assertion_and_branch(x: u8) {
        if (x == 0) {
            assert!(false, 1000);
            // Code below should not execute if assertion fails
            let _should_not_run = 1u8;
        } else {
            assert!(true, 2000);
            // Code after successful assertion
            let _should_run = 2u8;
        };
        // Code after if-else block to check reachability
        let _after = 3u8;
    }
}

//# run 0xCAFE::AssertionTest::test_assertion_and_branch --args 1u8

//# run 0xCAFE::AssertionTest::test_assertion_and_branch --args 0u8

// Featurres:
// fafe4dcac2529477f68e855042041585: Test that both explicit vector construction and hexadecimal byte string notation produce equivalent byte vectors and allow correct element indexing.
// 23fe979c52aa80c763c3af9b5501f2b0: Ensure type parameters are correctly identified within types.
// d90fff8d9359a444e257b0760151f235: Test that the script correctly aborts when an assertion fails inside a conditional branch and that code after the conditional is not executed if the assertion inside the branch passes.
