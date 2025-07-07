//# publish
module 0xABCD::arithmetic_mutable {
    // Function to add two u64 values
    fun add(x: u64, y: u64): u64 {
        x + y
    }

    // Function to subtract two u64 values
    fun subtract(x: u64, y: u64): u64 {
        y - x
    }

    // Function to increment a mutable reference
    public fun increment(mut value: &mut u64) {
        *value = *value + 10;
    }

    // Function to double a value passed by reference
    fun double_reference(x: &mut u64) {
        *x = *x * 2;
    }

    // Function to demonstrate passing references to other functions
    public fun modify_and_use(): u64 {
        let mut num = 5;
        // Pass mutable reference to increment
        increment(&mut num);
        // Pass mutable reference to double_reference
        double_reference(&mut num);
        // Return the modified value
        num
    }

    // Runner function for the above
    public fun run_modify_and_use(): u64 {
        modify_and_use()
    }
}

//# run 0xABCD::arithmetic_mutable::run_modify_and_use