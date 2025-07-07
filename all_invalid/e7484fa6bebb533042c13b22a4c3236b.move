//# publish
module 0xCAFE::PatternAndTupleTest {
    // Test 1: Pattern matching with '..' (rest pattern) in struct and tuple

    struct TestStruct has copy, drop, store, key {
        a: u8,
        b: u64,
        c: u8,
    }

    // Test 2: Tuple assignment evaluates RHS in order and applies side effects
    fun get_and_inc(x: &mut u8): u8 {
        let orig = *x;
        *x = *x + 1;
        orig
    }

    /// Only visible inside the package
    package fun package_visible_fun(): u64 {
        0xC0FFEE_u64
    }

    public fun runner_pattern_match() {
        // tuple with destructuring using '..'
        let tup = (1u8, 2u8, 3u8, 4u8, 5u8);

        // Use .. to capture the rest in match
        let result = match tup {
            (first, .., last) => first + last,
        };
        // result == 1u8 + 5u8 == 6u8

        // Struct destructuring with .. pattern (rest)
        let s = TestStruct { a: 10, b: 20, c: 30 };
        let TestStruct { a, .. } = s;
        // a == 10, fields b & c ignored

        // Tuple assignment: side effects strictly in order
        let mut n: u8 = 5;
        let (x, y, z) = (get_and_inc(&mut n), get_and_inc(&mut n), get_and_inc(&mut n));
        // After each call, n is incremented
        // x = 5, n=6; y=6, n=7; z=7, n=8

        // Use package visibility
        let pkg_val = package_visible_fun();

        // Consume values to avoid 'unused' warning
        let _ = (result, a, x, y, z, pkg_val);
    }
}
//# run 0xCAFE::PatternAndTupleTest::runner_pattern_match

//# run
script {
    use 0xCAFE::PatternAndTupleTest;
    fun main() {
        PatternAndTupleTest::runner_pattern_match();
    }
}

// Featurres:
// e72b84369c14a4151f7774ba67c20ab9: Use '..' as a pattern in move match expressions or pattern matching syntax to specify a range or destructuring pattern.
// 60f333db7c7503260de5d68ebfe55f5d: Test that each element of a tuple assignment evaluates its right-hand side expression in order and with side-effects applied sequentially.
// c18dac7d43bc42e327a1c7901863c555: Use 'package' visibility for functions accessible only within the same package.
