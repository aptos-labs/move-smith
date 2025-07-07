//# publish
module 0xCAFE::LoopControl {
    public fun labeled_loop_break_continue(x: u8): u8 {
        let mut i: u8 = 0;
        let mut result: u8 = 0;

        'outer: while (i < x) {
            let mut j: u8 = 0;
            while (j < 5) {
                if (j == 3) {
                    break 'outer;
                };
                if (j == 1) {
                    j = j + 1;
                    continue;
                };
                result = result + 1;
                j = j + 1;
            };
            i = i + 1;
        };
        result
    }

    public fun parse_and_return(): u64 {
        let a: u64 = 42;
        let b: u128 = 1000;
        return a + (b as u64);
    }
}

//# run 0xCAFE::LoopControl::labeled_loop_break_continue --args 10u8

//# run 0xCAFE::LoopControl::parse_and_return

// Features:
// f6d1ca79b74d335b0452db46cd62a0fa: Break and continue from labeled loops using `break` and `continue`.
// b76d7c7ff7b3d501bbfd242bbd96e2c9: Delegate the parsing process to handle the number's suffix after identifying the numeral's extent.
// a16a6c9869c23dafcdafa035bd0cf5e4: Return values from functions using the 'return' statement