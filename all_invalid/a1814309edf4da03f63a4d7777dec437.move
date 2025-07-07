
//# publish
module 0xCAFE::test_module {
    struct S {
        value: u64,
        flag: bool,
    }

    public fun create_s(val: u64, flag: bool): S {
        S { value: val, flag }
    }

    public fun get_value(s: &S): u64 {
        s.value
    }

    public fun test_dot_access(s: &S): u64 {
        s.value
    }

    public fun set_value(s: &mut S, new_value: u64) {
        s.value = new_value
    }

    public fun toggle_flag(s: &mut S) {
        s.flag = !s.flag
    }

    public fun get_flag(s: &S): bool {
        s.flag
    }

    public fun freeze_and_get_value(s_ref: &mut &S): u64 {
        let ref_immutable = &*s_ref; // convert &mut to & (immutable reference)
        get_value(ref_immutable)
    }
    
    public fun inline_process<F: &fun(u64, bool) -> u64>(func: F, arg1: u64, arg2: bool): u64 {
        func(arg1, arg2)
    }

    // Runner function to test the above features
    public fun run_tests() {
        let s = create_s(42, false);
        // Testing dot notation and field access
        let v = get_value(&s);
        assert!(v == 42);
        // Testing mutable borrow and setting new value
        let s_mut = s;
        set_value(&mut s_mut, 100);
        assert!(get_value(&s_mut) == 100);
        // Toggling flag
        toggle_flag(&mut s_mut);
        assert!(get_flag(&s_mut) == true);
        // Freezing mutable reference and reading value
        let s_ref: &mut &S = &mut &s_mut;
        let val = freeze_and_get_value(s_ref);
        assert!(val == 100);
        // Using inline function with closure
        let result = inline_process<&fun(u64, bool) -> u64>(&|x: u64, y: bool| -> u64 {
            if y { x + 1 } else { x - 1 }
        }, 10, false);
        assert!(result == 9);
    }
}


//# run 0xCAFE::test_module::run_tests

// Featurres:
// e6f6f0ded7b5db965a7c831f19af99d9: Write expressions with chained dot notation for field or method access
// b93d3ab4f27c60d785009cf046f3d8ee: Test that mutable references (`&mut`) can be safely and correctly frozen to immutable references (`&`) in various contexts, including function calls, assignments, conditionals, and borrow operations, ensuring proper Move type and borrow checker behavior.
// 7854d5b4796bbb1c7109a4054262a16d: Test that an inline function can accept and properly call a closure with multiple arguments, verifying argument binding and correct return value.
