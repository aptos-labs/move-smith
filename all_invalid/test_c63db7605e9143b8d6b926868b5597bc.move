//# publish
module 0xabcde::seq_assignments {

    /// A function that performs multiple sequential assignments and uses the latest value.
    public fun perform_assignments(): u64 {
        let mut x = 10;
        x = x + 5; // x = 15
        x = x * 2; // x = 30
        let y = x - 4; // y = 26
        y + x // 26 + 30 = 56
    }
}

//# run 0xabcde::seq_assignments::perform_assignments

//# publish
module 0x12345::casting_tests {

    /// Test various casting and uses in arithmetic with the updated value.
    public fun casting_and_use(): u8 {
        let a: u16 = 250;
        let b = a as u8; // should be 250
        let c: u8 = 5;
        let d = b + c; // 250 + 5 = 255
        d
    }
}

//# run 0x12345::casting_tests::casting_and_use

//# publish
module 0x67890::overflow_behavior {

    /// Test casting that results in overflow triggering failure.
    public fun cast_overflow(): u8 acquires 0 {
        let large: u16 = 300;
        // This cast should fail due to overflow
        large as u8
    }
}

//# run 0x67890::overflow_behavior::cast_overflow --signers 0x0

//# publish
module 0x9abcdef::combined_tests {

    /// Sequence of assignments combined with casting and arithmetic.
    public fun complex_sequence(): u128 {
        let a = 400u64;
        let a = a + 100; // 500
        let a = a * 2;   // 1000
        let b = a as u32; // cast to u32, within range
        let c: u64 = b as u64; // cast back to u64
        c + 200 // 1000 + 200 = 1200
    }
}

//# run 0x9abcdef::combined_tests::complex_sequence

//# publish
module 0xdeadbeef::overflow_and_cast {

    /// Test that overflow casts are caught.
    public fun test_overflow_cast(): u16 {
        let large: u32 = 70000;
        // This cast should fail due to overflow.
        large as u16
    }
}

//# run 0xdeadbeef::overflow_and_cast::test_overflow_cast --signers 0x0

//# publish
module 0xabcde::indexing_and_assignment {

    /// Series of sequential index-based assignments and int operations.
    public fun sequence_indices(): u64 {
        let mut arr = vector[0u64, 0u64, 0u64];
        vector::borrow_mut(&mut arr, 0) := 5;
        vector::borrow_mut(&mut arr, 1) := 10;
        vector::borrow_mut(&mut arr, 2) := 15;
        let sum = vector::index(&arr, 0) + vector::index(&arr, 1) + vector::index(&arr, 2);
        // sum = 5+10+15=30
        sum * 2
    }
}

//# run 0xabcde::indexing_and_assignment::sequence_indices

//# publish
module 0x13579::mixed_tests {

    /// Test sequential assignments with multiple types and casting.
    public fun mixed_type_sequence(): u64 {
        let mut count: u8 = 10;
        count = count + 20; // count=30
        let sum_masked: u16 = (count as u16) + 50; // 30 + 50=80
        let final_value = sum_masked as u64; // 80
        final_value + 20 // 100
    }
}

//# run 0x13579::mixed_tests::mixed_type_sequence