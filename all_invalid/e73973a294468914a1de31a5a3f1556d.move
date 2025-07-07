//# publish
module 0x1::SumModule {
    // Function to compute sum of three local variables
    public fun main() {
        let a = 10;
        let b = 20;
        let c = 30;
        let sum = a + b + c;
        // Assertion that sum is correct
        assert!(sum == 60, 42);
    }

    // Internal function to compute sum of three numbers
    public fun compute_sum(x: u64, y: u64, z: u64): u64 {
        x + y + z
    }

    // Runner function to test compute_sum
    public fun run_sum() {
        let result = compute_sum(10, 20, 30);
        assert!(result == 60, 42);
    }
}

//# run 0x1::SumModule::main --signers 0x1
//# run 0x1::SumModule::run_sum --signers 0x1