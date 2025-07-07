//# publish
module 0xabcde::var_update_test {
    fun modify_and_return() : u64 {
        let mut value = 10;
        // Change the value
        value = 20;
        // Further update
        value = 30;
        value
    }

    public fun run_test() {
        let result = modify_and_return();
        assert!(result == 30, 1);
    }
}

//# run 0xabcde::var_update_test::run_test