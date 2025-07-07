//# publish
address 0xA1 {
module ReassignCondTest {
    public fun reassign_cond_test(a: address, b: bool): address {
        if (b) {
            a = @0xB2;
        };
        a
    }

    public fun run_reassign_with_false() {
        let result = reassign_cond_test(@0xC3, false);
        // Expect the address to remain @0xC3
        assert!(result == @0xC3, 100);
    }

    public fun run_reassign_with_true() {
        let result = reassign_cond_test(@0xD4, true);
        // Expect the address to be reassigned to @0xB2
        assert!(result == @0xB2, 101);
    }

    public fun reassign_cond_no_mutable(a: address, b: bool): address {
        // Reassign only if true, should not change if false
        let mut_addr = a;
        if (b) {
            mut_addr = @0xE5;
        }
        mut_addr
    }

    public fun run_no_mutable_reassign() {
        let unchanged = reassign_cond_no_mutable(@0xF6, false);
        let changed = reassign_cond_no_mutable(@0xF6, true);
        assert!(unchanged == @0xF6, 102);
        assert!(changed == @0xE5, 103);
    }
}
}

//# run 0xA1::ReassignCondTest::run_reassign_with_false
//# run 0xA1::ReassignCondTest::run_reassign_with_true
//# run 0xA1::ReassignCondTest::run_no_mutable