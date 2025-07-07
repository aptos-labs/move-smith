
//# publish
module 0xCAFE::TypeParamTest {
    use std::vector;

    struct Container<T> has copy, drop, store {
        items: vector<T>
    }

    public inline fun inline_adder<T: copy + drop + store>(v: &vector<T>, elem: T): vector<T> {
        let new_v = vector::empty<T>();
        let length = vector::length(*v);
        let i = 0;
        while (i < length) {
            let item = *vector::borrow(*v, i);
            vector::push_back(&mut new_v, item);
            i = i + 1;
        };
        vector::push_back(&mut new_v, elem);
        new_v
    }

    public fun mixed_function_call_u64(v: &vector<u64>, elem: u64): vector<u64> {
        let with_elem = inline_adder(v, elem);
        let v_mut = with_elem;
        let length = vector::length(v_mut);
        let i = 0;
        while (i < length) {
            let _val = *vector::borrow(v_mut, i);
            i = i + 1;
        };
        v_mut
    }

    public fun runner_u8() {
        let v: vector<u8> = vector[1u8, 2u8, 3u8];
        let result = inline_adder(&v, 4u8);
        let _ = mixed_function_call_u64(&vector[10u64, 20u64], 30u64);
    }

    public fun runner_container() {
        let empty_items: vector<u8> = vector[];
        let container = Container<u8> {items: empty_items};
        let container_vec = inline_adder(&container.items, 42u8);
        let _new_container = Container<u8> {items: container_vec};
    }
}


//# run 0xCAFE::TypeParamTest::runner_u8


//# run 0xCAFE::TypeParamTest::runner_container


// Featurres:
// 1df1c75b7c273f1fbf3eb764932c6eec: Use type parameters properly within vector types.
// e374a7c668a1b94c8a289f53af65f853: Declare type parameters for structs
// e295128e65c7cf7ab8b15e938ee6cb8e: Create functions that call inline functions and also have non-inline function bodies, allowing mixed call patterns.
