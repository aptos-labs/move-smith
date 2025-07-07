//# publish
module 0x1::constants_test {
    // A simple module to define various constants
    public fun get_magic_number(): u8 {
        0xAB
    }

    public fun get_max_u32(): u32 {
        4294967295
    }

    public fun get_boolean_true(): bool {
        true
    }

    public fun get_address(): address {
        @0xDEADBEEF
    }

    public fun get_byte_vector(): vector<u8> {
        b"MoveTest"
    }
}

//# run 0x1::constants_test::get_magic_number
//# run 0x1::constants_test::get_max_u32
//# run 0x1::constants_test::get_boolean_true
//# run 0x1::constants_test::get_address
//# run 0x1::constants_test::get_byte_vector

//# publish
module 0x2::mutable_vars {
    // A module to test reassignment of mutable local variables
    public fun reassign_and_return(): u64 {
        let mut counter: u64 = 10;
        counter = counter + 5;
        counter = counter * 2;
        counter
    }

    public fun verify() {
        assert!(reassign_and_return() == 30, 0);
    }
}

//# run 0x2::mutable_vars::verify

//# publish
module 0x3::consts_and_mutability {
    // Combining constants with mutability
    public fun test_const_and_mut() {
        const FIVE: u64 = 5;
        let mut total = FIVE;
        total = total + 10;
        assert!(total == 15, 0);
    }

    public fun get_const(): u8 {
        0x7F
    }

    public fun get_vector(): vector<u8> {
        x"CAFEBABE"
    }

    public fun check() {
        test_const_and_mut();
        assert!(get_const() == 0x7F, 0);
        assert!(get_vector() == x"CAFEBABE", 0);
    }
}

//# run 0x3::consts_and_mutability::check
