
//# publish
module 0xCAFE::TestDestructuring {
    // Destructuring with tuples
    public fun tuple_destructuring() {
        let (a, b, c) = (1u64, 2u64, 3u64);
        // Fields assigned with tuple pattern
        let _sum = a + b + c;
    }

    // Destructuring with struct
    struct DataStruct has copy, drop {
        field1: u8,
        field2: u16,
    }

    public fun struct_destructuring(ds: DataStruct) {
        let DataStruct { field1: f1, field2: f2 } = ds;
        // Variables f1, f2 extracted correctly
        let _name_sum = f1 as u16 + f2;
    }

    

//# run 0xCAFE::TestDestructuring::tuple_destructuring
    

//# run 0xCAFE::TestDestructuring::struct_destructuring --args (DataStruct {field1: 4u8, field2: 1000u16})
}
