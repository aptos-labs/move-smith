// This transactional test exercises:
// 1. Expression termination with else, }, ), ,, :, ; 
// 2. Move compiler function checking in module
// 3. Block-expressions with assignments and side effects

// Addresses
// 0xCAFE is used as the publishing address
// 0xBEEF used as a test user/signer


//# publish
module 0xCAFE::ExprEndings {
    // Struct for storing test values
    struct Tester { value: u64 has copy, drop }
    
    // Helper: returns the sum of two numbers
    public fun add(x: u64, y: u64): u64 {
        x + y // 1: Terminated by function body close }
    }
    
    // Helper: tests expression with else, }, ), ,, :, and ;
    public fun test_term(x: u8): u64 {
        let res = if (x == 0) {
            42
        } else {
            17
        };  // 2: Proper; termination after if..else
        res // ended by close }
    }
    
    // Helper: test block expression in argument (side effect: modifies 'value')
    fun block_in_arg(t: &mut Tester): u64 {
        add(10, {
            t.value = 123;
            t.value
        })
        // Body ends with ) after block expression
    }

    // Helper: test block expression as a statement expression body
    public fun block_expr_in_body(): u64 {
        let mut sum = 0u64;
        let x = {
            let z = 5;
            sum = sum + z; // Side effect
            z + 6
        }; // 3: Whole block expr assigned to x
        sum + x
    }
    
    // Used for testing block expressions that return via ;
    public fun semicolon_block(): u64 {
        let val = {
            999u64;
        }; // val is set to (), not u64 (so will fail if not ended correctly)
        1 // just to test parsing
    }
    
    // Runner function: covers the above helpers
    public fun run_all() {
        let t = Tester { value: 0 };
        let mut t2 = t;
        
        // Testing termination in function call argument (block expr)
        let _r1 = block_in_arg(&mut t2); // ends with )
        
        // Testing test_term with else handling
        let _r2 = test_term(0);
        let _r3 = test_term(7);

        // Testing block expr in body
        let _r4 = block_expr_in_body();

        // The next line intentionally triggers a type error if semicolon rule violated
        let _r5 = semicolon_block(); // Expect no parse error
    }
}
//# run 0xCAFE::ExprEndings::run_all --signers 0xBEEF


//# publish
module 0xCAFE::CallExpr {
    // Calls ExprEndings::test_term through different expression endings
    public fun test_calls(): u64 {
        // Terminating with commas, colons, semicolons
        let a = 0xCAFE::ExprEndings::test_term(0),
            b = 0xCAFE::ExprEndings::test_term(1);
        let arr: (u64, u64) = (a, b); // tuple terminated by ) and ;
        arr.0 + arr.1 // ended by }
    }
    // runner function
    public fun run_calls() {
        let r = test_calls();
        let _d = r;
    }
}
//# run 0xCAFE::CallExpr::run_calls --signers 0xBEEF

//# run
script {
    use 0xCAFE::ExprEndings;
    use 0xCAFE::CallExpr;

    fun main(account: signer) {
        // Test block as argument in script
        let x = ExprEndings::block_expr_in_body();
        let y = CallExpr::test_calls();
        let z = if (x > 0) { y } else { x };
        let sum = x + y + z;

        // Test terminating expressions in multi-variable assignment
        let (a, b): (u8, u8) = (1, 2);

        // Test block expressions nested in assignment
        let block = {
            let q = 5;
            q + 9
        };

        let _result = sum + (block as u64);
    }
}

// Featurres:
// f900b94dca53be25721b14907d8740c3: Terminate expressions with tokens such as else, }, ), ,, :, or ; to indicate the end of an expression in your Move code.
// 0374e97dd2a856420c4b5b0bc9d974d5: Implement functions in target modules to ensure they are subject to the move compiler checks.
// 50f685f669ac3fea09867583a94ace9d: Test that block expressions with assignments and side effects are correctly evaluated in function arguments and expression bodies.
