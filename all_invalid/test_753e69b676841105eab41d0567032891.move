//# publish
module 0xabcde::increment {
    // Inline function to increment a u64 value by one
    inline fun inc(x: u64): u64 {
        x = x + 1;
        x
    }

    // Function that sums the initial value with two increments of that value
    public fun test(): u64 {
        let initial = 5;
        initial + inc(initial) + inc(initial)
    }

    // Runner function to execute test
    public fun run_test(): u64 {
        test()
    }
}

//# run 0xabcde::increment::run_test

//# publish
module 0x12345::captured_env {
    struct Config has drop, copy {
        factor: u64,
        multiplier: u8
    }

    // Function capturing primitive variables and struct environment
    public fun primitive_captured(offset: u64): u64 {
        let factor = 10;
        let multiplier = 3u8;
        let f = |x| factor * x + (multiplier as u64) + offset;
        f(2)
    }

    // Function capturing only primitive variables
    public fun primitive_only(x: u64): u64 {
        let base = 7;
        let f = |y| base + y + x;
        f(4)
    }

    // Function capturing a struct environment
    public fun struct_captured(cfg: Config): u64 {
        struct_env_helper(cfg)
    }

    fun struct_env_helper(cfg: Config): u64 {
        let f = |z| cfg.factor * z + (cfg.multiplier as u64);
        f(5)
    }
}

//# run 0x12345::captured_env::primitive_captured --args 2

//# run 0x12345::captured_env::primitive_only --args 4

//# run 0x12345::captured_env::struct_captured --args 0x1u64 5u8

//# publish
module 0x67890::nested_abort {
    // Function demonstrating nested aborts
    public fun abort_test(): u64 {
        (abort 21) + {
            (abort 42);
            0
        } + 0
    }
}

//# run 0x67890::nested_abort::abort_test