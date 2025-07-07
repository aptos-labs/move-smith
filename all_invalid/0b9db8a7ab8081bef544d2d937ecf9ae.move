//# publish
module 0xCAFE::PatternAndTupleTest {
    // Test 1: Simulated pattern matching and tuple destructuring (no '..' support)

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
        // Simulate destructuring tuple (no match or '..' support in Move as of Aptos 2024-06)
        let tup = (1u8, 2u8, 3u8, 4u8, 5u8);
        // Manually calculate first + last
        let first = tup.0;
        let last = tup.4;
        let result = first + last;

        // Struct destructuring: available for own structs, can ignore some fields
        let s = TestStruct { a: 10, b: 20, c: 30 };
        let TestStruct { a, b: _, c: _ } = s;

        // Tuple assignment: side effects strictly in order
        let mut n: u8 = 5;
        let x = get_and_inc(&mut n); // x = 5, n = 6
        let y = get_and_inc(&mut n); // y = 6, n = 7
        let z = get_and_inc(&mut n); // z = 7, n = 8

        let pkg_val = package_visible_fun();

        let _ = (result, a, x, y, z, pkg_val);
    }
}

//# run 0xCAFE::PatternAndTupleTest::runner_pattern_match --signers 0xCAFE

//# run
script {
    use 0xCAFE::PatternAndTupleTest;
    fun main(account: signer) {
        PatternAndTupleTest::runner_pattern_match();
    }
}