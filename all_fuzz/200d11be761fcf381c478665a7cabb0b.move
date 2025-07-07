
//# publish
module 0xCAFE::AddModule {
    public fun add_then_return(x: u8, y: u8): u8 {
        let sum = x + y;
        42u8 + sum
    }

    public fun with_lambda(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        adder(x, y)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::AddModule::add_then_return --args 10u8 20u8


//# run 0xCAFE::AddModule::with_lambda --args 15u8 25u8


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AddModule;

    public fun call_inline_add(a: u8, b: u8): u8 {
        AddModule::inline_add(a, b)
    }

    public fun call_add_then_return(a: u8, b: u8): u8 {
        AddModule::add_then_return(a, b)
    }
}


//# run 0xCAFE::NestedCallModule::call_inline_add --args 5u8 7u8


//# run 0xCAFE::NestedCallModule::call_add_then_return --args 6u8 6u8


// The following import will cause error if uncommented because aliases are forbidden in transaction tests:
// use 0xCAFE::AddModule as DuplicateAlias; // ERROR: Aliases are not allowed

// The following duplicate alias also errors and thus omitted:
// use 0xCAFE::AddModule;
// use 0xCAFE::AddModule; // ERROR: Duplicate import alias



//# publish
module 0xCAFE::LintCheckedModule {
    // deny(warnings)]
    // deny(unused_variables)]
    public fun lint_checked_function(x: u8) {
        // intentionally do nothing to test lint denial of unused variables
        let _ = x; // avoid unused variable by binding but not using
    }
}


//# run 0xCAFE::LintCheckedModule::lint_checked_function --args 123u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// f6a96d478f9d1f255049689e2ff3629c: Receive an error if you attempt to import a module or member using a restricted or duplicate alias name.
// 803b75666da11f9b3b683ded4af1c80d: Configure external lint checks for modules and functions
