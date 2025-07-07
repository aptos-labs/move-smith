//# publish
module 0xabcde::abort_test {
    public fun abort_in_loop(counter: u64): u64 {
        let mut result = 0;
        let mut i = 0;
        while (i < counter) {
            if (i == 2u64) {
                abort i;
            }
            result = result + i;
            i = i + 1;
        }
        result
    }

    public fun finalize_result(acc: u64, x: u64): u64 {
        acc + x
    }

    public fun run_test(): u64 {
        let mut total = 0;
        let mut j = 0;
        while (j < 5) {
            let res = abort_in_loop(5);
            total = finalize_result(total, res);
            j = j + 1;
        }
        total
    }
}

//# run 0xabcde::abort_test::run_test