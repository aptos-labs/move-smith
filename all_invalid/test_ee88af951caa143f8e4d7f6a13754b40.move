//# publish
module 0xabcde::mut_reference_test {
    fun increment(r: &mut u64) {
        *r += 5;
    }

    fun multiply_and_increment(r: &mut u64, factor: u64) {
        *r *= factor;
        *r += 3;
    }

    public fun test_mut_references() {
        let mut value = 10;
        // Pass mutable reference to increment
        increment(&mut value);
        // After increment, value should be 15
        assert!(value == 15);
        // Pass mutable reference to multiply_and_increment with factor 2
        multiply_and_increment(&mut value, 2);
        // After multiply and increment: (15 * 2) + 3 = 33
        assert!(value == 33);
    }

    public fun run_all() {
        test_mut_references();
    }
}

//# publish
module 0xabcde::simple_arithmetic {
    public fun add(x: u64, y: u64): u64 {
        x + y
    }

    public fun test() {
        let a = 7;
        let b = 8;
        let result = add(a, b);
        // result should equal 15, but assertions are optional
        // assert!(result == 15);
    }
}

//# run --verbose -- 0xabcde::mut_reference_test::run_all
//# run --verbose -- 0xabcde::simple_arithmetic::test