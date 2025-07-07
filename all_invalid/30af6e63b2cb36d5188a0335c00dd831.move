
//# publish
module 0xCAFE::TupleAndConstTest {
    const MAGIC_NUMBER: u64 = 0x1234;

    struct Point has copy, drop, store {
        x: u64,
        y: u64,
    }

    public fun tuple_destructuring_and_modify(): (u64, u64) {
        let (mut a, mut b) = (5u64, 10u64);
        a = a + 3;
        b = b * 2;
        let (c, d) = (a + 1, b - 2);
        (c, d)
    }

    public fun access_const_and_struct_fields(): u64 {
        let p = Point { x: MAGIC_NUMBER, y: 0x1111 };
        let _sum = p.x + p.y + MAGIC_NUMBER;
        // return the sum of field x, y and the constant
        _sum
    }
}


//# run 0xCAFE::TupleAndConstTest::tuple_destructuring_and_modify


//# run 0xCAFE::TupleAndConstTest::access_const_and_struct_fields


// Featurres:
// cc11638eaf2be4fb0f94c7b89e32fee2: Test that multiple local variables can be assigned simultaneously using tuple destructuring and their values are correctly computed through sequential modifications within the function.
// 8041737d3ecd51a16b9b89f9a95646fd: Reference named constants from the current or other modules in attribute values.
// ad85128a36447a8cf9a6445270a1bf6e: Access fields in a struct using dot notation
