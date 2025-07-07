//# publish
module 0xabcde::local_mod {
    // Function that modifies a local variable and returns it without copying
    fun modify_and_return(p: u64): u64 {
        let mut local_var = p;      // move p into local_var
        local_var = local_var + 10; // modify the local variable
        local_var                   // return the local variable
    }

    public fun test() {
        // Test that the modification works correctly
        assert!(modify_and_return(5) == 15, 0);
        assert!(modify_and_return(0) == 10, 1);
    }

    // Helper function to create a closure that sums three parameters
    public fun create_sum_closure(): &fun(x: u64): &fun(y: u64): &fun(z: u64): u64 {
        // Returns a nested closure that sums the three inputs
        |x| |y| |z| x + y + z
    }

    public fun test_closure() {
        let sum_fn = create_sum_closure();
        assert!(sum_fn(1)(2)(3) == 6, 0);
        assert!(sum_fn(5)(5)(5) == 15, 1);
    }

    // Functions to test various increment behaviors across types and containers
    struct DataStruct has copy, drop {
        val: u64,
        other: vector<u8>,
    }

    fun increment_struct_field(s: &mut DataStruct) {
        s.val = s.val + 1;
    }

    fun get_data_struct(p: &DataStruct): u64 {
        p.val
    }

    fun test_struct_operations() {
        let mut s = DataStruct { val: 42, other: vector[u8](100) };
        increment_struct_field(&mut s);
        assert!(get_data_struct(&s) == 43, 0);
    }

    // Test with wrapped types
    struct WrapperField has drop {
        inner: u64,
    }

    fun increment_wrapper(w: &mut WrapperField) {
        w.inner += 1;
    }

    fun get_wrapper_value(w: &WrapperField): u64 {
        w.inner
    }

    fun test_wrapped() {
        let mut w = WrapperField { inner: 10 };
        increment_wrapper(&mut w);
        assert!(get_wrapper_value(&w) == 11, 0);
    }

    // Test vector manipulations
    fun increment_vector_element(vec: &mut vector<u8>, index: u64) {
        vec[index] = vec[index] + 1;
    }

    fun test_vector() {
        let mut vec = vector[u8](10);
        vec.push_back(5);
        increment_vector_element(&mut vec, 0);
        increment_vector_element(&mut vec, 1);
        assert!(vec[0] == 6 && vec[1] == 6, 0);
    }

    // Test vector of structs
    fun increment_struct_in_vector(vec: &mut vector<DataStruct>, index: u64) {
        let s = &mut vec[index];
        increment_struct_field(s);
    }

    fun test_vector_structs() {
        let mut vec = vector[DataStruct][
            DataStruct { val: 5, other: vector[u8](0) },
            DataStruct { val: 10, other: vector[u8](0) }
        ];
        increment_struct_in_vector(&mut vec, 0);
        increment_struct_in_vector(&mut vec, 1);
        assert!(vec[0].val == 6 && vec[1].val == 11, 0);
    }
}
//# run 0xabcde::local_mod::test
