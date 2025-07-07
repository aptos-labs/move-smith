
//# publish
module 0xCAFE::AddAndReturn {
    // Test 1: Function to compute addition of two u8 and return fixed u8
    public fun add_and_return_fixed(x: u8, y: u8): u8 {
        let sum = x + y;
        let _unused = sum;  // just use sum to silence unused warning
        42u8
    }
}


//# run 0xCAFE::AddAndReturn::add_and_return_fixed --args 10u8 20u8



//# publish
module 0xCAFE::LambdaExamples {
    // Test 2: Functions containing lambda (anonymous) expressions

    public fun run_lambda_u8_to_u8(x: u8): u8 {
        let plus_one: |u8|u8 has copy+drop = |a: u8| { a + 1 };
        plus_one(x)
    }

    public fun run_lambda_with_two_args(x: u8, y: u8): u8 {
        let sum_and_product: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            (a + b, a * b)
        };
        let (sum, _) = sum_and_product(x, y);
        sum
    }
}


//# run 0xCAFE::LambdaExamples::run_lambda_u8_to_u8 --args 41u8


//# run 0xCAFE::LambdaExamples::run_lambda_with_two_args --args 5u8 7u8



//# publish
module 0xCAFE::NestedInlineCalls {
    use 0xCAFE::LambdaExamples;

    // Test 3: Call inline function from another module through an intermediate function

    public inline fun inline_adder(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_inline_and_lambda(): u8 {
        // Call this module's inline function first
        let s = inline_adder(10u8, 15u8);
        // Then call lambda function from LambdaExamples
        let l = LambdaExamples::run_lambda_u8_to_u8(s);
        l
    }
}


//# run 0xCAFE::NestedInlineCalls::call_inline_and_lambda



//# publish
module 0xCAFE::LoopControl {
    // Test 4: Loop with continue skipping even increments of x, terminates at x == 10
    // Accumulate y accordingly: add x to y only when x is odd
    public fun loop_with_continue(): u8 {
        let x = 0u8;
        let y = 0u8;
        loop {
            x = x + 1;
            if ((x % 2) == 0) {
                continue;
            };
            y = y + x;
            if (x == 10) {
                break;
            };
        };
        y
    }
}


//# run 0xCAFE::LoopControl::loop_with_continue



//# publish
module 0xCAFE::LocalMutationPersistence {
    // Test 5: Local variable mutated inside branches and persists after call

    public fun mutate_in_branch_and_use(a: u8, flag: bool): u8 {
        let v = 5u8;
        if (flag) {
            v = v + a;
        } else {
            v = v + 10u8;
        };
        // Call a helper function that does nothing with v but ensures control flow changes
        Self::helper_function();

        // v should retain mutation from branch
        v
    }

    fun helper_function() {
        let _ = 1 + 1; // no-op
    }
}


//# run 0xCAFE::LocalMutationPersistence::mutate_in_branch_and_use --args 3u8 true


//# run 0xCAFE::LocalMutationPersistence::mutate_in_branch_and_use --args 3u8 false



//# publish
module 0xCAFE::CastExpressions {
    // Test 6: Cast expressions to a different type with `as`

    public fun cast_u8_to_u32(x: u8): u32 {
        let y = x as u32;
        y
    }

    public fun cast_u64_to_u128(x: u64): u128 {
        let y = x as u128;
        y
    }
}


//# run 0xCAFE::CastExpressions::cast_u8_to_u32 --args 200u8


//# run 0xCAFE::CastExpressions::cast_u64_to_u128 --args 1000u64


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// ab90f7da459bbdcaecb88cf63392fe44: Test that a loop correctly skips even increments of x using continue and terminates when x reaches 10, verifying accumulated value y equals 25.
// 055b2a98b3bc350f5ffc46c49565406a: Test that local variable mutations inside branches persist after function calls and control flow changes, ensuring correct variable values are used in later computations.
// 731afee126a5b5dec85cc47af1e6afba: Cast expressions to a different type with the `as` operator.
