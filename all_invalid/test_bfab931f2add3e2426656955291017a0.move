//# publish
module 0x1234::anon_blocks_test {
    /// Function testing multiple anonymous blocks executed in sequence,
    /// with variable modifications and final result reflecting all updates.
    public fun test_anon_blocks(): u64 {
        let mut a = 10;
        let mut b = 20;

        // First anonymous block: modify 'a' and return its value
        { a = a + 5; a }

        // Second anonymous block: modify 'b' based on 'a' and return new 'b'
        { b = b + a; b }

        // Third anonymous block: perform computations involving 'a' and 'b'
        { a = a * 2; b = b - 3; a + b }

        // Final expression sums 'a' and 'b' after all modifications
        a + b
    }
}

//# run 0x1234::anon_blocks_test::test_anon_blocks