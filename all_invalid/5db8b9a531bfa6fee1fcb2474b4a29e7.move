
//# publish
module 0xCAFE::InlineRefTests {
    use std::vector;

    struct Container has copy, drop, store {
        val: u64,
    }

    struct ContainerMut has store {
        val: u64,
    }

    struct ContainerPair has store {
        a: u64,
        b: u64,
    }

    /// inline generic function foo:
    /// it takes a lambda `g` and two arguments `x` and `y`,
    /// calls `g(x, y)` and returns its result.
    /// This tests inline generic function with lambda parameters.
    public inline fun foo<T1, T2, R>(
        g: |(&T1, &T2) -> R,
        x: &T1,
        y: &T2
    ): R {
        g(x, y)
    }

    /// inline generic function foo mutable version:
    /// it takes a lambda `g` and two mutable references,
    /// calls `g(x, y)` and returns its result.
    public inline fun foo_mut<T1, T2, R>(
        g: |(&mut T1, &mut T2) -> R,
        x: &mut T1,
        y: &mut T2
    ): R {
        g(x, y)
    }

    /// inline generic function foo mixed (immutable + mutable refs):
    public inline fun foo_mix<T1, T2, R>(
        g: |(&T1, &mut T2) -> R,
        x: &T1,
        y: &mut T2
    ): R {
        g(x, y)
    }

    /// Simple test function that uses foo with immutable references
    public fun test_immut_refs(): u64 {
        let c1 = Container { val: 10 };
        let c2 = Container { val: 15 };

        let get_sum = |x: &Container, y: &Container| -> u64 {
            x.val + y.val
        };
        let res = foo(get_sum, &c1, &c2);
        res
    }

    /// Test function that uses foo_mut with mutable references to mutate values
    public fun test_mut_refs(): u64 {
        let c1 = ContainerMut { val: 100 };
        let c2 = ContainerMut { val: 50 };

        let add_and_swap = |x: &mut ContainerMut, y: &mut ContainerMut| -> u64 {
            let sum = x.val + y.val;
            x.val = y.val;
            y.val = sum;
            sum
        };

        let res = foo_mut(add_and_swap, &mut c1, &mut c2);

        // result should be original sum: 150
        // c1.val should now be 50
        // c2.val should now be 150
        assert!(c1.val == 50, 1000);
        assert!(c2.val == 150, 1001);
        res
    }

    /// Test function that uses foo_mix with immutable then mutable references
    public fun test_mix_refs(): u64 {
        let c1 = Container { val: 8 };
        let c2 = ContainerMut { val: 20 };

        let combine = |x: &Container, y: &mut ContainerMut| -> u64 {
            let res = x.val * y.val;
            y.val = y.val + 1;
            res
        };

        let res = foo_mix(combine, &c1, &mut c2);
        // c2.val increased by 1
        assert!(c2.val == 21, 1002);
        res
    }

    /// Test function that creates a new struct from references using foo:
    /// Here, foo calls a lambda copying fields from references into a new struct.
    public fun test_create_struct(): ContainerPair {
        let c1 = Container { val: 3 };
        let c2 = Container { val: 7 };

        let make_pair = |x: &Container, y: &Container| -> ContainerPair {
            ContainerPair { a: x.val, b: y.val }
        };

        let res = foo(make_pair, &c1, &c2);
        res
    }

    /// Test reference safety by borrowing and passing to foo and lambdas to ensure no aliasing or use-after-free:
    public fun test_reference_safety(): u64 {
        let c = ContainerMut { val: 42 };

        // borrow immutable ref first
        let cref: &ContainerMut = &c;

        // borrow mutable ref next: should be allowed in this nested safe pattern
        // We create a lambda that only reads cref and writes to mut ref y
        let ref_lambda = |x: &ContainerMut, y: &mut ContainerMut| -> u64 {
            // Read from x (immutable)
            let val_x = x.val;
            // Write to y (mutable)
            y.val = y.val + 1;
            val_x + y.val
        };

        let result = foo_mix(mut ref_lambda, cref, &mut c);
        // After call, c.val = 43

        assert!(c.val == 43, 1003);
        result
    }

    // Runner function to execute all tests, returns vector<u64>
    public fun run_all_tests(): vector<u64> {
        let res_vec = vector::empty<u64>();

        let r1 = test_immut_refs();
        vector::push_back(&mut res_vec, r1);

        let r2 = test_mut_refs();
        vector::push_back(&mut res_vec, r2);

        let r3 = test_mix_refs();
        vector::push_back(&mut res_vec, r3);

        let pair = test_create_struct();
        vector::push_back(&mut res_vec, pair.a);
        vector::push_back(&mut res_vec, pair.b);

        let r5 = test_reference_safety();
        vector::push_back(&mut res_vec, r5);

        res_vec
    }
}


//# run 0xCAFE::InlineRefTests::test_immut_refs


//# run 0xCAFE::InlineRefTests::test_mut_refs


//# run 0xCAFE::InlineRefTests::test_mix_refs


//# run 0xCAFE::InlineRefTests::test_create_struct


//# run 0xCAFE::InlineRefTests::test_reference_safety


//# run 0xCAFE::InlineRefTests::run_all_tests


// Featurres:
// a21f70c31d56c0c8862aaa45671c6d95: Test that the inline function `foo` correctly calls the provided lambda `g` with the given arguments and returns its result in the `test` function.
// 264e8d0df05ecc5243ec3f8eecb914f0: Enforce reference safety rules for Move references.
// ef8758a86bf601a8d562b28d5806c116: Define struct types within a module.
