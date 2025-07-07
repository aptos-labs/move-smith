//# publish
module 0xCAFE::OverflowTest {
    use std::vector;
    use std::error;

    // A function that aborts on overflow when adding vector elements
    public fun test_overflow(): u8 {
        let v = vector::empty<u8>();
        vector::push_back(&mut v, 200u8);
        vector::push_back(&mut v, 100u8);
        // This addition should overflow u8 and cause abort
        let _ = vector::borrow(&v, 0) + vector::borrow(&v, 1);
        0
    }

    // A function that divides elements of a vector, aborting on division by zero
    public fun test_div_by_zero(): u64 {
        let v = vector::empty<u64>();
        vector::push_back(&mut v, 10u64);
        vector::push_back(&mut v, 0u64);
        let x = vector::borrow(&v, 0);
        let y = vector::borrow(&v, 1);
        let _ = *x / *y; // Should abort for divide by zero
        0
    }

    // A function that shifts a vector element out of range
    public fun test_shift_out_of_range(): u8 {
        let v = vector::empty<u8>();
        vector::push_back(&mut v, 7u8);
        let val = vector::borrow(&v, 0);
        // Shift left by 100 is out of range for u8, abort expected
        let _ = *val << 100;
        0
    }

    // Runner function that does nothing - for manual run commands
    public fun runner() {}
}

//# run 0xCAFE::OverflowTest::runner

//# publish
module 0xCAFE::FuncParamTest {
    // A function that accepts another function as a parameter and calls it twice
    public fun call_twice(f: fun(u64): u64, x: u64): u64 {
        let first = f(x);
        let second = f(x + 1);
        first + second
    }

    // Runner that calls call_twice with an inline anonymous function that doubles the input
    public fun runner(): u64 {
        call_twice(
            fun (y: u64): u64 {
                y * 2
            },
            10
        )
    }
}

//# run 0xCAFE::FuncParamTest::runner

//# publish
module 0xCAFE::AbortShortCircuit {
    use std::error;

    // A function that always aborts
    public fun always_abort(): u64 acquires T {
        abort 100;
        0
    }

    // A function that tests that rhs of plus is not executed if lhs aborts
    public fun test_short_circuit(): u64 {
        let x = {
            // lhs aborts
            always_abort() + aborting_rhs()
        };
        0
    }

    // rhs should abort with code 101 to detect if executed
    public fun aborting_rhs(): u64 {
        abort 101;
        0
    }

    // Runner function that runs test_short_circuit, expecting abort 100 from lhs
    public fun runner() {
        test_short_circuit();
    }
}

//# run 0xCAFE::AbortShortCircuit::runner

// Featurres:
// 7a24b3028aed0d75386b5a5f74f23b22: Verify that the Move program's vector element expressions that involve overflows, divisions by zero, or out-of-range shifts correctly cause aborts during execution.
// 963ab02ce5f0914f7386f6d2ef6ed632: Test that functions accepting function parameters (like closures/lambdas) work correctly when passed inline anonymous functions.
// e58fda593fcb750ab8d7a0981a783de9: Test that the right-hand side of a plus expression is not executed if the left-hand side aborts inside a block.
