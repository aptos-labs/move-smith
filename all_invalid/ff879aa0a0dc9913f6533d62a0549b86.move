//# publish
module 0xA550C3::TestModule {
    // Define a simple struct to hold the variables (optional, for clarity)
    // This example focuses on the computational aspect
    public fun main(a: u64, b: u64, c: u64): u64 {
        let sum1 = a;
        let sum2 = b;
        let sum3 = c;
        let total = sum1 + sum2 + sum3;
        total
    }
}

//# run
script {
    // Compose the run command to execute the main function with sample arguments
    //# run 0xA550C3::TestModule::main --signers 0xA550C3 --args 10u64 20u64 30u64
}