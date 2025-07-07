
//# publish
module 0xCAFE::TestLambdaAdd {
    // Test lambda expressions and addition of two u8 values

    public fun add_two_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun lambda_add(a: u8, b: u8): u8 {
        let adder: |u8, u8|u8 has copy+drop = |x: u8, y: u8| { x + y };
        adder(a, b)
    }

    public fun multiple_lambdas(a: u8, b: u8): u8 {
        let adder: |u8, u8|u8 has copy+drop = |x: u8, y: u8| { x + y };
        let doubler: |u8|u8 has copy+drop = |x: u8| { x * 2 };
        let s = adder(a, b);
        let d = doubler(s);
        d
    }
}


//# run 0xCAFE::TestLambdaAdd::add_two_u8 --args 7u8 8u8


//# run 0xCAFE::TestLambdaAdd::lambda_add --args 12u8 13u8


//# run 0xCAFE::TestLambdaAdd::multiple_lambdas --args 3u8 4u8



//# publish
module 0xCAFE::NestedBlockCalc {
    // Test nested blocks and updating local variable through multiple additions

    public fun test(): u8 {
        let x = 0u8;

        {
            // first block
            let x = x + 1;
            {
                // nested block 1
                let x = x + 2;
                {
                    // nested block 2
                    let x = x + 3;
                    x
                };
                x
            };
            x
        };

        let x = x + 6;

        // To check that x was properly updated only last assignment counts
        // The above block variables are shadowing and local within those blocks,
        // the final x after all blocks gets incremented by 6 from 0.
        x
    }
}


//# run 0xCAFE::NestedBlockCalc::test


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// c62dbd6be226b5b2dee3cf602a539e0c: Test that the `test` function correctly performs nested block calculations and updates the local variable `x` through multiple additions, ensuring proper handling of multiple nested blocks and variable assignments within a Move module.
