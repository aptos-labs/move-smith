//# publish
module 0xCAFE::AbilityConstraints {
    use std::signer;

    struct KeyValuePair<K: copy + drop + store, V: store> has key, store {
        key: K,
        value: V
    }

    struct Container<T: copy + store> has store {
        item: T
    }

    public fun create_pair<K: copy + drop + store, V: store>(key: K, value: V): KeyValuePair<K, V> {
        KeyValuePair<K, V> { key, value }
    }

    public fun create_container<T: copy + store>(item: T): Container<T> {
        Container<T> { item }
    }

    // Function with abort keyword used
    public fun abort_if_zero(x: u64) {
        if (x == 0) {
            abort 100; // Abort with code 100 if x == 0
        } else {
            let _y = x;
        };
    }

    // Function demonstrating break and continue in loop
    public fun loop_break_continue(x: u8): u8 {
        let mut res = 0u8;
        loop {
            if (res == x) {
                break;
            };
            res = res + 1;
            if (res % 2 == 0) {
                continue;
            };
            res = res + 1;
        };
        res
    }

    // Demonstrate move, copy, as, and else usage
    struct MoveCopyAs has store {
        val: u8
    }

    public fun create_move_copy_as(val: u8): MoveCopyAs {
        let obj = MoveCopyAs { val };
        obj
    }

    public fun test_move_copy_as() {
        let obj1 = create_move_copy_as(10);
        let obj2 = copy obj1; // copy ability use
        let obj3 = obj1; // move occurs here
        let x = obj3.val as u64;
        let y = if (x > 5) {
            x
        } else {
            0
        };
        let _unused = y;
    }
}

//# run 0xCAFE::AbilityConstraints::abort_if_zero --args 1u64

//# run 0xCAFE::AbilityConstraints::loop_break_continue --args 5u8

//# run 0xCAFE::AbilityConstraints::test_move_copy_as


//# publish
module 0xCAFE::ProgramWithTests {
    use std::assert;

    // Program function to include modules with unit tests only
    // This is a zero function just to exercise `program` keyword usage.
    program;

    // Example unit test function
    #[test_only]
    public fun unit_test_addition() {
        let a = 2u8;
        let b = 3u8;
        let c = a + b;
        assert!(c == 5u8, 101);
    }

    #[test_only]
    public fun unit_test_loop() {
        let mut count = 0u8;
        while (count < 3u8) {
            count = count + 1;
        };
        assert!(count == 3u8, 102);
    }

    #[test_only]
    public fun unit_test_if_else() {
        let flag = true;
        let res = if (flag) {
            1u8
        } else {
            2u8
        };
        assert!(res == 1u8, 103);
    }
}

//# run 0xCAFE::ProgramWithTests::unit_test_addition

//# run 0xCAFE::ProgramWithTests::unit_test_loop

//# run 0xCAFE::ProgramWithTests::unit_test_if_else

// Featurres:
// 9913fee717d4d1dd0dd2683b4bd7e734: Write Move code using keywords such as abort, acquires, as, break, const, continue, copy, else, false, fun, friend, if, invariant, let, loop, inline, module, move, native, public, return, script, spec, struct, true, use, and while.
// 1f1e15d73a91ef2d9e16f4165568f8a3: Include ability constraints in type parameter declarations to enforce capabilities.
// 058e92738ebd925faf5d4e91c73f76c1: Leverage the `program` function to include only modules with unit tests in the final program for testing purposes.
