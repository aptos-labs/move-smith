//# publish
module 0xabcde::test_module {
    fun get_value(input: u64): u64 {
        let result = input;
        result
    }

    struct Counter has drop {
        count: u64,
    }

    public fun update_counter(c: &mut Counter): u64 {
        c.count = c.count + 2;
        c.count
    }

    public fun compute_sum(a: u64, b: u64): u64 {
        a + b
    }

    public fun setup_and_return(): u64 {
        let init_value = 10;
        let counter = Counter { count: 0 };
        let new_count = update_counter(&mut counter);
        let sum = compute_sum(init_value, new_count);
        sum
    }
}

//# run 0xabcde::test_module::get_value --args 42
//# run 0xabcde::test_module::setup_and_return