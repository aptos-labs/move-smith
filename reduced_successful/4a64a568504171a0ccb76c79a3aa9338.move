
//# publish
module 0xCAFE::CalcAdd {
    /// Adds two u8 values and returns the sum increased by 5
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 5
    }

    /// Runner to test add_and_offset with known inputs
    public fun run_example(): u8 {
        Self::add_and_offset(10u8, 20u8)
    }
}


//# run 0xCAFE::CalcAdd::run_example



//# publish
module 0xCAFE::LambdaModule {
    /// Runs a lambda that multiples input by 2
    public fun double_via_lambda(x: u8): u8 {
        let lambda: |u8| u8 has copy + drop = |a: u8| {
            a * 2
        };
        lambda(x)
    }

    /// Runs a lambda that adds two numbers inside the lambda, then returns sum*2
    public fun complex_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            let s = x + y;
            s * 2
        };
        lambda(a, b)
    }
}


//# run 0xCAFE::LambdaModule::double_via_lambda --args 8u8


//# run 0xCAFE::LambdaModule::complex_lambda --args 2u8 4u8



//# publish
module 0xCAFE::NestedInlineCaller {
    use 0xCAFE::CalcAdd;

    /// Calls the inline add_and_offset function from CalcAdd module multiple times to
    /// create a total sum, testing nested calls to inline functions
    public inline fun sum_three_add_and_offset(p: u8, q: u8, r: u8): u8 {
        let a = CalcAdd::add_and_offset(p, q);
        let b = CalcAdd::add_and_offset(q, r);
        let c = CalcAdd::add_and_offset(p, r);
        a + b + c
    }

    /// Runner without args to test nested inline calls
    public fun run_sum(): u8 {
        Self::sum_three_add_and_offset(1u8, 2u8, 3u8)
    }
}


//# run 0xCAFE::NestedInlineCaller::run_sum



//# publish
module 0xCAFE::StringEscapes {
    /// Returns a vector<u8> string literal with escaped quotes and backslashes
    public fun get_escaped_string(): vector<u8> {
        let s = b"Line1\\nLine2\\\"Quote\\\"";
        s
    }
}


//# run 0xCAFE::StringEscapes::get_escaped_string



//# publish
module 0xCAFE::ConditionalReassign {
    /// Demonstrates variable reassignment in branches and returns variable
    public fun reassign_in_branches(cond1: bool, cond2: bool): u8 {
        let val = 0u8;
        if (cond1) {
            val = 10;
        } else {
            val = 20;
        };
        if (cond2) {
            val = val + 5;
        } else {
            val = val + 15;
        };
        val
    }

    /// Runner to test reassign_in_branches with multiple inputs
    public fun run_all_cases(): (u8, u8, u8, u8) {
        let r1 = Self::reassign_in_branches(true, true);
        let r2 = Self::reassign_in_branches(true, false);
        let r3 = Self::reassign_in_branches(false, true);
        let r4 = Self::reassign_in_branches(false, false);
        (r1, r2, r3, r4)
    }
}


//# run 0xCAFE::ConditionalReassign::run_all_cases


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// dd9eb9a3733e0e74b7e233c25e26ff6b: Write string literals that support escaped characters (such as \" and \\) inside the string.
// 1e412a57ffc70a3d7841548f2d8239b5: Test that variables reassigned in multiple conditional branches within a single expression are evaluated in the correct order and produce the expected result.
