//# publish
module 0xABCD::ClosureTest {
    // This inline function accepts two closure arguments with different parameter signatures.
    // It applies each closure to computed values and combines their results.
    inline fun process_closures(
        f: |u8, u8| u16,
        g: |u16, u16| u32,
        a: u8,
        b: u8,
        c: u16,
        d: u16
    ): u64 {
        let val_f = f(a + 2, b + 3); // Apply first closure
        let val_g = g(c + 4, d + 5); // Apply second closure
        (val_f as u64) + (val_g as u64) + (a as u64) * 10 + (b as u64) * 20 + (c as u64) * 30 + (d as u64) * 40
    }

    // Runner function to test process_closures with various closure configurations.
    public fun test() {
        let result = process_closures(
            |x: u8, y: u8| -> u16 { x as u16 * y as u16 },
            |m: u16, n: u16| -> u32 { m as u32 + n as u32 },
            5, // a
            7, // b
            100, // c
            200 // d
        );
        // The expected calculation:
        // f: (5+2, 7+3) => 7 * 10 = 70
        // g: (100+4, 200+5) => 104 + 205 = 309
        // Total: 70 + 309 + 5*10 + 7*20 + 100*30 + 200*40 = 70 + 309 + 50 + 140 + 3000 + 8000 = 11569
        assert!(result == 11569, result);
    }
}

//# run 0xABCD::ClosureTest::test