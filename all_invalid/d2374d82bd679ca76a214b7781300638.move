// Address used in this test: 0xCAFE

//# publish
module 0xCAFE::NameConventionTest {
    // Test allowed naming conventions in Move module members

    // Struct names can use PascalCase
    struct PascalCaseStruct has copy, drop, store, key {
        value: u64,
    }

    // Constants can be ALL_CAPS or camelCase or snake_case
    const SOME_CONSTANT: u8 = 42;
    const camelCaseConst: u8 = 7;
    const snake_case_const: u8 = 255;

    // Functions can be camelCase, snake_case, PascalCase (allowed, but idiomatic is snake_case or camelCase)
    public fun camelCaseFunction(): u64 {
        123
    }

    public fun snake_case_function(): u64 {
        456
    }

    public fun PascalCaseFunction(): u64 {
        789
    }

    // Inline function
    public inline fun inlineFunction(): u64 {
        1000
    }

    // Runner function to test output usages
    public fun runner(): u64 {
        let a = Self::camelCaseFunction();
        let b = Self::snake_case_function();
        let c = Self::PascalCaseFunction();
        let d = Self::inlineFunction();
        a + b + c + d + (Self::SOME_CONSTANT as u64) + (Self::camelCaseConst as u64) + (Self::snake_case_const as u64)
    }
}
//# run 0xCAFE::NameConventionTest::runner --signers 0xCAFE

//# publish
module 0xCAFE::LambdaScopeLiftTest {
    // This module tests lifting lambdas to higher scope as (inline) functions

    // Since Move disallows lambdas, we simulate by having inner functions
    // and inlining them, supporting "lifting" behavior.

    // A private inline function that acts like a lifted lambda
    fun add_one(x: u64): u64 {
        x + 1
    }

    // An inline function that uses "lifted lambda"
    public inline fun process_value(x: u64): u64 {
        add_one(x) * 2
    }

    // Another inline function lifted
    public inline fun multiply(x: u64, y: u64): u64 {
        x * y
    }

    // Runner to call inline functions and verify compose
    public fun runner(): u64 {
        let val1 = Self::add_one(10);
        let val2 = Self::process_value(10);
        let val3 = Self::multiply(val1, val2);
        val3
    }
}
//# run 0xCAFE::LambdaScopeLiftTest::runner --signers 0xCAFE

//# publish
module 0xCAFE::DiagnosticColorTest {
    // This module is designed to trigger compiler diagnostics that produce colored output.
    // To test diagnostics, we create some deliberate unused variables, shadowings,
    // and illegal operations that produce warnings or errors.

    // A function with unused variable triggers a warning
    public fun unused_variable_warning(): u64 {
        let x = 10;
        let y = 20;
        // y unused intentionally to prompt warning
        x
    }

    // A function with shadowing to test warning
    public fun shadowing_warning(): u64 {
        let x = 5;
        let x = x + 10; // shadowing
        x
    }

    // A function with an intentional type mismatch to produce an error (will not compile)
    // Instead of writing code that breaks compilation, write code that triggers errors
    // in a compile-time allowed manner: for example dividing by zero is not allowed,
    // let's try using incorrect literal types

    // We'll cause a type mismatch by trying to assign u64 to a vector<u8> (error)
    // But this would prevent compilation so we can't include it here.
    // So instead, we use an assert_failure test to check compiler diagnostics.

    #[expected_failure]
    public fun diagnostic_error(): u64 {
        let x: vector<u8> = (123 as u64); // type error
        0
    }

    // Runner to call warning functions (errors won't run)
    public fun runner(): u64 {
        let w1 = Self::unused_variable_warning();
        let w2 = Self::shadowing_warning();
        w1 + w2
    }
}
//# run 0xCAFE::DiagnosticColorTest::runner --signers 0xCAFE

//# run 0xCAFE::DiagnosticColorTest::diagnostic_error --signers 0xCAFE

// Featurres:
// edf5d2f4ab13be32218327e2a68ddf57: Name module members (such as functions, structs, or constants) according to allowed naming conventions
// b96aa00a04c014ffafa027357a5737bb: Lift lambda functions into higher scopes with optional inline function inclusion.
// 22dc5a71e4f920aae3d8a5ee670ff17e: Generate colored diagnostic output for Move compiler diagnostics
