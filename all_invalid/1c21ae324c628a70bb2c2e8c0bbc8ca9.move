// Corrected Transactional Test for Aptos Move

// The test code should be a script or a module with a main function
// Remove invalid 'use' statements outside functions; Move script code inside a fun main()

// Properly structure the test as a script

//# publish
module 0xTEST::NestedStructsTest {
    use 0xBADD::NestedStructs;
    use 0xDEAD::DeprecationTest;
    use 0xC0FF::AccessControl;

    public entry fun main() {
        // Create nested structs and test access
        let inner = NestedStructs::InnerStruct { nested_field: 42, more_data: true };
        let outer = NestedStructs::create_outer_struct(inner, 100);

        let value_before = NestedStructs::get_inner_nested_field(&outer);
        // Expect value_before == 42
        // Print or assert (Move doesn't have print, but for testing, assume assertions)
        // Here, just assign variables, or use debug assertion if available
        assert!(value_before == 42, 0);

        // Update nested field
        NestedStructs::set_inner_nested_field(&mut outer, 99);
        let value_after = NestedStructs::get_inner_nested_field(&outer);
        // Expect value_after == 99
        assert!(value_after == 99, 1);

        // Call active function - should succeed
        DeprecationTest::active_func();

        // Call deprecated function - in real scenario, triggers warning/error if deprecation enforced
        DeprecationTest::deprecated_func();

        // Attempt to call internal function from outside its module - should fail
        // The following line should be commented or ignored; uncommenting causes compile error
        // let _ = AccessControl::internal_only_func(); // Error: function is private

        // Call internal function via public wrapper - should succeed
        AccessControl::call_internal();
    }
}
