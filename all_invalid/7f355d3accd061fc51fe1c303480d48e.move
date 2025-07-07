
//# publish
module 0xCAFE::FeatureTest {
    use std::signer;

    // assert(spec)]
    public fun assert_example(x: u8) {
        // Specification assert: x must be less than 100
        assert!(x < 100, 1000);
    }

    // assert(ignore)]
    public fun assert_ignore_example(x: u8) {
        // This function suppresses some specific lints (pretend a lint 'spec-mutex' ignored)
        assert!(x != 0, 2000);
    }

    // linter(skip(spec-mutex))]
    public fun lint_skip_example(x: u8) {
        // Function annotated to skip lints with name 'spec-mutex'
        assert!(x > 0, 3000);
    }

    public fun example_decreases(x: u8) {
        // Decreases expression annotation to prove termination
        decreases x;
        let i = x;
        while(i > 0) {
            i = i - 1;
        };
    }

    // Runner to call all features without arguments
    public fun runner() {
        assert_example(5u8);
        assert_ignore_example(4u8);
        lint_skip_example(3u8);
        example_decreases(10u8);
    }
}


//# run 0xCAFE::FeatureTest::assert_example --args 50u8


//# run 0xCAFE::FeatureTest::assert_ignore_example --args 1u8


//# run 0xCAFE::FeatureTest::lint_skip_example --args 1u8


//# run 0xCAFE::FeatureTest::example_decreases --args 3u8


//# run 0xCAFE::FeatureTest::runner


// Featurres:
// 5e0902799ab755c35a5cabcf13775d0a: Write 'assert' specifications in Move code to add conditions that must hold at a point.
// 3c50d21bbb4567ffaa575f96d84c2c36: Use attribute-based lint skip annotations on Move functions to suppress specific lints.
// a3cc1c7e5a447e22cf5d1b108bcb21e5: Declare 'decreases' expressions for termination metrics.
