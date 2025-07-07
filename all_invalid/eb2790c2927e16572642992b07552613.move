// Filename: tests/transactional_test.move

module 0x1::TransactionalTest {
    use std::vector;
    use std::signer;
    use std::error;
    use std::option;

    /// Feature 1: Define named native functions with custom type parameters for generics.
    /// We'll define a native function `native_max` that returns the max of two generic values.
    /// For testing purposes, let's assume we have a native implemented externally:
    native fun native_max<T: copy + store + drop + partial_ord>(a: T, b: T): T;

    /// Feature 2: Define a struct containing a vector field:
    struct MyStruct has store {
        data: vector<u64>,
    }

    /// Feature 3: Define resource types in different modules and nested work functions to test resource permission management.
}

// Module A: defines a resource and a function to mutate it.
module 0x1::ModuleA {
    use std::vector;

    struct ResourceA has key {
        values: vector<u64>,
    }

    /// Initialize ResourceA under account
    public fun init(account: &signer) {
        let resource = ResourceA { values: vector::empty<u64>() };
        move_to(account, resource);
    }

    /// Append a value to resource
    public fun append(account: &signer, val: u64) acquires ResourceA {
        let r = borrow_global_mut<ResourceA>(signer::address_of(account));
        vector::push_back(&mut r.values, val);
    }
}

// Module B: defines a resource and nested mutation functions.
module 0x1::ModuleB {
    use std::vector;
    use std::signer;
    use 0x1::ModuleA;

    struct ResourceB has key {
        data: vector<u64>,
    }

    /// Initialize ResourceB under account
    public fun init(account: &signer) {
        let resource = ResourceB { data: vector::empty<u64>() };
        move_to(account, resource);
    }

    /// Append value to ResourceB's vector
    public fun append(account: &signer, val: u64) acquires ResourceB {
        let r = borrow_global_mut<ResourceB>(signer::address_of(account));
        vector::push_back(&mut r.data, val);
    }

    /// Nested work function that also calls ModuleA's append.
    public fun nested_work(account: &signer, val_a: u64, val_b: u64) acquires ResourceA, ResourceB {
        // Append to ModuleB resource
        append(account, val_b);
        // Append to ModuleA resource
        ModuleA::append(account, val_a);
    }
}

module 0x1::TransactionalTest {
    use std::signer;
    use std::vector;
    use std::assert;
    use std::string;
    use std::option;
    use 0x1::ModuleA;
    use 0x1::ModuleB;

    /// Wrapper to call native_max for u64 (fake implementation for test).
    public fun max_u64(a: u64, b: u64): u64 {
        // Since native_max is native, fallback to Move logic for test:
        if (a >= b) { a } else { b }
    }

    /// Feature 2: create and mutate a struct with vector field
    public fun create_and_mutate_struct(): MyStruct {
        let mut s = MyStruct { data: vector::empty<u64>() };
        vector::push_back(&mut s.data, 10);
        vector::push_back(&mut s.data, 20);
        vector::push_back(&mut s.data, 30);

        // Mutable borrow and update first element
        let data_ref = &mut s.data;
        assert!(vector::length(data_ref) > 0, 1);
        *vector::borrow_mut(data_ref, 0) = 999;

        s
    }

    #[test_only]
    public fun test_native_max() {
        let a = 5u64;
        let b = 10u64;
        let result = max_u64(a, b);
        assert!(result == 10, 1001);

        let c = 50u64;
        let d = 25u64;
        let result2 = max_u64(c, d);
        assert!(result2 == 50, 1002);
    }

    #[test_only]
    public fun test_create_and_mutate_struct() {
        let s = create_and_mutate_struct();
        let first = *vector::borrow(&s.data, 0);
        assert!(first == 999, 2001);

        let second = *vector::borrow(&s.data, 1);
        assert!(second == 20, 2002);

        let len = vector::length(&s.data);
        assert!(len == 3, 2003);
    }

    #[test_only]
    public fun test_nested_work_and_permissions(account: &signer) acquires ModuleA::ResourceA, ModuleB::ResourceB {
        // Initialize resources
        ModuleA::init(account);
        ModuleB::init(account);

        // Nested work call - appends values to both resources
        ModuleB::nested_work(account, 111u64, 222u64);

        // Mutate ModuleA resource again
        ModuleA::append(account, 333u64);

        // Validate ModuleA::ResourceA values
        let resource_a = borrow_global<ModuleA::ResourceA>(signer::address_of(account));
        let vals_a = &resource_a.values;
        assert!(vector::length(vals_a) == 2, 3001);
        assert!(*vector::borrow(vals_a, 0) == 111, 3002);
        assert!(*vector::borrow(vals_a, 1) == 333, 3003);

        // Validate ModuleB::ResourceB values
        let resource_b = borrow_global<ModuleB::ResourceB>(signer::address_of(account));
        let vals_b = &resource_b.data;
        assert!(vector::length(vals_b) == 1, 3004);
        assert!(*vector::borrow(vals_b, 0) == 222, 3005);
    }
}

// Featurres:
// 3ce7f9ec7dcf0f463d7ee246609ec231: Define named native functions with custom type parameters for generics.
// e6924546d1f2fbe9da61cc0a787bb1d2: Test creating and mutating a struct containing a vector field by updating its first element via a mutable borrow in Move.
// 77b76987aa9c6f635d7fcbed173fe43a: Test that nested work operations with different modules correctly manage resource permissions and do not cause unauthorized access or conflicting updates.
