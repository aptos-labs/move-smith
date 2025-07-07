//# publish
module 0xabcde::test_module {
    fun get_tuple(): (u8, u16) {
        (10u8, 20u16)
    }

    public fun test_var_binding(_: u64): u64 {
        let a = 42u64;
        let (b, c) = get_tuple();
        a + b as u64 + c as u64
    }

    public fun test_destructuring(_: u64): u64 {
        let (x, y) = get_tuple();
        let d = 100u16;
        let (e, f) = (d, y);
        e as u64 + f as u64
    }

    public fun run_inline_func(): u64 {
        inline fun add_three(n: u64): u64 {
            n + 3
        }
        add_three(7)
    }

    public fun run_higher_order_fn(): u64 {
        let closure = |x: u64| -> u64 { x * 2 };
        // Simulate higher-order function call
        inline fun apply_fn(f: |u64|u64, val: u64): u64 {
            f(val)
        }
        apply_fn(closure, 5)
    }

    public fun run_anonymous_closure(): u64 {
        let closure = |x: u64| -> u64 { x + 10 };
        closure(15)
    }

    public fun run_destructuring_in_params(_: u64): u64 {
        // Destructuring in parameter list
        public fun inner((x: u64, y: u64)): u64 {
            x + y
        }
        inner((5, 7))
    }

    public fun run_closure_with_capture(): u64 {
        let base = 5u64;
        let closure = |x: u64| -> u64 { x + base };
        closure(10)
    }
}

//# run 0xabcde::test_module::test_var_binding --args 0
//# run 0xabcde::test_module::test_destructuring --args 0
//# run 0xabcde::test_module::run_inline_func
//# run 0xabcde::test_module::run_higher_order_fn
//# run 0xabcde::test_module::run_anonymous_closure
//# run 0xabcde::test_module::run_destructuring_in_params --args 0
//# run 0xabcde::test_module::run_closure_with_capture