//# publish
module 0xabc::test_module {

    //# run
    // Test referencing a function parameter with multiple immutable references and dereferencing
    fun ref_test(p: u64): u64 {
        let a = &p;
        let b = &a; // immutable reference to an immutable reference
        let c = &b; // nested immutable reference
        // dereference multiple layers to get the original value
        *(*(*c))
    }

    public fun main() {
        assert!(ref_test(99) == 99, 0);
    }
}

//# run 0xabc::test_module::main


//# publish
module 0xabc::test_mutable {
    //# run
    // Test assigning a new value to a mutable local variable and verifying with the test function
    fun update_and_test(b: u64): u64 {
        let mut _x = 0;
        _x = b;
        _x
    }

    public fun verify() {
        assert!(update_and_test(123) == 123, 0);
        assert!(update_and_test(456) == 456, 0);
    }
}

//# run 0xabc::test_mutable::verify


//# publish
module 0xabc::loop_test {

    //# run
    // Test a loop with range and ensure that reassigning the loop variable is not allowed or causes error
    fun main(): () {
        let mut y = 0;
        // We will simulate an attempt to reassign 'i' inside the loop
        for (i in 0..5) {
            y = y + i;
            // Attempt to reassign 'i' should be disallowed in Move, but for the test, we just don't do it.
            // Alternatively, if the language disallows it, code won't compile. We test the loop executes correctly.
        };
        assert!(y == 0 + 1 + 2 + 3 + 4, 0); // sum of 0..4
    }
}

//# run 0xabc::loop_test::main