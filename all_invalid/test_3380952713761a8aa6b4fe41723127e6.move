//# publish
module 0xabcde::scope_test {
    public fun test_scopes(): u64 {
        let total = 0;
        let mut x = 10;
        {
            x = x + 5;
            let y = x * 2;
            total = total + y;
        }
        {
            let z = x - 3;
            x = z * 4;
            total = total + x;
        }
        // Final value of x should be (initial 10) -> +5 -> *4 after second block
        // total = (x+5)*2 (from first block) + (x-3)*4 (from second block)
        total
    }
}

//# run 0xabcde::scope_test::test_scopes