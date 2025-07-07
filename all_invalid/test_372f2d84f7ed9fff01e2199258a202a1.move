//# publish
module 0x01::LabeledLoopTest {
    public fun test_labeled_continue_breaks() {
        let mut count = 0;
        'outer: while (count < 200) {
            while (count < 150) {
                'inner: while (count < 120) {
                    count += 3;
                    continue 'outer; // should break the inner and outer loop, jump to next 'outer'
                }
                count += 5;
                continue 'outer;
            }
            count += 10;
        }
        assert!(count == 210, 210);
    }

    public fun run_tests() {
        test_labeled_continue_breaks();
    }
}
//# run 0x01::LabeledLoopTest::run_tests


//# publish
module 0x02::InlineFunctionInteraction {
    public inline fun multiply_by_two(x: u64): u64 {
        x * 2
    }

    public inline fun add_three(x: u64): u64 {
        x + 3
    }
}

//# publish
module 0x02::InteractionTest {
    use 0x02::InlineFunctionInteraction;

    fun compute_value(): u64 {
        // Call nested inline functions from different modules
        InlineFunctionInteraction::multiply_by_two(
            InlineFunctionInteraction::add_three(4)
        )
    }

    public fun main(): u64 {
        compute_value()
    }

    public fun run_test() {
        let result = main();
        assert!(result == 14, 14); // (4 + 3) * 2 = 14
    }
}
//# run 0x02::InteractionTest::run_test


//# publish
module 0x03::RangeTest {
    public fun test_empty_range() {
        let mut counter = 0;
        for (i in 20..10) {
            counter = counter + 1;
        }
        // The loop body should not execute
        assert!(counter == 0, 0);
    }

    public fun main() {
        test_empty_range();
    }
}
//# run 0x03::RangeTest::main