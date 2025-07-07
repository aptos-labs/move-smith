//# publish
module 0xabcde::nested_if_else {
    //# run
    fun execute_nested_conditional(): () {
        if (true) {
            if (false) {
                // Do nothing
            } else {
                return ();
            }
        } else {
            assert!(false, 999);
            return ();
        }
    }

    //# run
    fun run_nested_if_else_test(): () {
        execute_nested_conditional();
        // Function should complete without errors
    }
}

//# run 0xabcde::nested_if_else::run_nested_if_else_test

//# publish
module 0xabcde::variable_capture {
    //# run
    fun modify_and_sum(): u64 {
        let mut count = 0;
        // Inline functions that modify 'count'
        inline fun increment(): u64 {
            count = count + 2;
            count
        }
        inline fun double_increment(): u64 {
            count = count + 3;
            count
        }

        let total = count + increment() + double_increment();
        total
    }
}

//# run 0xabcde::variable_capture::modify_and_sum

//# publish
module 0xabcde::increment_test {
    //# run
    fun increment_value(x: u64): u64 {
        let x = x + 1; // Increment the value
        x
    }

    //# run
    fun test_increment(): u64 {
        let initial = 5;
        initial + increment_value(initial) + increment_value(initial)
    }
}

//# run 0xabcde::increment_test::test_increment