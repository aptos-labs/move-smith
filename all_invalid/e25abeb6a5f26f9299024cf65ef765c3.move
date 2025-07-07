
//# publish
module 0xCAFE::TestFeatures {
    // Testing function bodies with braces containing a sequence of statements
    public fun test_func_body(flag: bool): u8 {
        let result = 0;
        if (flag) {
            result = 1;
        } else {
            result = 2;
        };
        let temp = result + 1;
        // last expression is return value
        temp
    }

    // Testing suppression of warnings with // skip(checker_name)]
    // skip(generic_field)]
    public struct SuppressWarning<T> has copy, drop {
        value: T
    }

    // Function demonstrating annotation and initial value check
    public fun foo(n: u64): u64 {
        let acc = 2;
        if (n == 0) {
            acc
        } else {
            let i = 1;
            while (i < n) {
                acc = 3;
                i = i + 1;
            };
            acc
        }
    }

    // Runner function to test the 'foo' method
    public fun run_tests() {
        let result_zero = foo(0);
        let result_one = foo(1);
        result_zero
    }
}


//# run 0xCAFE::TestFeatures::test_func_body --args true


//# run 0xCAFE::TestFeatures::foo --args 0u64


//# run 0xCAFE::TestFeatures::foo --args 1u64


//# run 0xCAFE::TestFeatures::run_tests


// Featurres:
// 66480643463c9b1e7ba47defa45ab55f: Write function bodies enclosed in braces containing a sequence of statements.
// e909c181c5601375ca40711cd95148ab: Suppress warnings for specific checks by annotating functions or modules with `#[skip(checker_name)]`.
// df1dca05d1065dece7e545b57499f14c: Test that the function `foo` correctly returns initial value 2 when `n` is zero, and updates to 3 during the loop when `n` is one.
