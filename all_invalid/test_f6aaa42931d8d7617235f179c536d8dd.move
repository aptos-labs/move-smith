//# publish
module 0xabcde::test_module {
    public fun add(a: u64, b: u64): u64 {
        a + b
    }

    public fun sub(a: u64, b: u64): u64 {
        a - b
    }

    public fun compute_nested(): u64 {
        let base = 100;
        // Modify local variable and perform nested addition
        let temp = sub(base, 20);
        let sum = add(temp, 50);
        // Further modify local variable
        let temp2 = add(sum, 10);
        temp2
    }

    public fun verify_computation(): bool {
        compute_nested() == 140
    }

    public fun test_sequence_of_assignments(): u64 {
        let val = 5;
        // Sequential modifications
        let x = val;
        let x = add(x, 10);
        let x = sub(x, 3);
        let x = add(x, 2);
        x
    }

    public fun verify_test_sequence(): bool {
        test_sequence_of_assignments() == 16
    }

    fun increment(a: &mut u64, by: u64): u64 {
        *a = *a + by;
        *a
    }

    public fun multiple_increments(): u64 {
        let counter = 0;
        // Sequential increments
        let c1 = increment(&mut counter, 3);
        let c2 = increment(&mut counter, 7);
        let c3 = increment(&mut counter, 2);
        c1 + c2 + c3
    }

    public fun verify_increments(): bool {
        multiple_increments() == 3 + 7 + 2
    }
}

//# run 0xabcde::test_module::verify_computation --signers 0x1
//# run 0xabcde::test_module::verify_test_sequence --signers 0x1
//# run 0xabcde::test_module::verify_increments --signers 0x1