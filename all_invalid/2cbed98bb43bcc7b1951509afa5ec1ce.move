//# publish
module 0xCAFE::VectorNativeTest {
    use std::vector;
    use std::signer;

    struct Element has copy, drop, store {
        val: u64,
    }

    native public fun native_sum(v: vector<u64>): u64;

    public fun create_vector(): vector<Element> {
        let mut vec_e = vector::empty<Element>();
        let e1 = Element { val: 100 };
        let e2 = Element { val: 200 };
        vector::push_back(&mut vec_e, e1);
        vector::push_back(&mut vec_e, e2);
        vec_e
    }

    public fun sum_elements_vec(v: vector<Element>): u64 {
        let mut total = 0;
        let len = vector::length(&v);
        let mut i = 0;
        while (i < len) {
            let elem_ref = vector::borrow(&v, i);
            total = total + elem_ref.val;
            i = i + 1;
        };
        total
    }

    public fun call_native_sum() {
        let mut nums = vector::empty<u64>();
        vector::push_back(&mut nums, 111);
        vector::push_back(&mut nums, 222);
        vector::push_back(&mut nums, 333);
        let _sum = Self::native_sum(nums);
    }

    public fun call_native_sum_with_expression() {
        // Use any valid Move expression as native_sum argument:
        // e.g. vector concatenation (manually implemented here)
        let mut v1 = vector::empty<u64>();
        let mut v2 = vector::empty<u64>();
        vector::push_back(&mut v1, 1);
        vector::push_back(&mut v1, 2);
        vector::push_back(&mut v2, 3);
        vector::push_back(&mut v2, 4);
        let merged = join_vectors(v1, v2);
        let _res = Self::native_sum(merged);
    }

    fun join_vectors(mut v1: vector<u64>, v2: vector<u64>): vector<u64> {
        let len_v2 = vector::length(&v2);
        let mut i = 0;
        while (i < len_v2) {
            let val = *vector::borrow(&v2, i);
            vector::push_back(&mut v1, val);
            i = i + 1;
        };
        v1
    }
}

//# run 0xCAFE::VectorNativeTest::create_vector

//# run 0xCAFE::VectorNativeTest::sum_elements_vec --args vector[Element {val:100}, Element {val:200}]

//# run 0xCAFE::VectorNativeTest::call_native_sum

//# run 0xCAFE::VectorNativeTest::call_native_sum_with_expression

// Featurres:
// 953dd007bdb1381c942fce08ed6a91fb: Use vector types to handle collections of elements of a specific type.
// 5f2615e6da0e9408ebc1bd128d532644: Use any valid Move expression as a function argument within these parentheses
// e51039949682f12a0b9de5028b12a96e: Declare functions as native to indicate they are implemented outside Move code.
