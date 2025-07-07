
//# publish
module 0xCAFE::TestAddition {
    // This module tests addition of two u8 values before returning a specific value.

    public fun add_and_return_specific(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum == 42) {
            42
        } else {
            sum
        }
    }

    // Runner no-arg function
    public fun runner() {
        let _ = add_and_return_specific(20u8, 22u8);
        let _ = add_and_return_specific(10u8, 5u8);
    }
}




//# run 0xCAFE::TestAddition::runner




//# publish
module 0xCAFE::TestLambda {
    // This module tests lambda (anonymous function) expressions.

    public fun use_lambda(x: u8, y: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy + drop = |a: u8, b: u8| {
            let sum = a + b;
            let product = a * b;
            (sum, product)
        };
        lambda(x, y)
    }

    public fun runner() {
        let (_sum, _prod) = use_lambda(6u8, 7u8);
        let (_sum2, _prod2) = use_lambda(3u8, 4u8);
    }
}




//# run 0xCAFE::TestLambda::runner




//# publish
module 0xCAFE::TestInlineCall {
    use 0xCAFE::TestAddition;

    // Calls the inline add_and_return_specific function inside TestAddition module
    public fun call_inline_add(a: u8, b: u8): u8 {
        TestAddition::add_and_return_specific(a, b)
    }

    public fun runner() {
        let _ = call_inline_add(20u8, 22u8);
        let _ = call_inline_add(1u8, 2u8);
    }
}




//# run 0xCAFE::TestInlineCall::runner




//# publish
module 0xCAFE::TestWhileLoop {
    // Tests that while loop body won't run if condition is false at start

    public fun while_never_runs(start: u8): u8 {
        let x = start;
        while (x > 10) {
            // This body should not run if start <= 10
            x = x - 1;
        };
        x
    }

    public fun runner() {
        let x1 = while_never_runs(5u8); // loop won't run, x1 == 5
        let x2 = while_never_runs(15u8); // loop runs, x2 == 10
        // Just use variables to exercise code
        let _ = x1;
        let _ = x2;
    }
}




//# run 0xCAFE::TestWhileLoop::runner




//# publish
module 0xCAFE::TestOperators {
    use std::vector;

    // This module tests various operators in Move.

    public fun operator_tests(x: u8, y: u8): u8 {
        let r = 0u8;

        if (x == y) {
            r = r + 1;
        } else if (x != y) {
            r = r + 2;
        };

        if (x <= y) {
            r = r + 4;
        };

        if (x >= y) {
            r = r + 8;
        };

        let mask = 0x0fu8;
        mask = mask << 1; // use <<= not supported: expanded
        r = r + mask;

        let bits = 0xb0u8;
        bits = bits >> 4; // >>= operator expanded
        r = r + bits;

        let a = 7u8;
        a = a * 2; // *= operator expanded
        r = r + a;

        let b = 20u8;
        b = b / 4; // /= operator expanded
        r = r + b;

        let c = 5u8;
        c = c % 3; // %= operator expanded
        r = r + c;

        r = r ^ 3; // ^= operator expanded

        // Use range expression to iterate from 0 to 2 inclusive
        let sum = 0u8;
        let i = 0u8;
        while (i <= 2) {
            sum = sum + i;
            i = i + 1;
        };

        r = r + sum;

        // Using struct and module operator '::'
        let v = vector[1u8, 2u8, 3u8];
        let len = vector::length(&v);
        r = r + (len as u8);

        r
    }

    public fun runner() {
        let _result = operator_tests(5u8, 5u8);
    }
}




//# run 0xCAFE::TestOperators::runner
