//# publish
module 0xAB::LogicalTests {
    public fun tester(a: bool, b: bool): u64 {
        let y = 1;
        // First block: use OR to potentially increase y
        { y = y * 2; a } || { y = y * 3; false };
        // Second block: use AND to conditionally modify y
        { y = y + 4; b } && { y = y + 5; true };
        y
    }

    // A runner function to facilitate testing
    public fun run_tests() {
        // You can call tester with various boolean combinations
        let result1 = Self::tester(false, false);
        assert!(result1 == 4, 1);
        let result2 = Self::tester(false, true);
        assert!(result2 == 9, 2);
        let result3 = Self::tester(true, false);
        assert!(result3 == 9, 3);
        let result4 = Self::tester(true, true);
        assert!(result4 == 14, 4);
    }
}

//# run 0xAB::LogicalTests::run_tests