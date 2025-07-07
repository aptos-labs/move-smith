
//# publish
module 0xCAFE::AdvanceTest {

    // Define f2 inline here to remove dependency on MyModule
    /// Returns a tuple (a, a + 1)
    public fun f2(a: u16): (u16, u16) {
        (a, a + 1)
    }

    public fun add_and_check(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return fixed number if sum > 10 else sum
        if (sum > 10) {
            42u8
        } else {
            sum
        }
    }

    public fun test_lambda(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y + 1
        };
        let result = lambda(3u8, 4u8);
        result
    }

    public fun call_inline_and_add(a: u16, b: u16): u32 {
        let (x, y) = Self::f2(a);
        let val = x + y + b;
        val as u32
    }
}



//# run 0xCAFE::AdvanceTest::add_and_check --args 5u8 6u8



//# run 0xCAFE::AdvanceTest::add_and_check --args 1u8 2u8



//# run 0xCAFE::AdvanceTest::test_lambda



//# run 0xCAFE::AdvanceTest::call_inline_and_add --args 10u16 5u16
