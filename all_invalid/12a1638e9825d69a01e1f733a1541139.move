//# publish
module 0xCAFE::Disambiguation {
    // Test 1: Write type arguments with a space before the '<' when necessary
    public fun new_vector() {
        // Space before '<' to disambiguate from less-than operator
        let _v = std::vector::empty < u8 >();
    }

    public fun new_vector_with_value() {
        let mut v = std::vector::empty < u64 >();
        std::vector::push_back(&mut v, 42);
    }
}

//# publish
module 0xCAFE::MoveInIfTest {
    struct S has copy, drop, store {
        val: u8,
    }

    public fun test_move_in_if() {
        let s = S { val: 10u8 };
        if (false) {
            // This block does not execute, s is moved inside here if it were true
            let _s_moved = s;
            // _s_moved moved here, but block doesn't execute
        } else {
            // s is still available here
            let _val = s.val;
        };
    }
}

//# publish
module 0xCAFE::ReturnInWhileTest {
    public fun early_return(mut x: u8): u8 {
        while (x > 0) {
            return 42u8;
        };
        // This assert! must not execute because of the return above
        assert!(false, 99);
        0u8
    }
}

//# run 0xCAFE::Disambiguation::new_vector

//# run 0xCAFE::Disambiguation::new_vector_with_value

//# run 0xCAFE::MoveInIfTest::test_move_in_if

//# run 0xCAFE::ReturnInWhileTest::early_return --args 10u8

// Featurres:
// 75fff8fc3ba40c50396bcf7caeae5564: Write type arguments with a space before the '<' when necessary to disambiguate the '<' operator from a generic type parameter.
// 38732c4b046bb6326d7877e3a9d65e7f: Test that moving a value inside an if block that does not execute does not affect the value outside the block.
// eb861eb5a604a88b370ecc6d9cec784e: Test that a return statement inside a while loop prevents subsequent code, such as an assert! statement, from executing.
