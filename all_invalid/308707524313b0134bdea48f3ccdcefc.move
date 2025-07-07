//# publish
module 0xDEAD::TestModule {
    use std::assert;

    //# publish
    public fun compute_sum(a: u64, b: u64, c: u64): u64 {
        a + b + c
    }

    //# publish
    public fun main(): bool {
        let x = 10;
        let y = 20;
        let z = 30;
        let sum = compute_sum(x, y, z);
        // Check that the sum matches expected value (60)
        assert::assert_true(sum == 60, 1000);
        // Additional test: pattern matching with '..' in destructuring if applicable
        // Since pattern matching with '..' is limited in Move, simulate a matching scenario
        let some_value = 5;
        match some_value {
            0 => true,
            1..=10 => true,
            .. => false,
        }
    }
}

//# run 0xDEAD::TestModule::main