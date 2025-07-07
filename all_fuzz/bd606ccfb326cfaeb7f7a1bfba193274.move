
//# publish
module 0xCAFE::LambdaTest {
    use std::signer;

    public fun add_two_u8(x: u8, y: u8): u8 {
        let sum = x + y;
        // Specific value to return: sum + 10
        sum + 10
    }

    public fun run_lambda_no_args() {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let _result = lambda(5u8, 10u8);
    }

    public fun accept_lambda_and_apply(x: u8, f: &dyn Fn(u8): u8): u8 {
        // Apply lambda f to x then add 1
        let res = (*f)(x);
        res + 1
    }

    spec {
        // global spec variable
        global spec var global_counter: u64;

        // local spec variable in function (no function here, so declare a named spec function)
        spec fun local_spec_example(): u8 {
            42
        }
    }
}



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaTest;

    public inline fun call_add_and_increment(x: u8, y: u8): u8 {
        let base = LambdaTest::add_two_u8(x, y);
        base + 1
    }

    public fun run_control_flow(x: u8) : u8 {
        let res = 0u8;
        loop {
            if (x == 0) {
                break;
            };
            if (x == 1) {
                res = 5u8;
                break;
            };
            res = res + 1;
            break;
        };

        let y = 3u8;
        while (y > 0) {
            if (y == 2) {
                y = y - 1;
                continue;
            };
            y = y - 1;
        };

        if (res == 0) {
            res = 10u8;
        } else {
            res = 20u8;
        };

        res
    }

    spec {
        // global spec variable with initialization
        global spec var total_calls: u64 = 0;

        spec fun dummy_spec_fun(): bool {
            true
        }
    }
}



//# run 0xCAFE::LambdaTest::add_two_u8 --args 15u8 20u8



//# run 0xCAFE::LambdaTest::run_lambda_no_args


// Instead of passing the lambda inline with --args (which is unsupported),
// here is a minimal wrapper function to test accept_lambda_and_apply:

public fun double_and_increment(x: u8): u8 {
    accept_lambda_and_apply(x, &Self::double)
}

public fun double(x: u8): u8 {
    x * 2
}


//# run 0xCAFE::LambdaTest::double_and_increment --args 7u8



//# run 0xCAFE::InlineCaller::call_add_and_increment --args 10u8 5u8



//# run 0xCAFE::InlineCaller::run_control_flow --args 1u8
