//# publish
module 0xdead::apply_repeatedly_test {
    fun apply_repeatedly(f: |u64|u64 has copy + drop, times: u64): |u64|u64 has copy + drop {
        |x| {
            let mut count = 0;
            while (count < times) {
                x = f(x);
                count = count + 1;
            };
            x
        }
    }

    public fun test(): u64 {
        // Increment by 2, 5 times starting from 0 -> result should be 10
        apply_repeatedly(|x| x + 2, 5)(0)
    }

    fun test_nested_repetition() : u64 {
        // Nested application: apply a doubling function 3 times starting from 1
        let double_fn = |x| x * 2;
        let double_three_times = apply_repeatedly(double_fn, 3);
        // Should be: ((1*2)*2)*2 = 8
        double_three_times(1)
    }
}

//# run 0xdead::apply_repeatedly_test::test
//# run 0xdead::apply_repeatedly_test::test_nested_repetition