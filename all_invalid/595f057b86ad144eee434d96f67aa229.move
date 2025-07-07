
//# publish
module 0xCAFE::TestModule {

    struct GenericStruct<T> {
        field1: T,
        field2: u64,
    }

    public fun create_generic_struct<T: copy>(value: T): GenericStruct<T> {
        GenericStruct { field1: value, field2: 42 }
    }

    public fun get_field1<T: copy>(gs: &GenericStruct<T>): &T {
        &gs.field1
    }

    public fun get_field2<T>(gs: &GenericStruct<T>): u64 {
        gs.field2
    }

    // Function with unused parameter
    public fun unused_param_test(unused_param: u64, used_param: u64): u64 {
        // unused_param is not used below to test compiler warning
        used_param
    }

    // Function that projects fields and returns references
    public fun project_and_return<T: copy>(gs_ref: &GenericStruct<T>): &T {
        get_field1(gs_ref)
    }

    // Function to test that references and projections access fields
    public fun test_projection_and_reference<T: copy>(gs: &GenericStruct<T>): (T, u64) {
        // clone the field1 value if needed, assume T is Copy for simplicity
        // for the test, we'll only access references
        let field_ref = get_field1(gs);
        let field_value = *field_ref;
        let field2_value = get_field2(gs);
        (field_value, field2_value)
    }

    // Function to test abort with a value
    public fun test_abort_with_value(): u8 {
        abort 0x1u8;
         // unreachable code, but needed for type consistency
        0
    }

    // runner function to execute the above tests
    public fun run_tests() {
        let gs = create_generic_struct::<u64>(100);
        // test projection and references
        let (val, num) = test_projection_and_reference(&gs);
        // test that unused param generates warning (not enforced here, just included)
        let result = unused_param_test(999, val);
        // call abort function (will abort)
        test_abort_with_value();
    }
}


//# run 0xCAFE::TestModule::run_tests --signers 0xCAFE