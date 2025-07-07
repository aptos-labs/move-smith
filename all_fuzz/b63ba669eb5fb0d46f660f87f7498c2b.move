
//# publish
module 0xCAFE::MathOps {
    // A module to test addition and lambda expressions.

    // A simple addition function f_add that sums two u8 values and returns 42.
    public fun f_add(a: u8, b: u8): u8 {
        let c = a + b;
        // return a fixed value 42 after addition (tests arithmetic and return)
        42
    }

    // A function with lambda expression that adds two u8 numbers and returns their sum.
    // The lambda captures nothing but takes two u8s and returns their sum.
    public fun lambda_add(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }

    // A function that returns a closure capturing an internal u8.
    public fun make_closure(x: u8): |u8| u8 has copy+drop {
        // Closure that captures x and adds it to y
        // Correct syntax: use |y: u8| { x + y }
        let closure: |u8| u8 has copy+drop = |y: u8| {
            x + y
        };
        closure
    }

    // A runner function invoking closure with argument.
    public fun call_closure() : u8 {
        let c = make_closure(10u8);
        c(5u8)
    }
}



//# run 0xCAFE::MathOps::f_add --args 20u8 22u8



//# run 0xCAFE::MathOps::lambda_add --args 15u8 27u8



//# run 0xCAFE::MathOps::call_closure



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::MathOps;

    // Function calls inline function from MathOps and performs nested call
    public fun nested_call(a: u8, b: u8): u8 {
        // Call lambda_add from MathOps inline, which itself calls a lambda internally
        let sum = MathOps::lambda_add(a, b);
        // Return sum + fixed offset 10
        sum + 10u8
    }

    // Runner function to invoke nested_call with sample arguments
    public fun runner(): u8 {
        nested_call(5u8, 7u8)
    }
}



//# run 0xCAFE::InlineCaller::nested_call --args 30u8 12u8



//# run 0xCAFE::InlineCaller::runner



//# publish
module 0xCAFE::SpecInline {
    /// A function that can be inlined and has a spec attached (hypothetically).
    /// Maybe this function's body is reachable.
    /// Spec function is a placeholder since specs are not executable code.
    public fun maybe_inlined_function(x: u8, y: u8): u8 {
        100u8 + x + y
    }

    // Runner function to call maybe_inlined_function
    public fun test_maybe(): u8 {
        // maybe is used to indicate possible reachability.
        // here we call maybe_inlined_function with 1 and 2
        let result = maybe_inlined_function(1u8, 2u8);
        result
    }
}



//# run 0xCAFE::SpecInline::maybe_inlined_function --args 3u8 4u8



//# run 0xCAFE::SpecInline::test_maybe



//# publish
module 0xCAFE::ClosureTests {
    // Tests defining closures with various params, captures, and argument passing.

    public fun closure_no_capture(x: u8): u8 {
        let c: |u8| u8 has copy+drop = |y: u8| {
            y * 2u8
        };
        c(x)
    }

    public fun closure_with_capture(x: u8): u8 {
        // Correct syntax: |y: u8| { x + y }
        let c: |u8| u8 has copy+drop = |y: u8| {
            x + y
        };
        c(10u8)
    }

    public fun closure_nested_call(x: u8, y: u8): u8 {
        let inner: |u8| u8 has copy+drop = |z: u8| { z + 5u8 };
        let outer: |u8| u8 has copy+drop = |w: u8| {
            inner(w) + x + y
        };
        outer(3u8)
    }

    // Runner to invoke all closures
    public fun run_all(): (u8, u8, u8) {
        let a = closure_no_capture(4u8);
        let b = closure_with_capture(7u8);
        let c = closure_nested_call(1u8, 2u8);
        (a, b, c)
    }
}



//# run 0xCAFE::ClosureTests::closure_no_capture --args 8u8



//# run 0xCAFE::ClosureTests::closure_with_capture --args 5u8



//# run 0xCAFE::ClosureTests::closure_nested_call --args 2u8 3u8



//# run 0xCAFE::ClosureTests::run_all
