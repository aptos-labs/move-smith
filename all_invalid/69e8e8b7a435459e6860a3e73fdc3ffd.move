
//# publish
module 0xCAFE::FriendWithAttributes {
    use std::signer;

    // Annotate a friend declaration with attributes (using a dummy attribute syntax example for testing)
    // custom_friend_attribute(reason = "testing friend attribute")]
    friend 0xBEEF;

    const CONST_VALUE: u64 = 12345u64;

    struct Data has key, store {
        value: u64,
    }

    public fun create_data(s: signer): Data {
        Data { value: CONST_VALUE }
    }

    public fun get_const_value(): u64 {
        CONST_VALUE
    }
}


//# run 0xCAFE::FriendWithAttributes::get_const_value


//# publish
module 0xCAFE::LabelAndConstTest {
    const CONST_ASSIGN: u64 = 100u64;

    // function illustrating const assignment and simulating label replacement with nested blocks and returns
    public fun simulate_label_replacement(x: u64): u64 {
        let y = 0u64;
        // Simulate label by using blocks and early return from blocks
        let result = {
            let label1 = {
                if (x > 50) {
                    1u64
                } else {
                    2u64
                }
            };
            label1
        };
        CONST_ASSIGN + result
    }
}


//# run 0xCAFE::LabelAndConstTest::simulate_label_replacement --args 40u64


//# run 0xCAFE::LabelAndConstTest::simulate_label_replacement --args 60u64


// Featurres:
// 019ec2b7f93cdef7c0d68e32b8cead1c: Annotate a friend declaration with attributes to specify custom metadata or behavior.
// e04f4e6393f3cc70f5b7a7eb7c919001: Replace block or label references with a new label during control flow graph transformations
// 5ad335da8be1c3196ef5853fa8f1703a: Assign a value to the constant using '=' followed by an expression.
