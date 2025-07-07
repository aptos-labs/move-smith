//# publish
module 0xA550C18::VerifierOnlyExample {
    use std::error;
    use std::signer;

    #[verify_only]
    fun verification_only_function(): bool {
        // This function exists only during verification and should not be compiled to bytecode.
        true
    }

    public fun runner(): bool {
        // Calls the verification only function inside verify block to test its usage.
        // This function doesn't do anything in production.
        #[verify]
        let _ = verification_only_function();
        true
    }
}
//# run 0xA550C18::VerifierOnlyExample::runner

//# publish
module 0xA550C18::NoCyclicDepsA {
    public fun foo(): u64 {
        42
    }

    public fun runner(): u64 {
        foo()
    }
}
//# run 0xA550C18::NoCyclicDepsA::runner

//# publish
module 0xA550C18::NoCyclicDepsB {
    public fun bar(): u64 {
        24
    }

    public fun runner(): u64 {
        bar()
    }
}
//# run 0xA550C18::NoCyclicDepsB::runner

//# publish
module 0xA550C18::ForLoopInvariantTest {
    use std::error;

    const E_INVARIANT_VIOLATED: u64 = 0x100;

    // Runner function to test the for loop with invariant.
    public fun runner() {
        let mut sum: u64 = 0;
        let max = 5;
        let threshold = 10;

        let i = 0;
        while(i < max) {
            // Update sum
            sum = sum + i;

            // The loop invariant: sum must be less than threshold
            if (!(sum < threshold)) {
                abort E_INVARIANT_VIOLATED;
            }

            i = i + 1;
        }
    }
}
//# run 0xA550C18::ForLoopInvariantTest::runner

//# run
script {
    use std::signer;
    use 0xA550C18::ForLoopInvariantTest;

    fun main() {
        // This script runs the loop invariant test, expecting abort when invariant violated.
        // On the 5th iteration, sum will be 0+1+2+3+4=10 which is not < 10, so abort happens.
        ForLoopInvariantTest::runner();
    }
}