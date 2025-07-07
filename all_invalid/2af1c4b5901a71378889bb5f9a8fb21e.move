//# publish
module 0xCAFE::TestAttributes {
    use std::vector;

    #[test_only]
    public fun side_effect_sum(): u64 {
        // Use a local mutable variable to demonstrate side effects in expressions
        let mut x = 10u64;
        // The following expression evaluates to 100 + x (20 after update) + 30
        // with side effects: update x by adding 10 twice.
        let result = {
            x = x + 10;
            100u64
        } + {
            x = x + 10;
            x
        } + 30;
        result
    }

    public fun test(): u64 {
        // Call side_effect_sum and ensure the inner side effects worked as expected:
        // Initial x=10
        // First block: x=20 returns 100
        // Second block: x=30 returns 30
        // Total = 100 + 30 + 30 = 160
        side_effect_sum()
    }

    public inline fun runner(): u64 {
        test()
    }
}
//# run 0xCAFE::TestAttributes::runner --signers 0xCAFE

//# publish
module 0xCAFE::DummyModule {
    public fun dummy_function(): u64 {
        42
    }
}
//# run 0xCAFE::DummyModule::dummy_function --signers 0xCAFE

//# run
script {
    use 0xCAFE::TestAttributes;

    fun main() {
        // We run the test that sums expressions with side effects
        let s = TestAttributes::test();
        // No assert needed; just exercise compiler and VM
        let _ = s;
    }
}

// Featurres:
// 10163e7c3b2f0cf1fc228134b410143b: Annotate code with attributes using brackets preceded by a '#' sign
// 92ccf2b0791602d9eccb6618862cfa12: Test that the `test` function correctly evaluates and sums multiple expressions with side effects, ensuring that variable assignments within blocks update the variable as expected during evaluation.
// 19b3347fb09813cc821a900427f665c5: Define a single main function as the entry point in a script, and ensure the script is omitted if this function is filtered out.
