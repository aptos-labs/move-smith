
//# publish
module 0xCAFE::ResourceTestModule {
    use std::errors;

    // A dummy resource to test resource passing and errors
    struct MyResource has key, store {
        value: u64,
    }

    // Function that uses another function expecting resource acquisition
    public fun use_resource(resource: &mut MyResource) {
        resource.value = resource.value + 1;
    }

    // Function with lambda that captures a local variable
    public fun lambda_test(val: u64): u64 {
        let closure = |x: u64| {
            x + val
        };
        closure(10)
    }

    // Function referencing another module's constant
    public fun get_constant(): u8 {
        0u8 + ModuleConstants::CONST_A
    }

    // Function to intentionally cause an error due to missing resource acquisition
    public fun missing_resource_acquire() {
        // no resource acquisition, but using resource-using function
        let dummy_resource = move_from <MyResource> (0xDEADBEEF);
        use_resource(&mut dummy_resource); // should trigger error: resource not acquired
        move_to <MyResource> (0xDEADBEEF, dummy_resource);
    }
}

module 0xCAFE::ModuleConstants {
    // A simple constant to reference
    public const CONST_A: u8 = 42;
}


//# run 0xCAFE::ResourceTestModule::lambda_test

//# run 0xCAFE::ResourceTestModule::missing_resource_acquire

// Featurres:
// 18125c6482a527be8d6ba0b3a44898e0: Receive error messages if a function does not declare acquisition of resources that are used or implied within its body.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// ad257905f7e63f07f1569c4d5ed41a54: Reference types, functions, or constants from another module using the syntax 'Module::Member'.
