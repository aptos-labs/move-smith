//# publish
module 0xCAFE::TestLoopsAndErrors {
    use std::error;

    public fun runner() {
        let mut i = 0;
        let mut sum = 0;

        // While loop: accumulate sum of 0 to 9
        while (i < 10) {
            if (i % 2 == 0) {
                sum = sum + i;
            } else {
                // Nested while with trailing unit expression implicitly added
                let mut j = 0;
                while (j < 2) {
                    j = j + 1;
                }
            }
            i = i + 1;
            // no final expression needed, unit appended automatically
        };

        // Try to use an unresolved type to cause error placeholder type
        // Commented because it won't compile, but in transactional tests, unresolved
        // types become placeholders internally, testing that feature.
        // let _x: UnresolvedType;
        
        // Just a dummy usage of error code to utilize std::error module
        let _err: error::Error = error::NOT_FOUND;

        // Unit expression is implied here, no explicit return needed
    }
}

//# run 0xCAFE::TestLoopsAndErrors::runner --signers 0xCAFE


//# publish
module 0xCAFE::ErrorPlaceholderTest {
    // This module tries to refer to an unresolved type inside a function.
    // This should trigger the VM/compiler error placeholder type facility.

    public fun unresolved_type_use() {
        // Declare a variable with an unresolved type name
        // This will not compile normally but in transactional tests,
        // unresolved types become error placeholders.
        let _x: SomeMissingType;
    }
}

//# run 0xCAFE::ErrorPlaceholderTest::unresolved_type_use --signers 0xCAFE


//# run
script {
    fun main(account: &signer) {
        let mut count = 0;

        // while with nested if and without final expression
        while (count < 3) {
            if (count == 1) {
                count = count + 2;
            } else {
                count = count + 1;
            }
            // no final expression here, trailing unit will be appended
        };
    }
}

// Featurres:
// b0977166124a342053b03544cc9b5b39: Use 'while' loops with condition expressions and nested control sequences.
// c9d6665606050d6ab8528eac7b0ddc98: Automatically append a trailing unit expression to sequences when the final expression is missing, ensuring sequence completeness.
// a92129a9ab72b58d4326795e25b9bfcb: Use error placeholder types for unresolved types.
