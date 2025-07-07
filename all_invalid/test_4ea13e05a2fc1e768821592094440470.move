//# publish
module 0xabc::test_module {
    fun assign_and_return() : u64 {
        let mut value = 10;
        value = 20;
        value
    }

    public fun run_assign() {
        // Call assign_and_return to see the value update before returning
        let result = assign_and_return();
        assert!(result == 20, 0);
    }
}

//# run 0xabc::test_module::run_assign

//# publish
module 0xdef::sum_module {
    fun sum_three(a: u64, b: u64, c: u64) : u64 {
        a + b + c
    }

    fun calculate_and_assign() : u64 {
        let (x, y, z) = (7, 8, 9);
        let result = sum_three(x, y, z);
        result
    }

    public fun for_user() : u64 {
        // Call the function that sums predefined numbers
        calculate_and_assign()
    }
}

//# run 0xdef::sum_module::for_user