
//# publish
module 0xCAFE::TupleAndStructTest {
    struct Data has store {
        a: u8,
        b: bool,
        c: u64
    }

    enum Status has copy, drop {
        Ok(u8),
        Err { code: u16 },
        None
    }

    // Function that returns multiple values as a tuple
    public fun return_multiple_values(): (u8, bool, u64) {
        (1u8, true, 42u64)
    }

    // Function that returns a struct instance
    public fun make_data(): Data {
        Data {a: 7u8, b: false, c: 1234u64}
    }

    // Function to return an enum variant
    public fun make_status_ok(): Status {
        Status::Ok(255u8)
    }

    // Function returning a tuple with references to input argument fields.
    // Since references cannot be directly returned as multiple values, we'll return a tuple of u8 + bool
    public fun destructure_data_ref(data: &Data): (u8, bool) {
        (data.a, data.b)
    }

    public fun destructure_status_ref(status: &Status): u8 {
        match (status) {
            Status::Ok(x) => *x,
            Status::Err { code } => code as u8,
            Status::None => 0u8,
        }
    }

    // Function that receives references and returns a tuple
    public fun ref_tuple(x: &u8, y: &u64): (u8, u64) {
        (*x, *y)
    }

    // Private helper function that returns a tuple of Data and Status
    fun tuple_of_struct_and_enum(): (Data, Status) {
        (Data {a: 99u8, b: true, c: 999u64}, Status::None)
    }

    // Public function that calls the private helper and returns only first field of Data
    public fun call_helper(): u8 {
        let (data, _status) = tuple_of_struct_and_enum();
        data.a
    }
}


//# run 0xCAFE::TupleAndStructTest::return_multiple_values


//# run 0xCAFE::TupleAndStructTest::make_data


//# run 0xCAFE::TupleAndStructTest::make_status_ok


//# run 0xCAFE::TupleAndStructTest::destructure_data_ref --args 0xCAFE


//# run 0xCAFE::TupleAndStructTest::destructure_status_ref --args 0xCAFE


//# run 0xCAFE::TupleAndStructTest::ref_tuple --args 42u8 555u64


//# run 0xCAFE::TupleAndStructTest::call_helper



//# publish
module 0xCAFE::ReferenceTest {
    struct Container has store {
        x: u8,
        y: u16
    }

    public fun make_container(x: u8, y: u16): Container {
        Container { x, y }
    }

    public fun read_immutable_ref(c: &Container): u16 {
        c.y
    }

    public fun update_with_mut_ref(c: &mut Container, new_x: u8, new_y: u16) {
        c.x = new_x;
        c.y = new_y;
    }

    public fun return_ref_to_x(c: &Container): &u8 {
        &c.x
    }

    public fun return_mut_ref_to_y(c: &mut Container): &mut u16 {
        &mut c.y
    }

    public fun tuple_of_refs(c: &Container): (&u8, &u16) {
        (&c.x, &c.y)
    }

    // Function that accepts a tuple of mutable references and modifies them
    public fun update_tuple_of_mut_refs(t: (&mut u8, &mut u16), new_x: u8, new_y: u16) {
        *(t.0) = new_x;
        *(t.1) = new_y;
    }
}


//# run 0xCAFE::ReferenceTest::make_container --args 10u8 100u16


//# run 0xCAFE::ReferenceTest::read_immutable_ref --args 0xCAFE


//# run 0xCAFE::ReferenceTest::return_ref_to_x --args 0xCAFE


//# run 0xCAFE::ReferenceTest::return_mut_ref_to_y --args 0xCAFE


//# run 0xCAFE::ReferenceTest::tuple_of_refs --args 0xCAFE


//# run 0xCAFE::ReferenceTest::update_with_mut_ref --args 0xCAFE 15u8 200u16


//# run 0xCAFE::ReferenceTest::update_tuple_of_mut_refs --args 0xCAFE 20u8 300u16


// Featurres:
// 1300979e3b9b7c757af6fe6978a1cea6: Declare functions that return multiple values as a tuple
// 71dc097012aed9aeb3db6d1569553f33: Restrict packing (constructing) and unpacking (destructuring) of structs and enums to the module that defines them.
// d76b9ce10a67c45edb4d1950c476495c: Start a type with an opening parenthesis '(' or an ampersand '&' or '& mut' for mutable references.
