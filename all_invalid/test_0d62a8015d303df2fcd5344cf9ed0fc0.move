//# publish
module 0xA11E::AddFunctionTest {

    // Function to add two u64 values
    public fun add(x: u64, y: u64): u64 {
        x + y
    }

    // Runner that calls add with different values
    public fun test_addition(): u64 {
        add(12345, 67890)
    }
}

//# run 0xA11E::AddFunctionTest::test_addition

//# publish
module 0xBADD::StructInteraction {

    // Generic struct with three fields
    struct Data<A, B, C>(A, B, C) has drop;

    // Struct with named fields
    struct Container<A, B> has drop {
        field_x: A,
        field_y: B
    }

    // Function that accesses the first element of a Data struct
    fun get_first<A, B, C>(d: &Data<A, B, C>): &A {
        let Data(a, _, _) = d;
        a
    }

    // Function that accesses the second element of a Data struct via projection
    fun get_second<A, B, C>(d: &Data<A, B, C>): &B {
        let Data(_, b, _) = d;
        b
    }

    // Function that extracts the 'x' field from Container
    fun get_x_field<A, B>(c: &Container<A, B>): &A {
        &c.field_x
    }

    // Function that extracts the 'y' field from Container
    fun get_y_field<A, B>(c: &Container<A, B>): &B {
        &c.field_y
    }

    // Function that consumes a Data struct and drops resources
    public fun process_data<A, B, C>(d: Data<A, B, C>) {
        // Intentionally do nothing, resource will be dropped
    }

    // Function that tests resource handling and projections together
    public fun test_structs(): bool {
        let data = Data(42, 3.14, true);
        let container = Container { field_x: "hello", field_y: 999 };

        // Access via functions
        let first_value = get_first(&data);
        let second_value = get_second(&data);
        let x_field_ref = get_x_field(&container);
        let y_field_ref = get_y_field(&container);

        // Convert references to values for comparison
        let first_value_cpy = *first_value;
        let second_value_cpy = *second_value;
        let x_field_val = *x_field_ref;
        let y_field_val = *y_field_ref;

        // Drop resources explicitly
        process_data(data);

        // Verify the correctness of projections and field access
        first_value_cpy == 42 && second_value_cpy == 3.14 && x_field_val == "hello" && y_field_val == 999
    }
}

//# run --verbose -- 0xA11E::AddFunctionTest::test_addition

//# run --verbose -- 0xBADD::StructInteraction::test_structs