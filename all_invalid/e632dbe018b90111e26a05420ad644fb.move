// Corrected transactional test code

//# publish
module 0xCAFE::FeatureInteractionTests {
    use std::signer;
    use std::vector;

    // Struct for testing nested field access
    struct Object has store {
        inner: InnerObject,
    }

    struct InnerObject has store {
        value: u64,
        nested: NestedStruct,
    }

    struct NestedStruct has store {
        flag: bool,
        amount: u128,
    }

    // Generic struct for projection tests
    struct Container<T> has store {
        data: T,
    }

    // Internal function to verify invariants
    fun internal_verify(condition: bool) {
        assert!(condition, 999);
    }

    // Function with only internal visibility to test restriction
    fun internal_only_function() {
        // NOP
    }

    // Function to test variable shadowing 
    public fun shadowing_test(flag: bool): u64 {
        let value = 42u64;
        if (flag) {
            let value = 100u64; // shadow
            value
        } else {
            value
        }
    }

    // Function that uses a closure with conditional logic
    public fun apply_closure(f: |u64|->u64, val: u64): u64 {
        f(val)
    }

    // Closure examples
    public fun double_if_even(x: u64): u64 {
        if (x % 2 == 0) {
            x * 2
        } else {
            x
        }
    }

    public fun square_if_odd(x: u64): u64 {
        if (x % 2 == 1) {
            x * x
        } else {
            x
        }
    }

    // Function testing use of unused parameters and variables
    public fun unused_params_and_vars(_unused_param: u8, used_var: u8): u8 {
        let temp = used_var + 1;
        temp
    }

    // Function testing projection on generic structs
    public fun get_inner_value<T>(container: &Container<T>): &T {
        &container.data
    }

    // Function testing resource drop and reference
    struct Resource {
        field: u8,
    }

    public fun create_resource(): Resource {
        let r = Resource { field: 55u8 };
        r
    }

    // Function testing implicit fall-through (flow control without explicit branch)
    public fun fall_through_example(flag: bool): u64 {
        let x = 0u64;
        if (flag) {
            x = 10;
        } else {
            x = 20;
        }
        // fall through to return
        x
    }
}

// Run nested_field_access_test
public fun nested_field_access_test() {
    let inner = InnerObject { value: 999, nested: NestedStruct { flag: true, amount: 888 } };
    let obj = Object { inner: inner };

    // Access nested fields using dot notation
    let value = obj.inner.value;
    let amount = obj.inner.nested.amount;
    let flag = obj.inner.nested.flag;
}

// Run shadowing_test with true argument
// --args true
// expects shadowing_test(true) = 100
public fun run_shadowing_test_true() {
    let result = FeatureInteractionTests::shadowing_test(true);
    // optional: assert result == 100
}

// Run shadowing_test with false argument
// --args false
// expects shadowing_test(false) = 42
public fun run_shadowing_test_false() {
    let result = FeatureInteractionTests::shadowing_test(false);
    // optional: assert result == 42
}

// Run apply_closure with double_if_even and argument 4u64
// --args 0xCAFE::FeatureInteractionTests::double_if_even --args 4u64
public fun run_apply_closure_double_even() {
    let result = FeatureInteractionTests::apply_closure(
        FeatureInteractionTests::double_if_even,
        4u64
    );
    // optional: check result == 8
}

// Run apply_closure with square_if_odd and argument 5u64
// --args 0xCAFE::FeatureInteractionTests::square_if_odd --args 5u64
public fun run_apply_closure_square_odd() {
    let result = FeatureInteractionTests::apply_closure(
        FeatureInteractionTests::square_if_odd,
        5u64
    );
    // optional: check result == 25
}

// Run unused_params_and_vars with arguments 0u8 and 7u8
// --args 0u8 --args 7u8
public fun run_unused_params_and_vars_sample() {
    let result = FeatureInteractionTests::unused_params_and_vars(0u8, 7u8);
    // optional: assert result == 8
}

// Run get_inner_value with a Container holding 123u64
// --args 0xCAFE::FeatureInteractionTests::Container { data: 123u64 }
public fun run_get_inner_value() {
    let container = Container { data: 123u64 };
    let value_ref = FeatureInteractionTests::get_inner_value(&container);
    // optional: compare *value_ref == 123u64
}

// Create and drop a resource to test resource reference and drop behavior
public fun resource_flow_test() {
    let resource = FeatureInteractionTests::create_resource();
    // resource will be dropped at end of scope
}

// Run fall_through_example with true
// --args true
public fun run_fall_through_true() {
    let result = FeatureInteractionTests::fall_through_example(true);
    // optional: result == 10
}

// Run fall_through_example with false
// --args false
public fun run_fall_through_false() {
    let result = FeatureInteractionTests::fall_through_example(false);
    // optional: result == 20
}
