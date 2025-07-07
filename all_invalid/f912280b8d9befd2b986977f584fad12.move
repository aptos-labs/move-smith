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
    struct MoveCopyAs has copy, drop, store {
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