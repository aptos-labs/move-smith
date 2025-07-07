//# publish
module 0x99::increment_access_tests {
    /// Define a wrapper around a primitive u8 for testing wrapper functions
    struct MyWrapper has drop {
        value: u8,
    }

    /// Define a struct with a nested vector for testing
    struct NestedStruct has drop {
        nums: vector<u64>,
        data: MyWrapper,
    }

    /// Initialize various data types
    public fun init_data() {
        let primitive = 5u8;
        let mut primitive_ref = &mut primitive;
        increment_u8(&mut primitive_ref);
        assert!(primitive == 6, 42);

        let wrapped = MyWrapper { value: 10 };
        let mut wrapped_mut = wrapped;
        increment_wrapper_u8(&mut wrapped_mut);
        assert!(wrapped_mut.value == 11, 42);

        let struct_obj = NestedStruct { nums: vector[1, 2, 3], data: MyWrapper { value: 2 } };
        let mut struct_obj_mut = struct_obj;
        increment_struct(&mut struct_obj_mut);
        assert!(vector::length(&struct_obj_mut.nums) == 3, 42);
        assert!(vector::borrow(&struct_obj_mut.nums, 0) == 2, 42);
        assert!(vector::borrow(&struct_obj_mut.nums, 1) == 3, 42);
        assert!(vector::borrow(&struct_obj_mut.nums, 2) == 4, 42);
        assert!(struct_obj_mut.data.value == 3, 42);
    }

    /// Function to increment a primitive u8
    fun increment_u8(x: &mut u8) {
        *x += 1;
    }

    /// Function to increment a wrapper's inner u8
    fun increment_wrapper_u8(w: &mut MyWrapper) {
        w.value = w.value + 1;
    }

    /// Function to increment nested struct's vector and inner wrapper
    fun increment_struct(s: &mut NestedStruct) {
        // Increment each element in the vector
        let len = vector::length(&s.nums);
        let mut i = 0;
        while (i < len) {
            let val = vector::borrow(&s.nums, i);
            vector::borrow_mut(&mut s.nums, i).set(*val + 1);
            i = i + 1;
        }
        // Increment wrapper's inner value
        s.data.value = s.data.value + 1;
    }

    //# run --verbose -- 0x99::increment_access_tests::init_data
}