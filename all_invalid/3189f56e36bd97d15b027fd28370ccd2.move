//# publish
module 0xCAFE::AdvancedFeatures {
    use std::vector;

    // A struct just for key and store testing
    struct KeyedStruct has store, key {
        id: u64,
        data: u8,
    }

    // Function type parameter example (language version >= 2.2)
    public fun apply_to_value(f: |u8|u8, x: u8): u8 {
        f(x)
    }

    // A non-inline function that uses a function type param to double a value
    public fun double(x: u8): u8 {
        x * 2
    }

    // Mutably iterate over a vector and update all elements to val
    public fun update_all_to(v: &mut vector<u8>, val: u8) {
        let mut i = 0;
        let len = vector::length(v);
        while (i < len) {
            let elem_ref: &mut u8 = vector::borrow_mut(v, i);
            *elem_ref = val;
            i = i + 1;
        };
    }

    // A runner function to test update_all_to
    public fun test_update_all() {
        let mut v = vector::empty<u8>();
        vector::push_back(&mut v, 1u8);
        vector::push_back(&mut v, 2u8);
        vector::push_back(&mut v, 3u8);
        update_all_to(&mut v, 9u8);

        // Iterate to assert manually
        let mut i = 0;
        let len = vector::length(&v);
        while (i < len) {
            let val_ref = vector::borrow(&v, i);
            assert!(*val_ref == 9u8, 1000 + i);
            i = i + 1;
        };
    }

    // Unit test style functions with the 'test' attribute
    #[test]
    public fun test_apply_to_value() {
        let result = apply_to_value(double, 5u8);
        assert!(result == 10u8, 1001);
    }

    #[test]
    public fun test_update_all_to_vector() {
        let mut v = vector::empty<u8>();
        vector::push_back(&mut v, 4u8);
        vector::push_back(&mut v, 5u8);
        update_all_to(&mut v, 8u8);
        let mut i = 0;
        let len = vector::length(&v);
        while (i < len) {
            let val_ref = vector::borrow(&v, i);
            assert!(*val_ref == 8u8, 1002 + i);
            i = i + 1;
        };
    }
}

//# run 0xCAFE::AdvancedFeatures::test_apply_to_value

//# run 0xCAFE::AdvancedFeatures::test_update_all_to_vector

//# run 0xCAFE::AdvancedFeatures::test_update_all

// Featurres:
// 7adce3d4b2624780062b8f23dc554916: Use unit testing features via functions filtered by 'filter_test_members'.
// c9eb5099b0242b7001323e1cb5fc6aa7: Create or use function parameters with function-typed values in non-inline functions if the language version is at least 2.2.
// 00117828bd5bbf4ac93e513072037541: Test that mutably iterating over a vector using a while loop updates each element to a specified value.
