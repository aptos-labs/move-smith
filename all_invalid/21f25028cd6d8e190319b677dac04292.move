// #publish
module 0xCAFE::VectorLayoutTest {
    use aptos_framework::vector;

    #[layout(bytes = 1 + 4 + 8)]
    struct ExplicitLayout {
        a: u8,
        b: u32,
        c: u64,
    }

    #[layout(bytes = 1 + 4 + 8)]
    struct WithVector {
        a: u8,
        b: vector<u32>,
        c: u64,
    }

    public fun create_vector_u8(): vector<u8> {
        let v = vector::empty<u8>();
        let v = vector::push_back<u8>(v, 10u8);
        let v = vector::push_back<u8>(v, 20u8);
        let v = vector::push_back<u8>(v, 30u8);
        v
    }

    public fun create_vector_struct(): vector<ExplicitLayout> {
        let mut v = vector::empty<ExplicitLayout>();
        let item1 = ExplicitLayout { a: 1u8, b: 200u32, c: 3000u64 };
        let item2 = ExplicitLayout { a: 2u8, b: 201u32, c: 3001u64 };
        let item3 = ExplicitLayout { a: 3u8, b: 202u32, c: 3002u64 };
        v = vector::push_back<ExplicitLayout>(v, item1);
        v = vector::push_back<ExplicitLayout>(v, item2);
        v = vector::push_back<ExplicitLayout>(v, item3);
        v
    }

    public fun create_vector_with_vector(): vector<WithVector> {
        let mut v = vector::empty<WithVector>();
        let nested_vec1 = vector::empty<u32>();
        let nested_vec1 = vector::push_back<u32>(nested_vec1, 123u32);
        let nested_vec1 = vector::push_back<u32>(nested_vec1, 456u32);

        let nested_vec2 = vector::empty<u32>();
        let nested_vec2 = vector::push_back<u32>(nested_vec2, 789u32);

        let item1 = WithVector { a: 9u8, b: nested_vec1, c: 7777u64 };
        let item2 = WithVector { a: 8u8, b: nested_vec2, c: 8888u64 };

        v = vector::push_back<WithVector>(v, item1);
        v = vector::push_back<WithVector>(v, item2);
        v
    }

    public fun run_all(): bool {
        let _v_u8 = create_vector_u8();
        let _v_struct = create_vector_struct();
        let _v_with_vec = create_vector_with_vector();
        true
    }
}
// #run 0xCAFE::VectorLayoutTest::run_all --signers 0xCAFE

// A script that creates vectors and accepts no argument
// #run
script {
    use 0xCAFE::VectorLayoutTest;

    fun main(account: signer) {
        let _res = VectorLayoutTest::run_all();
    }
}

// Featurres:
// 1db43b384e7751f49e2af7861fc68ee5: Create vectors of types in Move code.
// 3794a54a82966bcb4bcc23ef66a9fbd9: Describe the layout of struct fields explicitly using layout annotations.
// df2e3b22b8378d90289589082d35d479: Report diagnostics and exit if any error or higher severity diagnostic is present.
