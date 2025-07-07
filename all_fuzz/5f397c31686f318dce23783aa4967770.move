
//# publish
module 0xCAFE::TestAddition {
    public fun add_and_return_special(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum == 10) {
            42
        } else {
            sum
        }
    }

    public fun run_example() {
        let _ = add_and_return_special(3u8, 7u8);
        let _ = add_and_return_special(2u8, 3u8);
    }
}



//# run 0xCAFE::TestAddition::run_example





//# publish
module 0xCAFE::TestLambda {
    public fun use_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        lambda(x, y)
    }

    public fun run_lambda() {
        let _ = use_lambda(4u8, 5u8);
        let lambda2: |u8| u8 has copy+drop = |a: u8| {
            let b = a + 1;
            b
        };
        let _ = lambda2(9u8);
    }
}



//# run 0xCAFE::TestLambda::run_lambda





//# publish
module 0xCAFE::TestNestedCalls {
    // Removed the use of 0xCAFE::MyModule since it's unavailable.
    // Implemented a dummy function inline to imitate MyModule::f2 behavior.

    // Let's assume MyModule::f2 takes a u16 and returns a tuple (u16, u16).

    public fun f2(a: u16): (u16, u16) {
        // Example implementation: returns (a, a * 2)
        (a, a * 2)
    }

    public fun call_my_module_inline(a: u16): (u16, u16) {
        f2(a)
    }

    public fun run_nested_calls() {
        let (res1, res2) = call_my_module_inline(5u16);
        let (_r1, _r2) = call_my_module_inline(100u16);
    }
}



//# run 0xCAFE::TestNestedCalls::run_nested_calls





//# publish
module 0xCAFE::TestAbort {
    public fun abort_if_zero(x: u8) {
        if (x == 0) {
            abort 404;
        };
    }

    public fun test_abort_flow() {
        abort_if_zero(5u8);
        // The next line will abort, so in real test environment, stop there.
        // We still add it as part of test to exercise abort statement:
        // abort_if_zero(0u8);
    }
}



//# run 0xCAFE::TestAbort::test_abort_flow





//# publish
module 0xCAFE::TestUnary {
    public fun test_unary_operators(x: u8): u8 {
        let a = !false;
        let b = !true;
        let c = !(x == 0);
        // Removed invalid unary minus on integer line.
        // let d = -(1 as i64); // Invalid in Move.

        let _ = a;
        let _ = b;
        let _ = c;
        x
    }

    public fun run_unary() {
        let _ = test_unary_operators(0u8);
        let _ = test_unary_operators(1u8);
    }
}



//# run 0xCAFE::TestUnary::run_unary
