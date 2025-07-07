
//# publish
module 0xCAFE::TestModule {
    use std::vector;
    use std::phantom;

    struct PhantomStruct<T> has copy, drop, store {
        _marker: phantom::Phantom<T>,
        value: u64,
    }

    struct ComplexStruct has copy, drop, store {
        flag: bool,
        count: u32,
    }

    public fun test_match_comma_conditions(x: u8): u8 {
        let result = match x {
            1 => 10,
            2 => 20,
            3 | 4 | 5 => 30,
            _ => 40,
        };
        result
    }

    public fun test_struct_by_move() {
        let s1 = ComplexStruct { flag: true, count: 1 };
        let s2 = s1;
        // After move, s1 cannot be used; s2 owns the data

        let value1 = s2.count;

        let s3 = s2;
        // create a mutable reference to s3's field
        let s3_ref = &mut s3.count;
        *s3_ref = *s3_ref + 10;

        // access through s3
        let final_count = s3.count;
        final_count
    }

    public fun test_type_parameter_phantom(): u64 {
        let phantom_struct1 = PhantomStruct<u8> { _marker: phantom::Phantom {}, value: 123 };
        let phantom_struct2 = PhantomStruct<u64> { _marker: phantom::Phantom {}, value: 456 };
        // Use the value fields
        phantom_struct1.value + phantom_struct2.value
    }
}


//# run 0xCAFE::TestModule::test_match_comma_conditions --args 3u8


//# run 0xCAFE::TestModule::test_struct_by_move


//# run 0xCAFE::TestModule::test_type_parameter_phantom