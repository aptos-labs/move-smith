
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
        container.data
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


//# run 0xCAFE::FeatureInteractionTests::nested_field_access
public fun nested_field_access_test() {
    // Instantiate object with nested fields
    let inner = InnerObject { value: 999, nested: NestedStruct { flag: true, amount: 888 } };
    let obj = Object { inner: inner };

    // Access nested fields using dot notation
    let value = obj.inner.value;
    let amount = obj.inner.nested.amount;
    let flag = obj.inner.nested.flag;
}


//# run 0xCAFE::FeatureInteractionTests::shadowing_test --args true

//# run 0xCAFE::FeatureInteractionTests::shadowing_test --args false


//# run 0xCAFE::FeatureInteractionTests::apply_closure --args 0xCAFE::FeatureInteractionTests::double_if_even --args 4u64

//# run 0xCAFE::FeatureInteractionTests::apply_closure --args 0xCAFE::FeatureInteractionTests::square_if_odd --args 5u64


//# run 0xCAFE::FeatureInteractionTests::unused_params_and_vars --args 0u8 --args 7u8


//# run 0xCAFE::FeatureInteractionTests::get_inner_value --args 0xCAFE::FeatureInteractionTests::Container { data: 123u64 }

// Create and drop a resource to test resource reference and drop behavior
public fun resource_flow_test() {
    let resource = create_resource();
    // explicit drop by leaving scope
}


//# run 0xCAFE::FeatureInteractionTests::fall_through_example --args true

//# run 0xCAFE::FeatureInteractionTests::fall_through_example --args false


// Featurres:
// 78f8dc464195108ec06049bb15ab9fa2: Access nested fields of expressions using dot notation in Move code.
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
// 7f343e5b6a46a90c5e940d2d1b876be9: Test that function currying with different closures correctly evaluates conditional logic and produces expected results.
// 6b06ced8de2f19493c290b196338380a: Detect and identify unused parameters and variables within a function.
// f90e0ba5fb3efe80aaf80c1931fdbb42: Test that projections and references correctly access and return fields within generic structs, and that the functions handle drop resources properly.
// 30200a459a0d35d57c9c2ed06e33f6bd: Allow implicit fall-through to labels when a preceding instruction is not a branching instruction in Move code.
