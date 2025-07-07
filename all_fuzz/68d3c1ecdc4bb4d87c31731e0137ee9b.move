
//# publish
module 0xCAFE::AddAndBranch {
    // Module to test addition, branching, and use of anonymous variable `_`

    // Simple function to add two u8 and return x + y + 1u8 to test return correctness
    public fun add_and_increment(x: u8, y: u8): u8 {
        let sum = x + y;
        let result = sum + 1u8;
        result
    }

    // Function that uses branching via conditional jump (if-else in Move)
    public fun conditional_branching(x: u8): u8 {
        if (x == 0u8) {
            100u8
        } else {
            let r = 0u8;
            if (x > 10u8) {
                r = 200u8;
            } else {
                r = 50u8;
            };
            r
        }
    }

    // Function that shows shadowing and pattern matching on tuples and ignore `_`
    public fun test_shadowing_and_ignore_vars(x: u8): u8 {
        let (a, _, c) = (x, 99u8, x + 2u8);
        let a = a + 1u8; // shadowing a
        let _ = a + c; // unused result discarded by _
        a
    }

    // Function to test ignore `_` in closure parameters and variable bindings
    public fun lambda_with_underscore(x: u8): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |_ignore, y| {
            y + 1u8
        };
        lambda(0u8, x)
    }
}


//# publish
module 0xCAFE::LambdaUser {
    use 0xCAFE::AddAndBranch;

    // Function that calls the inline add_and_increment function from AddAndBranch module
    public fun inline_call(x: u8, y: u8): u8 {
        AddAndBranch::add_and_increment(x, y)
    }

    // Function that defines a lambda which calls AddAndBranch::add_and_increment inside it
    public fun lambda_with_nested_call(x: u8, y: u8): u8 {
        let f: |u8, u8| u8 has copy + drop = |a, b| {
            AddAndBranch::add_and_increment(a, b)
        };
        f(x, y)
    }

    // Runner function combining multiple tests in sequence
    public fun runner(): u8 {
        let v1 = AddAndBranch::add_and_increment(1u8, 2u8);
        let v2 = AddAndBranch::conditional_branching(0u8);
        let v3 = AddAndBranch::test_shadowing_and_ignore_vars(3u8);
        let v4 = AddAndBranch::lambda_with_underscore(5u8);
        let v5 = Self::inline_call(3u8, 4u8);
        let v6 = Self::lambda_with_nested_call(7u8, 8u8);
        // Sum all results to produce a final u8 for simplicity
        let sum: u8 = v1 + v2 + v3 + v4 + v5 + v6;
        sum
    }
}


//# run 0xCAFE::AddAndBranch::add_and_increment --args 10u8 11u8


//# run 0xCAFE::AddAndBranch::conditional_branching --args 0u8


//# run 0xCAFE::AddAndBranch::conditional_branching --args 15u8


//# run 0xCAFE::AddAndBranch::test_shadowing_and_ignore_vars --args 5u8


//# run 0xCAFE::AddAndBranch::lambda_with_underscore --args 7u8


//# run 0xCAFE::LambdaUser::inline_call --args 20u8 22u8


//# run 0xCAFE::LambdaUser::lambda_with_nested_call --args 1u8 2u8


//# run 0xCAFE::LambdaUser::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 986dbbf818ad90e080e2aea9908c8ba4: Create branch instructions to perform conditional jumps between labels.
// f937f998c935ba5181a89daa92debdc1: Verify that the Move compiler correctly handles the use, scoping, shadowing, and pattern matching of the anonymous variable (_) in function arguments, local bindings, destructuring assignments, and closure parameters, including both valid and invalid usages.
