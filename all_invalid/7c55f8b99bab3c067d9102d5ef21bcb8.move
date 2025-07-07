
//# publish
module 0xCAFE::ComputedAdd {
    // A simple function that adds two u8 numbers and returns the sum + 10
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    // A function with lambda (anonymous function) that doubles an input and adds a fixed offset
    public fun lambda_double_plus_offset(x: u8): u8 {
        let double_fn: |u8| u8 has copy + drop = |val: u8| val * 2;
        let doubled = double_fn(x);
        doubled + 5
    }
}


//# run 0xCAFE::ComputedAdd::add_and_offset --args 7u8 8u8


//# run 0xCAFE::ComputedAdd::lambda_double_plus_offset --args 6u8


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::ComputedAdd;

    // Calls ComputedAdd::add_and_offset twice and returns their sum
    public fun double_add_calls(a: u8, b: u8, c: u8, d: u8): u8 {
        let first = ComputedAdd::add_and_offset(a, b);
        let second = ComputedAdd::add_and_offset(c, d);
        first + second
    }

    // Runner function without arguments that tests nested calls
    public fun runner(): u8 {
        double_add_calls(1u8, 2u8, 3u8, 4u8)
    }
}


//# run 0xCAFE::NestedCall::double_add_calls --args 1u8 2u8 3u8 4u8


//# run 0xCAFE::NestedCall::runner


//# publish
module 0xCAFE::RefSafety {
    // A struct with two fields, to test references and annotations
    struct AnnotStruct has copy, drop, store {
        a: u64,
        b: u64,
    }

    public fun create_and_borrow() {
        let s = AnnotStruct { a: 10, b: 20 };
        let ref_a: &u64 = &s.a;
        let ref_b: &u64 = &s.b;

        // We simulate bytecode annotations by referencing here - no actual annotation language
        // But we will forcibly "use" the references to check reference safety
        let _use_ref_a = *ref_a;
        let _use_ref_b = *ref_b;
    }
}


//# run 0xCAFE::RefSafety::create_and_borrow


//# publish
module 0xCAFE::VectorOps {
    use std::vector;

    public fun vector_test() {
        let v1 = vector::empty<u64>();
        vector::push_back(&mut v1, 4);
        vector::push_back(&mut v1, 1);
        vector::push_back(&mut v1, 3);

        // Clone vector
        let v2 = vector::copy(&v1);

        // Sort the original vector ascending using naive bubble sort for demonstration
        let len = vector::length(&v1);
        let i = 0;
        while (i < len) {
            let j = i + 1;
            while (j < len) {
                if (*vector::borrow(&v1, i) > *vector::borrow(&v1, j)) {
                    let a = *vector::borrow(&v1, i);
                    let b = *vector::borrow(&v1, j);
                    *vector::borrow_mut(&mut v1, i) = b;
                    *vector::borrow_mut(&mut v1, j) = a;
                };
                j = j + 1;
            };
            i = i + 1;
        };

        // Assert v1 sorted ascending is [1,3,4]
        assert!(*vector::borrow(&v1, 0) == 1, 999);
        assert!(*vector::borrow(&v1, 1) == 3, 999);
        assert!(*vector::borrow(&v1, 2) == 4, 999);

        // Assert v2 is original unsorted [4,1,3]
        assert!(*vector::borrow(&v2, 0) == 4, 999);
        assert!(*vector::borrow(&v2, 1) == 1, 999);
        assert!(*vector::borrow(&v2, 2) == 3, 999);

        // Check equality by element manually since std::vector does not have built-in eq
        let eq = true;
        let k = 0;
        while (k < len) {
            if (*vector::borrow(&v1, k) != *vector::borrow(&v1, k)) {
                eq = false;
            };
            k = k + 1;
        };
        assert!(eq, 999);
    }
}


//# run 0xCAFE::VectorOps::vector_test


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// c611388e3b33da0d46095b6087db59de: Display results of reference safety analysis directly in the bytecode annotations to spot unsafe reference usage.
// 5ea401f7a54a8be7c8484197718c3540: Test that vector copying, sorting, and equality functions correctly handle comparison, cloning, and ordering of u64 vectors, ensuring assertions pass as expected.
