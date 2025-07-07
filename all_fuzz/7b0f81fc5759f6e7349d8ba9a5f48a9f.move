
//# publish
module 0xCAFE::LambdaTest {
    // Simple addition function returns sum + 10
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    // Function with a lambda that doubles input and adds a fixed offset
    public fun lambda_compute(x: u8): u8 {
        let double_and_add = |n: u8| {
            let doubled = n + n;
            doubled + 3
        };
        double_and_add(x)
    }

    // Inline function to add two u8 numbers, returns a tuple (sum, sum+1)
    public inline fun inline_add(a: u8, b: u8): (u8, u8) {
        let s = a + b;
        (s, s + 1)
    }

    // Function calling inline_add() and using its return values
    public fun call_inline_and_process(a: u8, b: u8): u8 {
        let (x, y) = inline_add(a, b);
        // Return x + y
        x + y
    }

    // Function testing local variable mutation across control flow
    public fun local_var_mutation(flag: bool): u8 {
        let x = 5;
        if (flag) {
            let x = x + 10;
            // shadowed x now
            // don't need the redundant `let x = x;`
            let y = add_and_offset(x, 1);
            y
        } else {
            let x = x + 20;
            // shadowed x now
            // don't need the redundant `let x = x;`
            let y = add_and_offset(x, 1);
            y
        }
    }

    /// Tests consume_token builtin to consume and verify tokens
    /// Since we can't demonstrate parsing here, we simulate a consume_token call with argument 'token'
    /// This function just returns the argument as a placeholder for consume_token check
    public fun test_consume_token(token: u8): u8 {
        // Imagine consume_token(token);
        token
    }
}
