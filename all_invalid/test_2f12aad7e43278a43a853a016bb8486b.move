//# publish
module 0x1::test_module {
    public fun runner() {
        // This function is a placeholder to allow calling from scripts
    }

    //# run 0x1::test_module::runner
}

//# run
script {
    fun main() {
        let mut counter = 0;

        // Loop from 0 to 20
        for (i in 0..20) {
            // Increment counter each iteration
            counter = counter + 1;

            if (counter >= 12) {
                break;
            }
            // Skip even iterations
            if (i % 2 == 0) {
                continue;
            }
            // For odd i, add 5
            counter = counter + 5;

            // For certain i, modify differently
            if (i == 13) {
                // Reset counter
                counter = 0;
            }
        }
        // After loop, counter should be 16
        // Breakdown:
        // i from 0..19
        // Even i: continue, skip
        // Odd i: counter += 5
        // Break when counter >= 12
        // When i=1, counter=1+5=6
        // i=3, counter=6+5=11
        // i=5, counter=11+5=16 (break after this)
        // So final should be 16
        assert!(counter == 16, counter);
    }
}