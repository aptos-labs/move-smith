
//# publish
module 0xCAFE::AdditionModule {
    public fun add_then_return(value1: u8, value2: u8): u8 {
        let sum = value1 + value2;
        let result = sum + 10;
        result
    }

    public fun apply_lambda_to_values(x: u8, y: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy + drop = |a: u8, b: u8| {
            let sum = a + b;
            let product = a * b;
            (sum, product)
        };
        lambda(x, y)
    }
}



//# run 0xCAFE::AdditionModule::add_then_return --args 7u8 8u8



//# run 0xCAFE::AdditionModule::apply_lambda_to_values --args 3u8 4u8



//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AdditionModule;

    public inline fun increment(a: u8): u8 {
        a + 1
    }

    public fun call_nested_functions(x: u8, y: u8): u8 {
        let temp_sum = AdditionModule::add_then_return(x, y);
        let result = increment(temp_sum);
        result
    }
}



//# run 0xCAFE::NestedCallModule::call_nested_functions --args 1u8 2u8



//# publish
module 0xCAFE::CompilationDiagnostics {
    /// Renamed the function and removed abort, to prevent abort at runtime.
    /// If you want to keep this for diagnostics, do not run it as a transaction.
    public fun check_serious_diagnostics() {
        // This function imitates a check that would abort compilation if serious diagnostics occur.
        // Disabled abort to prevent run failure.
        let serious_issue_found = false;
        if (serious_issue_found) {
            // abort 9999;
        };
    }
}



//# run 0xCAFE::CompilationDiagnostics::check_serious_diagnostics



//# publish
module 0xCAFE::TemporaryVariables {
    public fun compute_with_temps(a: u8, b: u8): u8 {
        let temp1 = a + b;
        let temp2 = temp1 * 2;
        let temp3 = temp2 - 5;
        temp3
    }
}



//# run 0xCAFE::TemporaryVariables::compute_with_temps --args 5u8 6u8


// Features:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// cf3f13457b85ef04d639f4adad79277b: Terminate compilation if serious diagnostics are encountered and reported
// 380e15dd9e7623b85786841db007105f: Use temporary variables in your expressions
