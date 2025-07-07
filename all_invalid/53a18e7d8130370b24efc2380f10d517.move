
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