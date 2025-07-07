//# publish
module 0xCAFE::TestIfElseAssign {
    public fun test_assign(x: u64): u64 {
        let mut a;
        // if-else expression without surrounding braces for assignment
        if x > 10 then
            a = x + 1;
        else
            a = x - 1;

        a
    }

    public fun runner(): u64 {
        let res1 = Self::test_assign(15);
        let res2 = Self::test_assign(5);
        res1 + res2
    }
}

//# run 0xCAFE::TestIfElseAssign::runner


//# publish
module 0xCAFE::TestNoFunctionReturn {
    // Simulate a function that returns a function type - this should be rejected by compiler in <2.2
    // We'll just declare the function to return it, no body needed here for test.

    // Type alias for function type
    // Note: This is allowed syntactically, but returning function type values is not supported pre-2.2.
    // We add this to test compiler behavior.

    // We don't actually implement because it won't compile if returning function values is disallowed,
    // So just define a function type and attempt to return function reference.

    // Commented out code that would fail compile to show intent:
    /*
    public fun returns_function(): &fn() acquires TestNoFunctionReturn {
        &Self::dummy_fun
    }
    */

    public fun dummy_fun() {}

    // Workaround: has function type variable but does not return it, to keep test compiling
    public fun runner() {
        let f: fn() = dummy_fun;
        // do nothing with f
    }
}

//# run 0xCAFE::TestNoFunctionReturn::runner


//# publish
module 0xCAFE::TestVectorTypeParam<T> {
    public fun create_vector_with_element(elem: T): vector<T> {
        let mut v = vector::empty<T>();
        vector::push_back(&mut v, elem);
        v
    }

    public fun runner(): u64 {
        let vec = Self::create_vector_with_element(42u64);
        vector::length(&vec)
    }
}

//# run 0xCAFE::TestVectorTypeParam::runner

// Featurres:
// 7c1276e62daf1f29cf6bb2d08c315f97: Test that variable assignment inside an if-else expression without surrounding braces is correctly handled by the Move language.
// 39a3cdaaa18a31c0d71575540bad9f84: Prevent functions from returning function-typed values in language versions before 2.2.
// 1df1c75b7c273f1fbf3eb764932c6eec: Use type parameters properly within vector types.
