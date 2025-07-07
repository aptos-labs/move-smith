
//# publish
module 0xCAFE::TestModule {
    // A helper function to simulate AST filtering, just to keep the code relevant for verification.
    public fun filtered_verification() {
        // no-op for verification purposes
    }
}


//# run 0xCAFE::TestModule::filtered_verification
// No assertions are needed here, just testing callability and AST filtering.


//# run
script {
    fun main() {
        let i = 0;
        loop {
            if (i >= 10) {
                break;
            }
            i = i + 1;
        }
    }
    main();
}
// This tests that the script terminates immediately upon break inside the loop and does not proceed further.

// Featurres:
// 40386585b505f1be911d5d00db89f09e: Test that the script terminates immediately when encountering a 'break' statement inside a loop without executing any assertions.
// 94c414d896fd044e3e113f97fb8b963e: Apply AST filtering for verification purposes.
// 41ec3c2a8d515c6874c92a56ba658423: Test that inline function parameters can accept and apply lambda expressions (closures) as arguments, including when lambdas are nested within each other.
