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
        temp // Last expression is the return value
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
            acc // return acc if n == 0
        } else {
            let i = 1;
            while (i < n) {
                acc = 3;
                i = i + 1;
            };
            acc // return acc after loop
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
