//# publish
module 0xabcde::nested_calls {
    fun compute(x: u64): u64 {
        x
    }

    fun nested(p: u64): u64 {
        // multiple nested calls to verify correct return propagation
        compute(compute(compute(p + 2)))
    }

    public fun run() {
        assert!(nested(10) == 14, 0);
    }
}

//# run 0xabcde::nested_calls::run

//# publish
module 0xabcde::sequential_assign {
    public fun test(): u64 {
        let a = 5;
        // perform sequential assignment and use the updated value in an expression
        let a = a + 10;
        let a = a * 2;
        a
    }
}

//# run 0xabcde::sequential_assign::test