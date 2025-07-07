//# publish
module NestedLoopTest {
    public fun run_nested_loops() {
        let total = 0;
        // Outer loop: iterate from 0 to 10
        for (i in 0..10) {
            total = total + 2; // Increment total to track outer loop iterations
            // Inner loop: iterate from i to 10
            for (j in i..10) {
                total = total + 3; // Increment total for each inner loop iteration
            };
        };
        // After loops, total should reflect the sum of increments
        // Outer loop runs 10 times (i=0..9)
        // Inner loop counts vary: when i=0, j=0..10 (11 iterations), etc.
        // Total increments: outer (10 * 2) + sum of inner contributions
        // Computing expected total:
        // Outer contribution: 10 * 2 = 20
        // Inner contributions: sum_{i=0}^{9} (10 - i + 1)
        // inner iterations sum: 11 + 10 + 9 + 8 + 7 + 6 + 5 + 4 + 3 + 2 = 65
        // total increments from inner loops: 65 * 3 = 195
        // combined total: 20 + 195 = 215
        assert!(total == 215, 42);
    }
}

 //# run
script {
    fun main(): () {
        NestedLoopTest::run_nested_loops();
    }
}