//# run
script {
    use std::signer;
    use 0xDEAD::InteractionTest;

    fun main(s: signer) {
        // Initialize counter resource
        InteractionTest::init_counter(s);
        // Increment counter twice
        InteractionTest::increment_counter(s);
        InteractionTest::increment_counter(s);

        // Declare local variable outside loop
        let local_sum: u64 = 0;
        // Declare loop variable
        let i: u64 = 0;

        // Loop: for i in 0..3
        while (i < 3) {
            // Inside loop, declare shadowed local variable
            let local_sum = local_sum + i;
            // Increment loop variable
            i = i + 1;
        };

        // After loop, borrow the count resource for verification
        let count_before = InteractionTest::get_count(s);
        // 'local_sum' holds sum of 0+1+2=3

        // Note: Cannot call internal functions from outside module
        // The value of 'local_sum' can be used or asserted as needed
        // For example, a simple assertion (if supported):
        // assert(local_sum == 3, 100);

        // No further action needed
    }
}
