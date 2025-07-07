//# publish
module 0xCAFE::VectorUnpackTest {
    use std::vector;

    struct Container has copy, drop {
        data: vector<u8>,
    }

    const CONST_VALUE: u8 = 42;

    public fun create_container(): Container {
        let vec = vector::empty<u8>();
        let vec = vector::push_back(vec, 10);
        let vec = vector::push_back(vec, 20);
        let c = Container { data: vec };
        c
    }

    public fun get_data_ref(c: &Container): &vector<u8> {
        &c.data
    }

    public fun test_unpack_vector() {
        let container = create_container();
        let v_ref = get_data_ref(&container);
        // Unpack elements by borrowing elements by reference, not move
        let first = *vector::borrow(v_ref, 0);
        let second = *vector::borrow(v_ref, 1);
        let _sum = first + second + CONST_VALUE; 
        // container still valid and usable here
        let still_there_ref = get_data_ref(&container);
        // Borrow again to check contents
        let _check = *vector::borrow(still_there_ref, 0);
    }
}

//# run 0xCAFE::VectorUnpackTest::test_unpack_vector

// Featurres:
// 2aa33ab65469a2edd4ef939a8a500bee: Test that unpacking from a function returning a vector by reference does not move or invalidate the original vector variable.
// 571535d76ec45523fbe6cc5de0eeba0f: Use leading name access for identifiers and addresses in your code
// edf5d2f4ab13be32218327e2a68ddf57: Name module members (such as functions, structs, or constants) according to allowed naming conventions
