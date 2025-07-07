//# publish
module 0xabcde::test_module {
    // Function that reassigns a local mutable variable and returns it
    public fun update_and_return(): u64 {
        let mut counter = 10;
        if (true) {
            counter = 20;
        } else {
            counter = 30;
        }
        counter
    }

    // Function to check the result of update_and_return
    public fun check_update() {
        assert!(update_and_return() == 20, 42);
    }

    // Function that exercises nested if-else branches and reaches an assertion with an uninitialized variable
    public fun nested_if_uninit() {
        let y;
        if (false) {
            if (true) {
                // do nothing
            } else {
                // do nothing
            }
        } else {
            y = 5;
        };
        // y should be initialized if else branch is taken, otherwise uninitialized
        assert!(y == 5, 99);
    }

    // Function that hoists the nested if-else logic for testing purposes
    public fun run_tests() {
        check_update();
        nested_if_uninit();
    }
}

//# run 0xabcde::test_module::run_tests --signers 0xABC --args