
//# publish
module 0xCAFE::TestStructs {
    struct A has copy, drop, store {
        val: u64,
    }

    struct B has copy, drop, store {
        count: u64,
        flag: bool,
    }

    public fun make_a(v: u64): A {
        A { val: v }
    }

    public fun make_b(c: u64, f: bool): B {
        B { count: c, flag: f }
    }

    public fun get_val(a: &A): u64 {
        a.val
    }

    public fun get_count_and_flag(b: &B): (u64, bool) {
        (b.count, b.flag)
    }
}


//# run 0xCAFE::TestStructs::make_a --args 123u64


//# run 0xCAFE::TestStructs::make_b --args 44u64 true


//# publish
module 0xCAFE::CalcAndCallBar {
    use 0xCAFE::TestStructs;

    public fun bar(x: u64): u64 {
        x * 2
    }

    public fun calculate_and_call_bar(x: u64, cond: bool): u64 {
        if (cond) {
            // multiply x by 3 and pass to bar
            bar(x * 3)
        } else {
            // multiply x by 5 and pass to bar
            bar(x * 5)
        }
    }
}


//# run 0xCAFE::CalcAndCallBar::calculate_and_call_bar --args 4u64 true


//# run 0xCAFE::CalcAndCallBar::calculate_and_call_bar --args 4u64 false


//# publish
module 0xCAFE::MutRefModifier {
    use std::assert;

    public fun increment(val: &mut u64) {
        *val = *val + 1;
    }

    public fun multiply_by_two(val: &mut u64) {
        *val = *val * 2;
    }

    public fun modify_values(x: &mut u64, y: &mut u64) {
        increment(x);
        multiply_by_two(y);
    }

    public fun test_modify_values() {
        let a = 10u64;
        let b = 20u64;
        modify_values(&mut a, &mut b);

        // Check final values a == 11, b == 40
        assert!(*(&a) == 11, 1);
        assert!(*(&b) == 40, 2);
    }
}


//# run 0xCAFE::MutRefModifier::test_modify_values


// Featurres:
// bbcccbc4659f172bf2ae5b3ed655a964: Define new struct types with unique names and associated definitions.
// e6d19f25828c485cf6faa0485162493f: Test that the functions correctly assign and multiply values based on conditional logic and invoke the bar function accordingly.
// 00da5ab232a23d40c449291ca6d305fc: Test that mutable references can be passed to functions and correctly modify variables, with assertions verifying the expected final values.
