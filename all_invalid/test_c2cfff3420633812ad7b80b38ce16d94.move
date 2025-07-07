//# publish
module 0x10::conditional_closure_test {

    fun check_equality(c: bool, a: u64, b: u64): u64 {
        if (c) a else b
    }

    public fun run(): bool {
        let closure_all_true = |x, y| check_equality(true, x, y);
        let closure_partial = |c, x| check_equality(c, 99, x);
        let closure_all_false = |x| check_equality(false, 100, x);
        let closure_conditional = |c, x| check_equality(c, x, 200);
        let closure_double_conditional = |c1, c2, x| check_equality(c1 && c2, x, 50);

        assert!(closure_all_true(1, 2) == 1);
        assert!(closure_partial(true, 777) == 99);
        assert!(closure_partial(false, 778) == 778);
        assert!(closure_all_false(123) == 100);
        assert!(closure_conditional(true, 555) == 555);
        assert!(closure_conditional(false, 555) == 200);
        assert!(closure_double_conditional(true, true, 11) == 11);
        assert!(closure_double_conditional(true, false, 22) == 50);
        assert!(closure_double_conditional(false, true, 33) == 50);
        assert!(closure_double_conditional(false, false, 44) == 50);
        true
    }
}
//# run 0x10::conditional_closure_test::run

//# publish
module 0x10::mutation_loop_test {

    fun increment_loop() {
        let mut count = 0;
        let c = true;
        let mut i = 0;
        while (i < 5) {
            count = count + 1;
            i = i + 1;
        }
        assert!(count == 5, 0);
    }

    fun toggle_variable() {
        let mut flag = false;
        let c = true;
        let mut j = 0;
        while (j < 3) {
            flag = !flag;
            j = j + 1;
        }
        assert!(flag == true, 0);
    }

    public fun run(): bool {
        increment_loop();
        toggle_variable();
        true
    }
}
//# run 0x10::mutation_loop_test::run