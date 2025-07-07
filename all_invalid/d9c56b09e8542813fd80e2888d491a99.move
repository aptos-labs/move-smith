
//# publish
module 0xDEAD::OptionalTypeTest {
    use std::vector;

    struct Wrapper<T> has copy, drop, store {
        value: T
    }

    public fun run_tests() {
        test_optional_type_argument();
        test_variable_assignments_in_branches();
        test_variable_shadowing_with_lambda();
    }

    fun test_optional_type_argument() {
        // Using struct with optional type argument (simulate optional by tagging with option)
        let some_value = Wrapper<Option<u8>> { value: Option::some(42u8) };
        let none_value = Wrapper<Option<u8>> { value: Option::none() };
    }

    fun test_variable_assignments_in_branches() {
        let x: u64;
        let flag = true;
        if (flag) {
            let y = 100u64;
            x = y;
        } else {
            let y = 200u64;
            x = y;
        }; // End of if-else statement with semicolon
        // "x" assigned in both branches, test that compilation allows that
    }

    fun test_variable_shadowing_with_lambda() {
        let outer_var = 10u8;
        let lambda: |u8| -> u8 = |outer_var: u8| {
            // Shadows outer "outer_var"
            outer_var + 5
        };
        let result = lambda(3u8);
        // "outer_var" from outer scope remains unchanged
    }
}



//# run 0xDEAD::OptionalTypeTest::run_tests


// Features:
// 9ffabee55ce5362d2c95f2f9158c196a: Use optional type arguments in type declarations
// 23358b71c0ef160b4e84c7f263291e48: Test variable assignment in both branches of an if-else statement with an uninitialized variable.
// 0a56f083963dc467bc4b9bdc1981a01a: Test that a variable declared outside a lambda can be assigned within the lambda even if the parameter name shadows the outer variable.
