
//# publish
module 0xCAFE::TestImports {
    use std::vector;
    use std::math::Max;

    // test_only]
    public fun test_only_func(): u64 {
        // use the imported function from std::math::Max
        let x = 10u64;
        let y = 20u64;
        Max::max(x, y)
    }

    // test_only(skip = [linter_foobar])]
    public fun test_only_with_skip(): u64 {
        // use vector::length
        let v = vector::empty<u8>();
        vector::length(&v)
    }
}



//# run 0xCAFE::TestImports::test_only_func



//# run 0xCAFE::TestImports::test_only_with_skip
