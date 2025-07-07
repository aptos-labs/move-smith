//# publish
module 0xabcde::test_module {
    // Test combined features: sequential function, function pointer usage, mutable references, and complex invocation.

    // Sequential function to test chain of variable assignments
    fun sequential_sum(a: u64, b: u64, c: u64): u64 {
        let x = a;
        let y = x + b;
        let z = y + c;
        z
    }

    // Function pointer type: a struct holding a function that takes u64 and returns u64
    struct FuncHolder {
        func: || u64
    } has copy, drop;

    // Enum holding different function pointers and additional data
    enum FuncEnum {
        V1 { f: |u64| u64 },
        V2 { f: |u64| u64, delta: u64 },
    } has copy, drop;

    // Struct containing a function pointer as a field
    struct WrapperFunction(||u64) has copy, drop;

    // Main test 1: call sequential sum and verify result
    public fun test_sequential_sum() {
        let result = sequential_sum(10, 20, 30);
        assert!(result == 60, 0);
    }

    // Main test 2: create and invoke function pointers stored in structs and enums
    public fun test_function_pointers() {
        let fh = FuncHolder { func: || 100 };
        let v1 = FuncEnum::V1 { f: |x| x + 1 };
        let v2 = FuncEnum::V2 { f: |x| x + 2, delta: 5 };
        let wrap_f = WrapperFunction(|| 77);

        // Call function pointer inside FuncHolder
        let val1 = (fh.func)();

        // Call enum function pointer V1
        let val2 = match v1 {
            FuncEnum::V1 { f } => (f)(42),
            _ => 0,
        };

        // Call enum function pointer V2
        let val3 = match v2 {
            FuncEnum::V2 { f, delta } => (f)(42) + delta,
            _ => 0,
        };

        // Call wrapper function
        let val4 = (wrap_f.0)();

        assert!(val1 == 100, 1);
        assert!(val2 == 43, 2);
        assert!(val3 == 44, 3);
        assert!(val4 == 77, 4);
    }

    // Main test 3: mutable reference operations across different data
    public fun test_mut_refs() {
        // Borrow and modify a local u64
        let mut x = 0u64;
        let x_ref = &mut x;
        *x_ref = 42;
        assert!(*x_ref == 42, 5);

        // Borrow mutable references to elements of a vector and update
        let mut vec = vector[1u64, 2, 3];
        let ref0 = vector::borrow_mut(&mut vec, 0);
        let ref1 = vector::borrow_mut(&mut vec, 1);
        *ref0 = 10;
        *ref1 = 20;

        assert!(*vector::borrow_mut(&mut vec, 0) == 10, 6);
        assert!(*vector::borrow_mut(&mut vec, 1) == 20, 7);
    }

    // Runner functions to invoke above tests
    public fun run_all_tests() {
        test_sequential_sum();
        test_function_pointers();
        test_mut_refs();
    }
}

//# run 0xabcde::test_module::run_all_tests