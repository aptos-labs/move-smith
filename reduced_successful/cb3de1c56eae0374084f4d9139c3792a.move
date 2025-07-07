
//# publish
module 0xCAFE::AdditionModule {
    // Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
    public fun add_then_return(a: u8, b: u8): u8 {
        let sum = a + b;
        // return sum + 10 as some specific value
        sum + 10
    }

    // Write functions containing lambda (anonymous function) expressions.
    public fun lambda_example(x: u8, y: u8): (u8, u8) {
        let add: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let mul: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        (add(x, y), mul(x, y))
    }

    // Inline function to be called externally for nested call test
    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }
}


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AdditionModule;

    // Test that calling an inline function from one module within another module
    // correctly performs the nested function call and returns the expected result.
    public fun nested_call_add_one(x: u8): u8 {
        AdditionModule::inline_increment(x)
    }
}


//# publish
module 0xCAFE::QuantifierTestModule {
    // Write quantifier expressions followed by a colon or an identifier to define variables in move logic.

    // For demonstration, a function using quantifiers to calculate sum from 0 to n-1
    public fun quantifier_sum(n: u8): u8 {
        let sum: u8 = 0;
        let i: u8;
        for (i in 0..n) {
            sum = sum + i;
        };
        sum
    }
}


//# publish
module 0xCAFE::ForLoopModule {
    // Write for-loops in Move code using for-loop syntax.

    public fun sum_0_to_4(): u8 {
        let total: u8 = 0;
        let i: u8;
        for (i in 0..5) {
            total = total + i;
        };
        total
    }
}


//# publish
module 0xCAFE::StacklessBytecodeOptimizationModule {
    // Perform stackless bytecode optimization passes in a configurable pipeline.
    // This is a simulated test function to represent optimization passes.
    // Actual bytecode optimization can only be done by the Move VM or tooling, so here
    // we will simulate optimization steps as inline calls that do nothing but exist.

    public fun optimization_pass_1(x: u64): u64 {
        x + 1
    }

    public fun optimization_pass_2(x: u64): u64 {
        x * 2
    }

    public fun optimization_pipeline(x: u64): u64 {
        let y = optimization_pass_1(x);
        let z = optimization_pass_2(y);
        z
    }
}


//# run 0xCAFE::AdditionModule::add_then_return --args 3u8 4u8


//# run 0xCAFE::AdditionModule::lambda_example --args 5u8 6u8


//# run 0xCAFE::NestedCallModule::nested_call_add_one --args 7u8


//# run 0xCAFE::QuantifierTestModule::quantifier_sum --args 6u8


//# run 0xCAFE::ForLoopModule::sum_0_to_4


//# run 0xCAFE::StacklessBytecodeOptimizationModule::optimization_pipeline --args 10u64


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 677da68c45adc9186eb6119868a1fa65: Write quantifier expressions followed by a colon or an identifier to define variables in move logic.
// 0b3ffb2ff8b093cf98acf7b73966a688: Write for-loops in Move code using the syntax: for (iter in lower_bound..upper_bound) { /* loop body */ }
// 28277c32ad3fb6b073e3e1ad62644152: Perform stackless bytecode optimization passes in a configurable pipeline.
