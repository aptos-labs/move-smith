
//# publish
module 0xCAFE::TestPlan {
    use std::signer;

    /// Collect and organize test functions in one module as a test plan.
    /// All test functions are public so they can be invoked externally.
    public fun test_all() {
        test_if_else();
        test_loops();
        test_structs();
        test_enums();
        test_lambda();
        test_vector_operations();
    }

    public fun test_if_else() {
        if (true) {
            let _x = 1;
        } else {
            let _y = 2;
        };
        if (false) {
            let _a = 3;
        } else {
            let _b = 4;
        };
    }

    public fun test_loops() {
        let i = 0u8;
        while (i < 3) {
            i = i + 1;
        };
        let x = 0u8;
        loop {
            if (x == 2) {
                break;
            };
            x = x + 1;
        };
        for (_i in 0..3) {
            // do nothing inside for
        };
    }

    struct S has copy, drop, store {
        a: u8,
        b: u8,
    }

    public fun test_structs() {
        let s = S {a: 10u8, b: 20u8};
        let S {a, b} = s;
        let _sum = a + b;
    }

    enum MyEnum has copy, drop {
        V1,
        V2(u8, u8),
        V3 { flag: bool },
    }

    public fun test_enums() {
        let e1 = MyEnum::V1;
        let e2 = MyEnum::V2(5u8, 6u8);
        let e3 = MyEnum::V3 { flag: true };
        let _res1 = match e1 {
            MyEnum::V1 => 1u8,
            MyEnum::V2(x, y) => x + y,
            MyEnum::V3 { flag } => if (flag) { 2u8 } else { 3u8 },
        };
        let _res2 = match e2 {
            MyEnum::V1 => 4u8,
            MyEnum::V2(x, y) => x * y,
            MyEnum::V3 { flag } => if (flag) { 5u8 } else { 6u8 },
        };
        let _res3 = match e3 {
            MyEnum::V1 => 7u8,
            MyEnum::V2(x, y) => x - y,
            MyEnum::V3 { flag } => if (flag) { 8u8 } else { 9u8 },
        };
    }

    public fun test_lambda() {
        let add: |u8, u8|u8 has copy+drop = |x: u8, y: u8| x + y;
        let res = add(3u8, 4u8);
        let _ = res;
    }

    public fun test_vector_operations() {
        use std::vector;
        let v = vector::empty<u8>();
        vector::push_back(&mut v, 10u8);
        vector::push_back(&mut v, 20u8);
        let first = *vector::borrow(&v, 0);
        let second = *vector::borrow(&v, 1);
        let val1 = vector::pop_back(&mut v);
        let val2 = vector::pop_back(&mut v);
        let _ = (first + second + val1 + val2);
    }
}


//# run 0xCAFE::TestPlan::test_all


// Featurres:
// 324fb212eadc0a8bba9ecc14a09b64a1: Collect and organize test functions into a test plan for the module.
// 0a38877e9df2d5e826a5ae54b1bf6abf: Convert scripts into modules when the experiment for attaching compiled modules is enabled.
// fcc9fee0cda6d242ce153b78b45832e0: Use attributes with apply syntax to specify attributes without parameters that signal expected failures.
