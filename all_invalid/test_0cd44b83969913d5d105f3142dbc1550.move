//# publish
module 0xc0ffee::new_tests {
    fun nested_function_calls(param1: u64): u64 {
        // Call an inline function, then pass its result to another function call
        inline fun add_two(x: u64): u64 {
            x + 2
        }
        fun double_value(x: u64): u64 {
            x * 2
        }
        double_value(add_two(param1))
    }

    fun create_tuple_package(a: u32, b: u64): (u128, bool) {
        (a as u128, b > 100)
    }

    fun process_tuple_and_assign(x: u64): u64 {
        let result = create_tuple_package(10, x);
        // Destructure tuple and use only one element
        let (_tuple1, flag) = result;
        if (flag) {
            _tuple1 as u64
        } else {
            x + 10
        }
    }

    fun variable_reassignment_test(val: u64): u64 {
        let mut x = val;
        // Use inline function with closure
        inline fun increment(y: u64): u64 {
            y + 1
        }
        x = increment(x);
        // Inline function that captures external variable
        inline fun add_external(y: u64): u64 {
            y + x
        }
        add_external(5)
    }

    // Runner to invoke nested_function_calls
    public fun run_nested_calls(): u64 {
        nested_function_calls(7)
    }

    // Runner to process tuple
    public fun run_process_tuple(): u64 {
        process_tuple_and_assign(150)
    }

    // Runner to test variable reassignment and inline closure
    public fun run_variable_reassignment(): u64 {
        variable_reassignment_test(10)
    }
}

// //# run 0xc0ffee::new_tests::run_nested_calls --args
// //# run 0xc0ffee::new_tests::run_process_tuple --args
// //# run 0xc0ffee::new_tests::run_variable_reassignment --args