//# publish
module 0xA::MutableLoopTest {
    public fun modify_and_return(x: &mut u64): u64 {
        *x = *x + 2;
        *x
    }

    public fun run_loop(count: u64): u64 {
        let mut counter = 0;
        let limit = count;
        while (counter < 5) {
            counter = counter + 1;
        }
        counter
    }

    public fun main(): u64 {
        let mut val = 0;
        // Call modify_and_return to change val and get the new value
        let result = modify_and_return(&mut val);
        // Determine loop iterations based on the result
        for (i in 0..run_loop(result)) {}
        val
    }

    // Optional: A runner function to invoke main without args
    public fun run_main(): u64 {
        main()
    }
}

//# run 0xA::MutableLoopTest::main

//# publish
module 0xA::NestedFunctionTest {
    public fun f3(x: u64): u64 {
        x + 4
    }

    public fun f2(x: u64): u64 {
        f3(x * 2)
    }

    public fun f1(x: u64): u64 {
        f2(x) + 1
    }

    public fun test(): u64 {
        f1(5)
    }
}

//# run 0xA::NestedFunctionTest::test

//# publish
module 0xA::ByteSequenceComparison {
    public fun check_non_canonical() {
        let seq = vector[128];
        let canonical_seq_hex = vector[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 128]; 
        // Verify that the sequence with high bit set is equal to its hex representation
        assert!(seq == canonical_seq_hex, 1);
    }
}

//# run 0xA::ByteSequenceComparison::check_non_canonical