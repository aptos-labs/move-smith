//# publish
module 0xabcde::test_module {
    //# publish
    pub fun add10(x: u64): u64 {
        x + 10
    }

    //# publish
    fun multiply_by_two(x: u64): u64 {
        x * 2
    }

    //# publish
    fun complex_calc(x: u64, y: u64): u64 {
        add10(x) + multiply_by_two(y)
    }

    //# publish
    fun modify_and_sum(x: u64, y: u64): u64 {
        let new_x = add10(x);
        let new_y = multiply_by_two(y);
        new_x + new_y
    }

    //# publish
    fun generate_and_process() {
        let val1 = 5;
        let val2 = 7;
        let sum = modify_and_sum(val1, val2);
        // sum should be (5 + 10) + (7 * 2) = 15 + 14 = 29
        assert! (sum == 29, 128);
    }

    // Testing the `test` function using the pattern of local variables updated by function calls
    public fun test(): u64 {
        let a = 2;
        // call add10 with a, update a
        let a = add10(a); // a becomes 12
        // call multiply_by_two with a, update a
        let a = multiply_by_two(a); // a becomes 24
        // call add10 with a, update a
        let a = add10(a); // a becomes 34

        // call multiply_by_two with initial y, and add10 to initial y
        let y = 3;
        let y_times_2 = multiply_by_two(y); // 6
        let y_plus_10 = add10(y); // 13

        // call complex_calc with updated a and y
        add3(a, y_times_2, y_plus_10)
    }

    // Helper function for addition
    fun add3(x: u64, y: u64, z: u64): u64 {
        x + y + z
    }
}

//# run 0xabcde::test_module::test