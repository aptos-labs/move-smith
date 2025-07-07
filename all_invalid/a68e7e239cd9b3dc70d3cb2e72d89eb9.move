
//# publish
module 0xCAFE::TestNestedAndFunctionalFeatures {
    use std::signer;
    use std::vector;

    // Structs with nested fields to test dot notation access and modification
    struct Outer has store, key {
        inner: Inner,
        count: u8,
    }

    struct Inner has store, key {
        value: u64,
        nested: DeepNested,
    }

    struct DeepNested has store, key {
        flag: bool,
        data: vector<u8>,
    }

    // Module with specifications to test pre- and post-conditions and purity
    
//# publish
    module 0xCAFE::SpecsModule {
        use std::asserts;

        // Function with pre- and post-conditions
        public fun increment_if_positive(x: u64): u64
            ensures result: result >= x {
            // Precondition: x must be less than 1000
            asserts::assert(x < 1000, 9999);
            let result = if (x > 0) { x + 1 } else { x };
            // Postcondition: result should be >= x
            asserts::assert(result >= x, 8888);
            result
        }
    }

    // Function with inline functions and first-class function variables
    public fun main_test(s: signer) {
        // 1. Access nested fields via dot notation and modify
        let outer_obj = Outer {
            inner: Inner {
                value: 42,
                nested: DeepNested {
                    flag: false,
                    data: vector::empty(),
                },
            },
            count: 5,
        };

        // Read nested fields
        let inner_ref: &Inner = &outer_obj.inner;
        let deep_ref: &DeepNested = &inner_ref.nested;

        // Verify initial nested values
        assert!(*inner_ref.value == 42, 1234);
        assert!(*deep_ref.flag == false, 5678);
        assert!(*vector::length(&deep_ref.data) == 0, 91011);

        // Modify nested fields
        let outer_mut = outer_obj;
        let inner_mut = &mut outer_mut.inner;
        let deep_mut = &mut inner_mut.nested;

        inner_mut.value = 100;
        deep_mut.flag = true;
        vector::push_back(&mut deep_mut.data, 255);
        vector::push_back(&mut deep_mut.data, 128);

        // Verify modifications
        assert!(*inner_mut.value == 100, 2222);
        assert!(*deep_mut.flag == true, 3333);
        assert!(*vector::length(&deep_mut.data) == 2, 4444);
        assert!(*vector::borrow(&deep_mut.data, 0) == 255, 5555);
        assert!(*vector::borrow(&deep_mut.data, 1) == 128, 6666);

        // 2. Assign functions (non-generic and generic) to variables and pass as arguments
        fun double_u8(a: u8): u8 {
            a * 2
        }

        // Assign non-generic function
        let func_var: |u8|u8 = double_u8;

        // Call via function variable
        let res1 = func_var(10);
        assert!(res1 == 20, 7777);

        // Assign generic function
        fun generic_identity<T>(x: T): T {
            x
        }

        let id_func: |T|T = generic_identity;

        // Call with type specialization
        let id_res: u16 = id_func::<u16>(1234);
        assert!(id_res == 1234, 8888);

        // Pass functions as arguments to another function
        fun apply_func<A, B>(f: |A|B, arg: A): B {
            f(arg)
        }

        let applied_res = apply_func::<u8, u8>(double_u8, 15);
        assert!(applied_res == 30, 9999);

        // 3. Use specifications (pre- and post-conditions)
        let val = 5u64;
        let _ = 0xCAFE::SpecsModule::increment_if_positive(val);
        // The above should succeed because val < 1000

        // Edge case: value equals zero
        let zero_val = 0u64;
        let res_zero = 0xCAFE::SpecsModule::increment_if_positive(zero_val);
        assert!(*res_zero == 0, 11111);

        // 4. Inline functions scope and invocation
        fun outer_inner(x: u64): u64 {
            let helper = |y: u64| {
                // Access outer variable x
                x + y
            };
            helper(10)
        }

        let inline_res = outer_inner(20);
        assert!(inline_res == 30, 22222);

        // 5. Combine nested field access and inline function with function parameters
        fun process_nested(acc: u64, f: |u64|u64): u64 {
            let nested_value = outer_obj.inner.value;
            let processed = f(nested_value);
            acc + processed
        }

        let sum_result = process_nested(5, |v| v + 1);
        assert!(sum_result == 106, 33333);

        // Also, invoke an inline function that accesses nested fields
        let nested_accessor = |obj: &Outer| {
            let val = &obj.inner.value;
            *val
        };

        let nested_value_from_obj = nested_accessor(&outer_obj);
        assert!(nested_value_from_obj == 100, 44444);
    }
}



//# run 0xCAFE::TestNestedAndFunctionalFeatures::main_test --signers 0xFEDC
