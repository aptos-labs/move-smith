//# publish
module 0xA11Y::curried_conditions {

    fun check_condition(cond: bool, true_val: u64, false_val: u64): u64 {
        if (cond) true_val else false_val
    }

    public fun run(): bool {
        let negate_and_select = |x, y| check_condition(!x, y, 100);
        let threshold_check = |c, v| check_condition(c > 5, v, 0);
        let always_false = |x| check_condition(false, x, 999);
        let complex_condition = |x, y| check_condition((x + y) > 10, x * 2, y * 3);

        assert!(negate_and_select(true, 77) == 100); // since !true = false → false_val
        assert!(negate_and_select(false, 88) == 88); // since !false = true → true_val
        assert!(threshold_check(3, 42) == 0); // 3 > 5? no → 0
        assert!(threshold_check(10, 42) == 42); // 10 > 5? yes → v
        assert!(always_false(123) == 999); // always the false branch
        assert!(complex_condition(4, 10) == 30); // (4+10) >10? yes → 4*2=8, but wait → check condition (14 > 10)? yes → x*2=8
        assert!(complex_condition(3, 3) == 9); // (3+3)=6 >10? no → y*3=9
        true
    }
}

//# run 0xA11Y::curried_conditions::run