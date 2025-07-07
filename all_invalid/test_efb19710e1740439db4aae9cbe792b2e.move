//# publish
module 0xabcde::variable_reassignment_test {
    public fun test_reassign() {
        // Declare a variable and assign initial value
        let mut count: u64 = 10;
        // Reassign the variable with a new value
        count = 20;
        // Reassign again
        count = 30;

        // Declare another variable based on the first
        let mut temp = count;
        // Reassign the second variable
        temp = 40;

        // Declare a variable with an initial value
        let mut value = 100;
        // Reassign with a different value
        value = 200;
    }

    public fun test_reassign_with_params(param1: u8, param2: u64) {
        let mut sum = param1 as u64;
        sum = sum + param2;
        sum = sum + 50;
    }
}

//# run 0xabcde::variable_reassignment_test::test_reassign --args
//# run 0xabcde::variable_reassignment_test::test_reassign_with_params --args 5 15