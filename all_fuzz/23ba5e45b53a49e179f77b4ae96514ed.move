
//# publish
module 0xCAFE::Calculator {
    public fun add_two_values(x: u8, y: u8): u8 {
        let sum = x + y;
        let _ignore = sum; // binding to _ to ignore
        42u8
    }

    public fun run_lambda() {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let _result = lambda(10u8, 20u8);
    }

    public inline fun inline_adder(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::Calculator::add_two_values --args 5u8 7u8


//# run 0xCAFE::Calculator::run_lambda



//# publish
module 0xCAFE::ClosureTest {
    // Import Calculator to test cross-module inline call
    use 0xCAFE::Calculator;

    struct MutClosure has copy, drop {
        counter: u8,
        closure: |u8| u8
    }

    public fun call_inline_from_other_module(x: u8, y: u8): u8 {
        Calculator::inline_adder(x, y)
    }

    // Function illustrating wildcard binding in iteration
    public fun use_wildcard_match() {
        let v = vector[1u8, 2u8, 3u8];
        for (elem in v) {
            let _ignore = elem;
        };
    }

    public fun closure_with_capture(): u8 {
        let count = 0u8;
        let mut_closure: |u8| u8 has copy+drop = |inc: u8| {
            // capture and mutate local var
            let new_count = count + inc;
            count = new_count;
            count
        };
        let _ = mut_closure(1u8);
        let _ = mut_closure(2u8);
        count
    }
}


//# run 0xCAFE::ClosureTest::call_inline_from_other_module --args 13u8 29u8


//# run 0xCAFE::ClosureTest::use_wildcard_match


//# run 0xCAFE::ClosureTest::closure_with_capture


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// f86b02c97d995c7ef7900cd270b1c508: Bind values to a wildcard variable '_' in pattern matching or assignments to ignore them in Move programs
// b42bdfa8e959fb9435bc34a06c520c76: Test that closures can mutate and capture local variables across multiple calls within a function.
