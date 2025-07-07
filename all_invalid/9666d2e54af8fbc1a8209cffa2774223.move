
    use 0xBADD::NestedStructs;
    use 0xC0DE::DeprecationModule;
    use 0xFAKE::FunctionPointerTest;

    fun main() {
        // Test nested struct creation and validation
        let outer_struct = NestedStructs::create_nested_structs();
        assert(NestedStructs::validate_nested_fields(&outer_struct), 0);

        // Test function pointer to plain function
        let f_ptr = FunctionPointerTest::get_fn_pointer();
        let result = FunctionPointerTest::apply_function(f_ptr, 15);
        assert(result == 25, 0);

        // Test generic function (simulate by calling with u8)
        let gen_result = FunctionPointerTest::f_generic<u8>(30);
        assert(gen_result == 30, 0);

        // Test closure as function pointer
        let closure_fn: fun(x: u8): u8 = FunctionPointerTest::closure_add;
        let closure_result = FunctionPointerTest::use_closure();
        assert(closure_result == (50 + 5), 0);

        // Test passing function from deprecated module
        let info_vec = FunctionPointerTest::call_deprecated_module_func();
        assert(Vector::length(&info_vec) == 0, 0);

        // Test nested attribute usage with function pointer
        let dummy_data = DeprecationModule::nested_sub::Data { info: Vector::empty<u8>() };
        let len = FunctionPointerTest::process_with_deprecated_func();
        assert(len == 0, 0);

        // Test calling function that returns a function pointer
        let fp = FunctionPointerTest::get_fn_pointer();
        let res = FunctionPointerTest::apply_function(fp, 20);
        assert(res == 30, 0);
    }
}
