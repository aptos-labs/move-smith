
//# publish
module 0xCAFE::TestImports {
    use std::math;
    use std::vector;

    // test_only]
    public fun test_only_func(): u64 {
        // use an imported function from std::math
        let x = 10u64;
        let y = 20u64;
        math::max(x, y)
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


// Featurres:
// 31e040234cbac2ec3c9e51a2d34acd17: Import modules from pre-compiled libraries into your Move package.
// 50c36c2eb027d9822b4985ebe0d099de: Annotate test functions with #[test_only] to restrict their use for certain purposes, but not in combination with #[test].
// 1685438536d8cc8c135091d1019a6c42: Ensure that when using the `skip` attribute, the specified lint names are known and valid, or the compiler will generate an error.
