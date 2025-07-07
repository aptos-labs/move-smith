
//# publish
module 0xCAFE::ComplexAccess {

    use std::vector;

    //
    // Data structures to test chained field and index accesses
    //
    struct Inner has copy, drop, store {
        val: u8,
        arr: vector<u8>,
    }

    struct Outer has store {
        inner: Inner,
        nums: vector<Inner>,
    }

    //
    // PRIVATE top-level lambda functions (lifted lambdas)
    //
    fun private_add_one_lambda(x: u8): u8 {
        let lambda: |u8| u8 has copy + drop = |a: u8| { a + 1 };
        lambda(x)
    }

    fun private_double_lambda(x: u8): u8 {
        let lambda: |u8| u8 has copy + drop = |a: u8| { 2 * a };
        lambda(x)
    }

    //
    // PUBLIC functions demonstrating chained field and index accesses with calls to private lambdas
    //
    public fun create_outer(): Outer {
        let inner = Inner {
            val: 5u8,
            arr: vector[10u8, 20u8, 30u8],
        };

        let inner_vec = vector[
            Inner { val: 1u8, arr: vector[1u8, 2u8, 3u8] },
            Inner { val: 2u8, arr: vector[4u8, 5u8, 6u8] },
            Inner { val: 3u8, arr: vector[7u8, 8u8, 9u8] },
        ];

        Outer {
            inner,
            nums: inner_vec,
        }
    }

    //
    // Public function to test chained access (field and index) and invoking private lambdas in expressions
    //
    public fun test_chained_access(o: &Outer): u8 {
        // Access val field, add one using private lambda
        let val_plus_one = private_add_one_lambda(o.inner.val);

        // Access element 1 of arr vector in inner, double it with private lambda
        let doubled_arr_elem = private_double_lambda(*vector::borrow(&o.inner.arr, 1));

        // Access val field of the 2nd element in nums vector, add one with private lambda
        let nums_val_plus_one = private_add_one_lambda(o.nums[1].val);

        // Access arr vector of 3rd element in nums vector and index 2, add one with private lambda
        let nums_arr_elem_plus_one = private_add_one_lambda(o.nums[2].arr[2]);

        val_plus_one + doubled_arr_elem + nums_val_plus_one + nums_arr_elem_plus_one
    }

    //
    // SPEC block to verify chained access and lambda constraints
    //
    spec schema OuterSpec(o: Outer) {
        let v1 = private_add_one_lambda(o.inner.val);
        let v2 = private_double_lambda(o.inner.arr[1]);
        let v3 = private_add_one_lambda(o.nums[1].val);
        let v4 = private_add_one_lambda(o.nums[2].arr[2]);

        v1 + v2 + v3 + v4 == test_chained_access(&o);
    }

    spec test_outer_spec() {
        let o = create_outer();
        assert!(OuterSpec(o), 1001);
    }
}


//# run 0xCAFE::ComplexAccess::test_chained_access --args 0xCAFE::ComplexAccess::create_outer()


// Featurres:
// 12e23ce9d95ad2bc7d29c694cc830809: Chain field accesses or index expressions (e.g., x.f, x[1]) after an expression.
// d7f37301c80f39e25c622a37f4594d19: Specify specifications and variable bindings with `Spec` expressions.
// f760109d2b7d4ba9e4333b4b2b4a464f: Add new lambda functions as private top-level functions in the module after lifting.
