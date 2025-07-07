//# publish
module 0xDEADBEEF::TestModule {
    // Remove unused import, or if needed elsewhere, keep it.
    // use std::vector; // Commented out if not used
    use std::signer;
    // Removed the invalid use of 0xCAFE::MyModule; replaced with correct import or defined inline
    // Since '0xCAFE::MyModule' is unbound, you should define a dummy or correct module
    // For demonstration, we'll assume the functions are defined locally below or remove the reference

    // Define a dummy inline module with function f2 to simulate inline expansion
    // or you can import the real module if available
    public fun f2(x: u16): (u16, u16) {
        (x, x + 1)
    }

    struct ResourceA {
        id: u64,
        value: bool,
    }

    struct ResourceB {
        counter: u32,
    }

    public fun use_inline_in_function(x: u16): (u16, u16) {
        // Call inline function f2
        let (a, b) = f2(x);
        (a, b)
    }

    public fun combined_inline_call(x: u8): u8 {
        let (a, _b) = use_inline_in_function(x as u16);
        a as u8
    }

    public fun test_resource_operations(addr: address) {
        let signer = signer::borrow_signer(&addr);

        // Store ResourceA at address
        let res_a = ResourceA { id: 1, value: true };
        move_to<ResourceA>(&signer, res_a);

        // Borrow ResourceA and validate fields
        let res_a_ref: &ResourceA = borrow_global<ResourceA>(&addr);
        assert!(res_a_ref.value, 42); // Note: The second parameter is the message; 'assert!' syntax may vary

        // Update ResourceA
        let res_a_mut: &mut ResourceA = borrow_global_mut<ResourceA>(&addr);
        res_a_mut.value = false;

        // Remove ResourceA
        let _removed_res_a = move_from<ResourceA>(&addr);
        // Attempting to borrow afterward would abort if the resource is gone
        // let _ = borrow_global<ResourceA>(&addr);

        // Store ResourceB
        let res_b = ResourceB { counter: 10 };
        move_to<ResourceB>(&signer, res_b);

        // Borrow ResourceB and validate
        let res_b_ref: &ResourceB = borrow_global<ResourceB>(&addr);
        assert!(res_b_ref.counter == 10, 123);

        // Call inline functions inside this function and verify results
        let result_value = combined_inline_call(5);
        assert!(result_value == 5u8, 456);
    }

    public fun run_tests() {
        let test_addr = @0xDEADBEEF;
        test_resource_operations(test_addr);
    }
}


//# run 0xDEADBEEF::TestModule::run_tests
