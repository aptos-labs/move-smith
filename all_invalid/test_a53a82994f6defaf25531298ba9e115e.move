//# publish
module 0xabcde::interactions {
    public fun variable_scope_test(): u64 {
        let mut total = 0;
        {
            let a = 10;
            total = total + a;
            {
                let b = 20;
                total = total + b;
                {
                    let c = 30;
                    total = total + c;
                }
            }
        }
        total
    }

    public fun loop_conditional_test(): bool {
        let mut sum = 0;
        let mut i = 0;
        while (i < 5) {
            if (i == 3) {
                break;
            };
            sum = sum + i;
            i = i + 1;
        }
        // Return true if sum equals 0+1+2=3, since loop breaks when i==3
        sum == 3
    }

    public fun inner_loop_exit(): bool {
        let mut count = 0;
        loop {
            let mut j = 0;
            while (j < 3) {
                if (j == 1) {
                    return true; // Exit early if j == 1
                };
                j = j + 1;
            }
            count = count + 1;
            if (count >= 2) {
                break;
            }
        }
        false
    }
}

//# run 0xabcde::interactions::variable_scope_test
//# run 0xabcde::interactions::loop_conditional_test
//# run 0xabcde::interactions::inner_loop_exit