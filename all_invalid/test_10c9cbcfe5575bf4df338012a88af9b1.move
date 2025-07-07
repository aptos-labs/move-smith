//# publish
module 0x1::reassign_test {
    public fun demo_reassign(): u64 {
        let mut counter = 10;
        counter = counter + 5;
        counter = counter * 2;
        counter
    }

    public fun run_test() {
        assert!(demo_reassign() == 30, 0);
    }
}

//# run 0x1::reassign_test::run_test

//# publish
module 0x2::variable_manipulation {
    public fun update_and_return(): u128 {
        let mut balance = 1000;
        // reassign balance multiple times
        balance = balance - 250;
        balance = balance + 125;
        balance
    }

    public fun invoke() {
        assert!(update_and_return() == 975, 0);
    }
}

//# run 0x2::variable_manipulation::invoke

//# publish
module 0x3::complex_reassignment {
    public fun modify_value(): bool {
        let mut flag = false;
        // Reassign the flag based on a condition
        flag = true;
        // Flip the boolean value
        flag = !flag;
        flag
    }

    public fun test_modify() {
        assert!(modify_value() == false, 0);
    }
}

//# run 0x3::complex_reassignment::test_modify