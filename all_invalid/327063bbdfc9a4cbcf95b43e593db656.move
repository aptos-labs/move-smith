
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
    const CONST_A: u8 = 42;
}



//# run 0xCAFE::ResourceTestModule::lambda_test


//# run 0xCAFE::ResourceTestModule::missing_resource_acquire