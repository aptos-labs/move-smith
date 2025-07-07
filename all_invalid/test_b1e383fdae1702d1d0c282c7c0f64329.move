//# publish
module 0xabc::test_module {
    // Module to test that the initial value remains unchanged after passing it to an update function
    fun modify_value(p: &mut u64) {
        *p = 42;
    }

    fun check_value(original: u64): u64 {
        let local_copy = original;
        modify_value(&mut local_copy);
        // Return the local copy to verify it remains unchanged
        local_copy
    }

    // Public function to run the test
    public fun run_test() {
        assert!(check_value(10) == 10, 0);
        assert!(check_value(0) == 0, 0);
        assert!(check_value(999) == 999, 0);
    }
}

//# run 0xabc::test_module::run_test


//# publish
module 0xabc::eq_struct {
    // Struct with a u64 field to test equality
    struct MyStruct has drop, copy {
        f: u64
    }

    // Generic equality function for structs with a u64 field
    fun eq_struct(x: &MyStruct, y: &MyStruct): bool {
        x.f == y.f
    }

    // Function to test equality of u64
    public fun test_u64(val: u64): bool {
        eq_struct(&MyStruct {f: 5}, &MyStruct {f: val})
    }

    // Function to test equality of custom struct
    public fun test_struct(val: u64): bool {
        eq_struct(&MyStruct {f: 5}, &MyStruct {f: val})
    }
}

//# run 0xabc::eq_struct::test_u64 --args 5
//# run 0xabc::eq_struct::test_struct --args 5


//# publish
module 0xabc::vector_operations {
    use std::vector;

    // Function to create a vector with specific values
    fun create_vector(): vector<u64> {
        vector[10, 20, 30, 40]
    }

    // Function to remove an element at a specific index and verify vector integrity
    public fun remove_at_index(v: &mut vector<u64>, index: u64): u64 {
        vector::remove(v, index)
    }

    // Function to test folding over a vector
    public fun sum_vector(v: &vector<u64>): u64 {
        vector::fold(v, 0, |acc, x| *acc + *x)
    }

    // Implementation of remove for vector
    public fun remove(v: &mut vector<u64>, i: u64): u64 {
        let len = vector::length(v);
        if (i >= len) abort 1;

        let removed = vector::swap_remove(v, i);
        removed
    }

    // Runner function to test remove and fold
    public fun run_tests() {
        let v = create_vector();
        let removed = remove_at_index(&mut v, 2);
        // After removal, vector should be [10, 20, 40]
        let sum = sum_vector(&v);
        assert!(removed == 30, 0);
        assert!(vector::length(&v) == 3, 0);
        // The sum should be 10 + 20 + 40 = 70
        assert!(sum == 70, 0);
    }
}

//# run 0xabc::vector_operations::run_tests