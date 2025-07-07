
//# publish
module 0xCAFE::VariableCategorization {
    struct MyStruct<T> {
        field1: T,
        field2: u64,
    }
}


//# run 0xCAFE::VariableCategorization::VariableCategorization


//# run 0xCAFE::InlineExpressions::evaluate_side_effects --signers 0xCAFE



//# publish
module 0xCAFE::StructTypeParams {
    struct Container<T> {
        value: T,
    }

    public fun create_container<T>(val: T): Container<T> {
        Container { value: val }
    }

    public fun get_value<T>(container: &Container<T>): T {
        copy container.value
    }
}

// get a container for 42u64
// We need to call create_container first, then pass its result as a type argument to get_value.
// To do so, first explicitly create the container and assign it to a variable.
public fun call_create_and_get_value(): u64 {
    let container = create_container(42u64);
    get_value(&container)
}

// then, run the functions

//# run 0xCAFE::StructTypeParams::create_container --args 42u64 --signers 0xCAFE


//# run 0xCAFE::StructTypeParams::get_value --args 0xCAFE::StructTypeParams::create_container::call_create_and_get_value --signers 0xCAFE