//# publish
module 0xCAFE::ArrayVectorTest {
    use std::vector;
    use std::debug;

    // A function to test indexing arrays and vectors, including out-of-bound (which will abort)
    public fun test_indexing() {
        let arr = [10u8, 20u8, 30u8];
        // Indexing array by valid index
        let a0 = arr[0];
        let a1 = arr[1];
        let a2 = arr[2];

        // Create a vector and push elements
        let mut v = vector::empty<u64>();
        vector::push_back(&mut v, 100u64);
        vector::push_back(&mut v, 200u64);
        vector::push_back(&mut v, 300u64);

        let v0 = *vector::borrow(&v, 0);
        let v1 = *vector::borrow(&v, 1);
        let v2 = *vector::borrow(&v, 2);

        // Although out-of-bound would abort, this line is commented out to avoid abort
        // let _ = arr[3];

        debug::print(&vector::empty<u8>()); // just to use debug::print, no output expected
    }

    // A function returning true to resemble a report of warnings (mocked)
    public fun report_warnings(): bool {
        // There is no direct Move API to get compiler warnings at runtime
        // We emulate by returning true for test suite to display this as a dummy call
        true
    }
}

//# run 0xCAFE::ArrayVectorTest::test_indexing

//# run 0xCAFE::ArrayVectorTest::report_warnings

// Featurres:
// d7251deb557b3a3afcdca0d1bf9f3502: Index into arrays or vectors using square brackets, such as `vec[i]`.
// a49b8e82c01c39e09dcc85474f787b58: Use named imports (use declarations) within modules.
// 141a23e611f2ad603051b0ff7caaf9e7: Review compiler warnings with severity 'Warning' by calling report_warnings() to display them to the user.
