
//# publish
module 0xCAFE::Addition {
    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        // add 10 to check combination
        sum + 10
    }

    public fun lambda_example(): u8 {
        let l: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            a + b
        };
        l(20u8, 22u8)
    }
}



//# run 0xCAFE::Addition::add_and_return --args 8u8 7u8



//# run 0xCAFE::Addition::lambda_example




//# publish
module 0xCAFE::InlineCall {
    use 0xCAFE::Addition;

    public inline fun inline_add_twice(x: u8, y: u8): u8 {
        let a = Addition::add_and_return(x, y);
        let b = Addition::add_and_return(a, y);
        a + b
    }
}



//# run 0xCAFE::InlineCall::inline_add_twice --args 3u8 4u8




//# publish
module 0xCAFE::CycleTest {
    public fun factorial(n: u8): u64 {
        if (n <= 1u8) {
            1u64
        } else {
            (n as u64) * factorial(n - 1u8)
        }
    }

    public fun fibonacci(n: u8): u64 {
        if (n == 0u8) {
            0u64
        } else if (n == 1u8) {
            1u64
        } else {
            fibonacci(n - 1u8) + fibonacci(n - 2u8)
        }
    }

    fun even_odd_even(n: u8): u8 {
        if (n == 0u8) {
            0u8
        } else {
            odd_even_odd(n - 1u8)
        }
    }

    fun odd_even_odd(n: u8): u8 {
        if (n == 0u8) {
            1u8
        } else {
            even_odd_even(n - 1u8)
        }
    }

    public fun run_cycle_tests(): (u64, u64, u8) {
        let fact_5 = factorial(5u8);
        let fib_7 = fibonacci(7u8);
        let eo_val = even_odd_even(4u8);
        (fact_5, fib_7, eo_val)
    }
}



//# run 0xCAFE::CycleTest::run_cycle_tests




//# publish
module 0xCAFE::KeyDropTest {
    struct KeyDropType has key, drop, store {
        a: u8,
        b: u8,
    }

    public fun borrow_and_move(addr: address) {
        // Borrow global reference
        let ref: &KeyDropType = borrow_global<KeyDropType>(addr);
        let _a = ref.a;

        // Move from same address should cause rejection logically,
        // but here we write code anyway for testing compiler/VM behavior
        let _moved_obj = move_from<KeyDropType>(addr);
        // _moved_obj dropped here

        // This function is expected to cause issues when run because of key + drop usage interleaved
        // It will test compiler/VM enforcement of key+drop limits
    }
}



//# run 0xCAFE::KeyDropTest::borrow_and_move --args 0xBEEF
