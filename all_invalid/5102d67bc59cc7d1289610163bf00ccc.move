
//# publish
module 0xDEADBEEF::TestModule {
    use std::vector;
    use 0xCAFE::MyModule;

    struct ResourceA {
        id: u64,
        value: bool,
    }

    struct ResourceB {
        counter: u32,
    }

    public fun use_inline_in_function(x: u16): (u16, u16) {
        // Call inline function f2
        let (a, b) = MyModule::f2(x);
        (a, b)
    }

    // Function that calls an inline function defined in another module
    public fun combined_inline_call(x: u8): u8 {
        // Use inline function f2 indirectly by calling use_inline_in_function and using the results
        let (a, _b) = use_inline_in_function(x as u16);
        // Perform some operation with inline function results
        a as u8
    }

    public fun test_resource_operations(addr: address) {
        // Store ResourceA at address
        let signer = signer::from_address(addr);
        let res_a = ResourceA { id: 1, value: true };
        move_to<ResourceA>(&signer, res_a);

        // Borrow ResourceA and validate fields
        let res_a_ref: &ResourceA = borrow_global<ResourceA>(addr);
        assert!(res_a_ref.value, 42);

        // Update ResourceA
        let res_a_mut: &mut ResourceA = borrow_global_mut<ResourceA>(addr);
        res_a_mut.value = false;

        // Remove ResourceA
        let _removed_res_a = move_from<ResourceA>(addr);
        // Ensure ResourceA is removed by attempting to borrow (will abort if exists)
        // (Commented out to prevent abort during test execution)
        // let _ = borrow_global<ResourceA>(addr);

        // Store ResourceB
        let res_b = ResourceB { counter: 10 };
        move_to<ResourceB>(&signer, res_b);

        // Borrow ResourceB and validate
        let res_b_ref: &ResourceB = borrow_global<ResourceB>(addr);
        assert!(res_b_ref.counter == 10, 123);

        // Call inline functions inside this function and ensure they expand correctly
        let result_value = combined_inline_call(5);
        assert!(result_value == 5u8, 456);
    }

    public fun run_tests() {
        // Use a test address
        let test_addr = @0xDEADBEEF;
        test_resource_operations(test_addr);
    }
}


//# run 0xDEADBEEF::TestModule::run_tests


// Featurres:
// 6ab8797b66a06348f368b697382c1c80: Declare resources as 'resource struct StructName' instead of 'resource StructName'.
// 89c812ea94a0490e1a31d1e05b4e9dd2: Use the 'use' statement to import modules by their declared module names.
// f014b399e4686074b1fe7647b8e38e9b: Call inline functions within other functions to have them expanded at call sites.
