//# publish
module 0xCAFE::TestAbortAndInline {
    use std::abort;
    use std::error;

    // Define custom abort states for demonstration
    const E_FAIL: u64 = 0;
    const E_CHECK_FAIL: u64 = 1;

    // Custom abort function with abort state
    public fun abort_with_state(code: u64) {
        abort::abort_with_error_code(code);
    }

    // Function with abort state annotation 
    public fun check(value: u8) {
        if (value > 10) {
            // abort with a custom abort state annotation (simulated by error_code)
            // If abort was annotated, in Move test framework it would show E_CHECK_FAIL
            abort_with_state(E_CHECK_FAIL);
        }
    }

    // Nested inline functions that apply f2 then f1
    public inline fun f1(x: u8): u8 {
        x + 2 as u8
    }

    public inline fun f2(x: u8): u8 {
        x * 3 as u8
    }

    public fun nested_calls(): u8 {
        // Apply f2 to 3 then f1 to the result: f1(f2(3)) = f1(9) = 9 + 2 = 11
        let intermediate = f2(3);
        f1(intermediate)
    }

    // Function returning unit type explicitly
    public fun return_unit(): () {
        // no-op, just returns unit
    }
}
//# run 0xCAFE::TestAbortAndInline::nested_calls
//# run 0xCAFE::TestAbortAndInline::return_unit

//# run
script {
    use 0xCAFE::TestAbortAndInline;

    fun main() {
        // This should run without aborts because 5 <= 10
        TestAbortAndInline::check(5);

        // This should abort with E_CHECK_FAIL (abort code 1 if uncommented)
        // TestAbortAndInline::check(11);

        // Nested calls should return 11 (no return print, just execution)
        let val = TestAbortAndInline::nested_calls();

        // Return unit explicitly called
        TestAbortAndInline::return_unit();

        // To avoid unused variable warning, just use val in a dummy if
        if (val == 11) {
            // no-op
        }
    }
}

// Featurres:
// 6f89c2ca9e1261b1efb2c7251ef3af4f: Use custom abort state annotations to format and display the abort state of functions at desired points in Move code
// cc8c69755e71ae8b32b329d7d21583ea: Test that the nested inline functions in the module correctly compute the value by applying f2 to 3 and then passing the result to f1, resulting in the correct final output.
// 59d0366e034fa8533bb30a594ea89ad2: Use unit type as a value.
