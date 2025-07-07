//# publish
module 0x1234::SumAndUpdate {
    fun compute_sum_and_update(initial_value: u64): u64 {
        let mut total = initial_value; // start with the initial value
        let mut i = 10;                // counter from 10 down to 1

        while (i > 0) {
            // accumulate sum from 10 down to 1
            total = total + i;
            // update i by decrementing
            i = i - 1;
        };
        total // should be initial_value + sum 10..1 = initial_value + 55
    }

    // A runner function that can be called without arguments
    public fun run(): u64 {
        compute_sum_and_update(10) // starting with 10, total should be 10 + 55 = 65
    }
}

//# run 0x1234::SumAndUpdate::run


//# publish
module 0x5678::VarUpdateTest {
    public fun test(): u64 {
        let mut a = 5;
        let b = 10;
        // local variable 'a' is updated inside nested blocks
        let result = {
            let c = a + b; // 5 + 10 = 15
            {
                a = a + 3; // a becomes 8
                c + a // 15 + 8 = 23
            }
        };
        // further update to a after block
        a = a + 2; // a = 10
        result + a // 23 + 10 = 33
    }
}

//# run 0x5678::VarUpdateTest::test