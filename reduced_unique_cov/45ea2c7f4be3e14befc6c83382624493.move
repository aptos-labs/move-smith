
//# publish
module 0xCAFE::FeatureTest {
    // Removed unused import 'std::signer'

    // 5 Recursive struct test - NOT cyclic in fields
    struct Node has copy, drop, store {
        value: u8,
        next: Option<Node>,
    }

    struct Option<T> has copy, drop, store {
        has_value: bool,
        value: T,
    }

    // Construct a recursive chain of length 2 to test recursion through struct
    public fun make_chain(): Node {
        // Tail node with no next (has_value: false)
        let tail = Node {
            value: 2,
            next: Option { has_value: false, value: tail_placeholder() }
        };
        let head = Node {
            value: 1,
            next: Option { has_value: true, value: tail }
        };
        head
    }

    // A placeholder for the tail node to break infinite recursion
    fun tail_placeholder(): Node {
        let n = Node {
            value: 0,
            next: Option { has_value: false, value: n_placeholder() }
        };
        n
    }

    // Helper to avoid cyclic definition error, decoy node with no next
    fun n_placeholder(): Node {
        // Use dummy value consistent with Option { has_value: false }
        // Since has_value is false, the value is never accessed by Move so it can be self-reference or dummy.
        // But to avoid 'undeclared `node`', re-define 'node' before use:
        let node_ref = Node {
            value: 0,
            next: Option { has_value: false, value: node_ref_placeholder() }
        };
        node_ref
    }

    fun node_ref_placeholder(): Node {
        // To avoid cyclic self reference error, define a terminal node with has_value: false and dummy value
        Node {
            value: 0,
            next: Option { has_value: false, value: node_ref_placeholder() }
        }
    }

    // 1: Function to add two u8 values and return a fixed value after
    public fun add_then_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        let _ = sum; // use result but ignore it
        42u8
    }

    // 2: Function with lambda expression returns lambda output on input
    public fun test_lambda(x: u8): u8 {
        let lambda: |u8| u8 has copy+drop = |v: u8| {
            v + 5u8
        };
        lambda(x)
    }

    // 6: Nested blocks with braces and spec blocks (spec blocks just as comment)
    public fun nested_blocks(x: u8): u8 {
        {
            let tmp = {
                let inner = x + 2u8;
                inner
            };
            tmp + 3u8
        }
    }
}



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::FeatureTest;

    // 3 Call inline function from another module and use result
    public inline fun call_inline(): u8 {
        let v = FeatureTest::test_lambda(10u8);
        let res = v + 1u8;
        res
    }

    // 4 Literal address specifier using tuple
    const LIT_ADDR: address = 0x1234;

    public fun use_literal_address(): address {
        LIT_ADDR
    }
}



//# run 0xCAFE::FeatureTest::add_then_return_fixed --args 7u8 8u8


//# run 0xCAFE::FeatureTest::test_lambda --args 10u8


//# run 0xCAFE::FeatureTest::nested_blocks --args 3u8


//# run 0xCAFE::CallerModule::call_inline


//# run 0xCAFE::CallerModule::use_literal_address
