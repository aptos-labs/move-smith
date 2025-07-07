
//# publish
module 0xCAFE::TestModule {
    // Module to test variable assignments, scoping, internal visibility, and script execution
    
    use std::signer;
    use std::vector;

    // A private function to test internal visibility restriction
    fun internal_no_access() {
        // do nothing
    }

    // Public function to be called from test scripts
    public fun get_value(): u64 {
        42u64
    }

    // Function with variable shadowing in a loop
    public fun shadowing_in_loop(init: u64): u64 acquires {} {
        let sum = init;
        let shadow_var = 0u64;
        let i = 0u64;
        while (i < 3u64) {
            let shadow_var = i; // Shadowing variable
            sum = sum + shadow_var;
            i = i + 1;
        };
        sum
    }

    // Function that assigns variables inside and outside loops,
    // testing scope and shadowing
    public fun variable_assignments(x: u64): (u64, u64) {
        let a = 10u64;
        let b = 20u64;
        let i = 0u64;
        while (i < 2u64) {
            let a = i; // shadow inside loop
            b = b + a;
            i = i + 1;
        };
        (a, b)
    }

    // Function that attempts to access a private function (should be compile-time error if outside)
    // To test visibility restrictions, we do not expose 'internal_no_access'.
    // Therefore, we will test that calling it externally is prevented (but here, it's internal only).
    public fun call_internal() {
        internal_no_access()
    }

    // Function binding to expression results
    public fun binding_test(x: u64, y: u64): (u64, u64) {
        let sum_expr = x + y;
        let prod_expr = x * y;
        (sum_expr, prod_expr)
    }

    // Function to run internal variable scope with nested loops
    public fun nested_scope_test(): (u64, u64) {
        let outer = 0u64;
        let inner = 0u64;
        for i in 0..3 {
            let outer = i; // shadow outer
            for j in 0..2 {
                let inner = j; // shadow inner
            };
        };
        (outer, inner)
    }
}


//# run 0xCAFE::TestModule::shadowing_in_loop --args 0u64

//# run 0xCAFE::TestModule::variable_assignments --args 5u64

//# run 0xCAFE::TestModule::binding_test --args 7u64 8u64

//# run 0xCAFE::TestModule::nested_scope_test

// Scripts to test execution flow and variable states

//# run
script {
    // Test shadowing within a loop
    let val = 0u64; 
    let result = 0u64;
    let result = 0u64;
    
    let result = {
        let res = 0u64;
        let sum = 0u64;
        let i = 0u64;
        while (i < 4u64) {
            let shadow_var = i; // shadow variable
            sum = sum + shadow_var;
            i = i + 1;
        };
        sum
    };
    // Expect result = 0+1+2+3=6
}

//# run
script {
    // Test variable shadowing and assignments
    let (a, b) = {
        let a = 0u64;
        let b = 0u64;
        let i = 0u64;
        while (i < 2u64) {
            let a = i; // shadow a
            b = b + a;
            i = i + 1;
        };
        (a, b)
    };
    // Expect a = 0 (outer), b = 0+0+1=1
}

//# run
script {
    // Test binding expression results
    let sum_result = {
        let s = 7u64 + 8u64;
        s
    };
    let prod_result = {
        let p = 7u64 * 8u64;
        p
    };
    (sum_result, prod_result)
    // Expect (15, 56)
}

//# run
script {
    // Test nested scope handling in loops
    let (outer_bound, inner_bound) = {
        let outer = 0u64;
        let inner = 0u64;
        for i in 0..3 {
            let outer = i; // shadow outer
            for j in 0..2 {
                let inner = j; // shadow inner
            };
        };
        (outer, inner)
        // Expect outer = 0 (outermost variable), inner = 0 (initial, unmodified)
    };
    (outer_bound, inner_bound)
}


// Featurres:
// 5941dd503b9dcc73e363012d080654d1: Treat the entire program as a target for comprehensive analysis.
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// caa4ab8a3e36141117c8c50d0a12748d: Specify global or local variables in specifications.
// b97f161fc46919e92f4e2b88ea9444ff: Bind variables to the result of expressions
// 82f755af6a64ca1b7520a8282c6064dc: Define scripts using the 'script' keyword in Move files.
