//# publish
module 0xabcde::addition_abort {
    public fun test(): u16 {
        // Perform addition within an expression, with an abort triggered conditionally
        let trigger_abort = true;
        let result = if (trigger_abort) {
            abort 42;
        } else {
            100u16 + 200u16
        };
        result
    }

    public fun run_test(): u16 {
        Self::test()
    }
}

//# run 0xabcde::addition_abort::run_test

//# publish
module 0xabcde::tuple_destruct {
    public fun compute(): u128 {
        let a = 10u128;
        let b = 20u128;
        let c = 30u128;
        let (x, y, z) = (a + 1, b + 2, c + 3);
        // Modify the variables sequentially
        let (x, y, z) = (x + 1, y + 2, z + 3);
        // Return sum
        x + y + z
    }
}

//# run 0xabcde::tuple_destruct::compute
