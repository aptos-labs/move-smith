//# publish
module 0x1::InfiniteLoopEarlyReturnTest {
    public fun run_script() {
        // This function is just a placeholder to be called from scripts
        // No actual code needed here
    }
}

//# run
script {
fun main() {
    // Infinite loop with an early return
    while (true) {
        return;
    }
    // The assertion should never be reached due to return inside the loop
    assert!(false, 99);
}
}
