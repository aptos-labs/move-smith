module 0xCAFE::ValidationTest {
    use std::vector;

    struct EmptyVariant1 has copy, drop {}
    struct EmptyVariant2 has copy, drop {}

    struct MultiFieldStruct has copy, drop {
        field1: u64,
        field2: bool,
        field3: vector<u8>,
    }

    public fun unpack_and_process(s: MultiFieldStruct): (u64, bool, vector<u8>) {
        let MultiFieldStruct {field1, field2, field3} = s;
        (field1, field2, field3)
    }

    public fun attempt_reassignment_in_loop() {
        let nums = vector[1u8, 2, 3];
        let len = vector::length(&nums);
        let i = 0;
        while (i < len) {
            let _ = i;
            // Attempting to reassign loop variable; should cause a validation error.
            // Uncommenting the following line should cause validation failure:
            // i = i + 1;
            // For the purpose of this test, leave it commented.
            i = i + 1;
        }
        // Function ends here. The reassignment line, if uncommented, should produce a compile-time error.
    }

    public fun create_empty_variants(): (EmptyVariant1, EmptyVariant2) {
        (EmptyVariant1 {}, EmptyVariant2 {})
    }
}


//# run 0xCAFE::ValidationTest::unpack_and_process --args  (MultiFieldStruct {field1: 123u64, field2: true, field3: b"test"})



//# run 0xCAFE::ValidationTest::attempt_reassignment_in_loop



//# run 0xCAFE::ValidationTest::create_empty_variants