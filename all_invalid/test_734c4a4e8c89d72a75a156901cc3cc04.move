//# publish
module 0xA1B2::logic_ops {
    public fun check_negation_not() {
        assert!(!false == true, 200);
        assert!(!true == false, 201);
        assert!(!(!true) == true, 202);
    }

    public fun check_and_or() {
        assert!((true && true) == true, 203);
        assert!((true && false) == false, 204);
        assert!((false && false) == false, 205);
        assert!((true || false) == true, 206);
        assert!((false || false) == false, 207);
        assert!((false || true) == true, 208);
    }
}

//# run 0xA1B2::logic_ops::check_negation_not
//# run 0xA1B2::logic_ops::check_and_or

//# publish
module 0x3C4D::mutability_tests {
    public fun test_nested_blocks() {
        let result = {
            let mut a = 2;
            {
                a = a + 3; // a = 5
            }
            let mut b = a;
            {
                b = b * 2; // b = 10
            }
            a + b // 5 + 10 = 15
        };
        assert!(result == 15, 300);
    }

    public fun test_variable_effect() {
        let mut x = 10;
        {
            x = x + 5; // 15
            let y = x;
            x = y - 3; // 12
        }
        assert!(x == 12, 301);
    }
}

//# run 0x3C4D::mutability_tests::test_nested_blocks
//# run 0x3C4D::mutability_tests::test_variable_effect

//# publish
module 0x5E6F::vector_operations {
    public fun custom_remove<v>(v: &mut vector<v>, index: u64): v {
        use std::vector;
        let len = vector::length(v);
        if (index >= len) abort 1;
        while (index < len - 1) {
            vector::swap(v, index, index + 1);
            index = index + 1;
        }
        vector::pop_back(v)
    }

    public fun test_fold_sum() {
        use std::vector;
        let v = vector[10, 20, 30, 40];
        let sum = vector::fold(&v, 0, |acc, val| acc + val);
        assert!(sum == 100, 302);
    }

    public fun test_remove_element() {
        use std::vector;
        let v = vector[5, 10, 15];
        let removed = custom_remove(&mut v, 1);
        assert!(removed == 10, 303);
        assert!(vector::length(&v) == 2, 304);
        assert!(*vector::borrow(&v, 0) == 5, 305);
        assert!(*vector::borrow(&v, 1) == 15, 306);
    }
}

//# run 0x5E6F::vector_operations::test_fold_sum
//# run 0x5E6F::vector_operations::test_remove_element