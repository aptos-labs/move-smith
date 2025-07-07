//# publish
module 0xA11C::ArithmeticCapture {
    /// Creates a function that captures a value and performs subtraction
    fun create_subtractor(capture: u64): |u64|(|u64|u64) has copy {
        |x| capture - x
    }

    /// Creates a function that captures a value and performs division
    fun create_divider(divisor: u64): |u64|(|u64|u64) has copy {
        |x| {
            assert!(x != 0, 0);
            divisor / x
        }
    }

    /// Test nested function values with variable capture involving subtraction and division
    fun test_nested_function_arithmetic() {
        let subtract_5 = create_subtractor(5);
        let sub_result = subtract_5(3);
        // 5 - 3 = 2
        assert!(sub_result == 2, 0);

        let divide_by_2 = create_divider(4);
        let div_result = divide_by_2(2);
        // 4 / 2 = 2
        assert!(div_result == 2, 1);

        // Nested captures with multiple variables
        let base = 20;
        let offset = 4;
        let quotient = 2;
        let inner = |x: u64| |y: u64| (base - offset) / quotient + x + y;
        let inner_func = inner(1);
        // (20 - 4)/2 + 1 + 2 = 8 + 1 + 2 = 11
        assert!(inner_func(2) == 11, 2);
    }

    /// Test function composition with captures involving subtraction and division
    fun test_composed_arithmetic() {
        let cap_sub = 10;
        let cap_div = 100;

        let subtractor = |x: u64| |y: u64| cap_sub - x - y;
        let divider = |x: u64| |y: u64| cap_div / (x + y);

        let compose = |x| |y| subtractor(x)(y) + divider(x)(y);
        let result = compose(3)(4);
        // subtractor(3)(4) = 10 - 3 - 4 = 3
        // divider(3)(4) = 100 / (3 + 4) = 100/7 ≈ 14 (integer division)
        // total = 3 + 14 = 17
        assert!(result == 17, 3);
    }
}

//# run 0xA11C::ArithmeticCapture::test_nested_function_arithmetic

//# run 0xA11C::ArithmeticCapture::test_composed_arithmetic


//# publish
module 0xD34D::RegistryTest {
    // Define a generic registry struct
    struct Registry<F: store+copy> has key, store {
        func: F
    }

    public fun store_item<F: store+copy>(owner: &signer, item: F) {
        move_to<Registry<F>>(owner, Registry { func: item });
    }

    public fun remove_item<F: store+copy>(addr: address): F acquires Registry {
        let Registry{func} = move_from<Registry<F>>(addr);
        func
    }

    public fun item_present<F: store+copy>(addr: address): bool {
        exists<Registry<F>>(addr)
    }

    public fun get_item<F: store+copy>(addr: address): F acquires Registry {
        borrow_global<Registry<F>>(addr).func
    }
}

//# publish
module 0xD34D::StructsModule {
    use std::signer;

    struct DataStruct1 has key, store, copy {
        a: u64
    }

    struct DataStruct2 has key, store, copy {
        b: u8
    }

    public fun test_struct_storage(owner: &signer, store_struct1: bool): bool {
        let addr = signer::address_of(owner);
        let struct1_value = DataStruct1 { a: 42 };
        let struct2_value = DataStruct2 { b: 7 };

        // Store DataStruct1 if not already exists
        if (!exists<DataStruct1>(addr)) {
            0xD34D::RegistryTest::store_item(owner, struct1_value);
            move_to<DataStruct1>(owner, struct1_value);
        }

        // Save registry function depending on flag
        if (store_struct1) {
            0xD34D::RegistryTest::store_item(owner, struct1_value);
        } else {
            0xD34D::RegistryTest::store_item(owner, struct2_value);
        }

        // Check existence
        assert!(0xD34D::RegistryTest::item_present<DataStruct1>(addr) == store_struct1, 0);

        // Retrieve stored item
        let stored = 0xD34D::RegistryTest::get_item<DataStruct1>(addr);
        // Verify stored value if DataStruct1 stored
        if (store_struct1) {
            assert!(stored.a == 42, 1);
        }

        // Remove stored item
        0xD34D::RegistryTest::remove_item<DataStruct1>(addr);

        // Final check: after removal, item shouldn't exist
        assert!(!0xD34D::RegistryTest::item_present<DataStruct1>(addr), 2);

        true
    }
}

//# run 0xD34D::StructsModule::test_struct_storage --signers 0xD34D --args true
//# run 0xD34D::StructsModule::test_struct_storage --signers 0xD34D --args false


//# publish
module 0xBEEF::NestedInline {
    public inline fun inline_func(x: u64): u64 {
        x * 10
    }
}

//# publish
module 0xBEEF::MainInvoker {
    use 0xBEEF::NestedInline;

    public fun run_nested(): u64 {
        NestedInline::inline_func(7)
    }

    public fun main(): u64 {
        run_nested()
    }
}

//# run 0xBEEF::MainInvoker::main
