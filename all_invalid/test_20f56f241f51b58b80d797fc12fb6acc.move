//# publish
module 0x1::ConditionalTest {
    // This module doesn't need to be published for this simple test, but included for completeness or future use.
}

 //# run
script {
fun main() {
    if (false) {
        // Branch should not be taken
        return ();
    } else {
        // Branch should be taken
        return ();
    }
}
}

 //# run 0x1::ConditionalTest::runner
module 0x1::ConditionalTest {
    public fun run() {
        main();
    }
}