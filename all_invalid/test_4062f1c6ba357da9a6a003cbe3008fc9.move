//# publish
module 0xDEADBEEF::test_composite {
    // Struct with nested u64s for more complex comparison
    struct ComplexData has copy, drop {
        outer_f: u64,
        inner: InnerData,
    }

    struct InnerData has copy, drop {
        inner_f: u64
    }

    // Equality function comparing u64 values within structs
    fun eq_with_u64(x: u64): |u64| bool {
        |y| x == y
    }

    fun eq_with_complex(data1: ComplexData, data2: ComplexData): bool {
        data1.outer_f == data2.outer_f && data1.inner.inner_f == data2.inner.inner_f
    }

    public fun test_structs(x: u64): bool {
        let s1 = ComplexData {
            outer_f: 5,
            inner: InnerData { inner_f: 10 }
        };
        let s2 = ComplexData {
            outer_f: x,
            inner: InnerData { inner_f: x + 5 }
        };
        eq_with_complex(s1, s2)
    }
}

//# run 0xDEADBEEF::test_composite::test_structs --args 5

//# publish
module 0x0abc::higher_order {
    // Closure capturing a u64 value
    fun make_closure(captured: u64): |()| u64 {
        || captured
    }

    // Function that takes a closure and invokes it twice
    fun invoke_twice(f: |()| u64): u64 {
        f() + f()
    }

    // Higher-order function combining closure creation and invocation
    public fun test(x: u64): u64 {
        let closure = make_closure(x);
        invoke_twice(closure)
    }

    // Runner function for testing
    public fun run_test(): u64 {
        test(20)
    }
}

//# run 0x0abc::higher_order::run_test

//# publish
module 0xFAKE::nested_functions {
    // Recursive nested closure
    fun nested_closure(level: u64): |()| u64 {
        if (level == 0) {
            || 1
        } else {
            let inner = nested_closure(level - 1);
            || inner() + 1
        }
    }

    // Main function to test recursive closures
    public fun test_nested(): u64 {
        let f = nested_closure(3);
        f() // Should produce 4 (1 + 1 + 1 + 1)
    }

    // Runner function
    public fun run_nested(): u64 {
        test_nested()
    }
}

//# run 0xFAKE::nested_functions::run_nested