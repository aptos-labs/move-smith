
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
    public fun shadowing_in_loop(init: u64): u64 {
        let sum = init;
        let shadow_var: u64;
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
        let i = 0u64;
        while (i < 3) {
            let outer = i; // shadow outer
            // For inner loop, use a for-like construct with while
            let j = 0u64;
            while (j < 2) {
                let inner = j; // shadow inner
                j = j + 1;
            };
            i = i + 1;
        };
        (outer, inner)
    }
}

// Below are the scripts for testing execution flow and variable states


//# run 0xCAFE::TestModule::shadowing_in_loop --args 0u64


//# run 0xCAFE::TestModule::variable_assignments --args 5u64


//# run 0xCAFE::TestModule::binding_test --args 7u64 8u64


//# run 0xCAFE::TestModule::nested_scope_test

// Scripts to test execution flow and variable states


//# run
script {
    // Test shadowing within a loop
    let result: u64;
    let sum = 0u64;
    let i = 0u64;
    while (i < 4u64) {
        let shadow_var = i; // shadow variable
        sum = sum + shadow_var;
        i = i + 1;
    };
    result = sum;
    // Expect result = 0+1+2+3=6
}


//# run
script {
    // Test variable shadowing and assignments
    let (a, b): (u64, u64);
    let outer_a = 0u64; // explicitly define outer outer variable
    let b_acc = 0u64;
    let i = 0u64;
    while (i < 2u64) {
        let a = i; // shadow a
        b_acc = b_acc + a;
        i = i + 1;
    };
    a = 0; // outer a unchanged
    b = b_acc;
    // Expect a = 0 (outer), b = 0+1=1
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
    let outer_bound: u64;
    let inner_bound: u64;
    let i = 0u64;
    let outer_value = 0u64;
    let inner_value = 0u64;
    while (i < 3) {
        let outer = i; // shadow outer
        outer_value = outer;
        let j = 0u64;
        while (j < 2) {
            let inner = j; // shadow inner
            inner_value = inner;
            j = j + 1;
        };
        i = i + 1;
    };
    outer_bound = outer_value;
    inner_bound = inner_value;
    // Expect outer_bound = 2 (last outer), inner_bound=1 (last inner)
}
