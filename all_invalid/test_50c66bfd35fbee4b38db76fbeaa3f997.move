//# publish
module 0xabcde::addition_abort_test {
    public fun test_addition_with_abort(): u16 {
        100u16 + (abort 42; 50u16)
    }

    public fun run_test() {
        Self::test_addition_with_abort();
    }
}

 //# run 0xabcde::addition_abort_test::run_test

//# publish
module 0x12345::permission_read_write {
    struct Data has key {
        value: u64,
    }

    public fun init(s: &signer) {
        move_to(s, Data { value: 0 });
    }

    public fun read_value(): u64 reads 0x12345::permission_read_write::Data {
        let data_ref = borrow_global<Data>(@0x12345);
        data_ref.value
    }

    public fun write_value(new_value: u64) writes 0x12345::permission_read_write::Data {
        let data_ref = borrow_global_mut<Data>(@0x12345);
        data_ref.value = new_value;
    }

    public fun violated_read(): u64 !reads 0x12345::permission_read_write::Data {
        borrow_global<Data>(@0x12345).value
    }
}

//# run --signers 0x1 -- 0x12345::permission_read_write::init

//# run --signers 0x1 -- 0x12345::permission_read_write::read_value

//# run --signers 0x1 -- 0x12345::permission_read_write::write_value --args 999u64

//# run --signers 0x1 -- 0x12345::permission_read_write::violated_read

//# publish
module 0x67890::loops_with_invalid_range {
    public fun run_loop_with_invalid_range() {
        // The range start is greater than the end; loop should not execute
        for (i in 10..5) {
            assert!(false, 99); // Should not hit
        };
    }
}

//# run 0x67890::loops_with_invalid_range::run_loop_with_invalid_range