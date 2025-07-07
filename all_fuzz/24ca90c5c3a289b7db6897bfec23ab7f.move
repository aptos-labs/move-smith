
//# publish
module 0xCAFE::ReservedKeywords {
    // Demonstrate usage of reserved keywords as identifiers 
    // by prefixing them with underscores or using in context.
    // Note: Using reserved words directly as identifiers is not allowed,
    // but using them with underscores or proper casing is valid.

    public const _const: u8 = 42;

    public fun _fun(_abort: u8): u8 acquires Struct {
        let _friend = _abort + 1;
        if (_friend > 40) {
            return _friend;
        } else {
            let _else = 0;
            return _else;
        };
    }

    struct _struct has copy, drop, store {
        _module: u8,
        _script: u8,
        _native: u8
    }

    public fun new_struct(): _struct {
        _struct { _module: 1, _script: 2, _native: 3 }
    }

    public fun dead_code_else_branch(x: u8): u8 {
        if (x == 0) {
            loop {
                break;
            };
            1
        } else {
            // dead code that should not affect execution
            let _dead = x + 1;
            return 999; // This return is dead code
        };
    }
}


//# run 0xCAFE::ReservedKeywords::_fun --args 41u8


//# run 0xCAFE::ReservedKeywords::new_struct


//# run 0xCAFE::ReservedKeywords::dead_code_else_branch --args 0u8


//# publish
module 0xCAFE::LambdaTest {
    // Test lambdas and anonymous functions usage

    public fun sum_with_lambda(a: u8, b: u8): u8 {
        let add: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        add(a, b)
    }

    public fun nested_lambda(x: u8): u8 {
        let f: |u8| u8 has copy+drop = |y: u8| {
            let inner: |u8| u8 has copy+drop = |z: u8| {
                y + z
            };
            inner(x)
        };
        f(5u8)
    }
}


//# run 0xCAFE::LambdaTest::sum_with_lambda --args 7u8 8u8


//# run 0xCAFE::LambdaTest::nested_lambda --args 3u8


//# publish
module 0xCAFE::InlineCall {
    use 0xCAFE::LambdaTest;

    public inline fun double_add(a: u8, b: u8): u8 {
        let sum1 = LambdaTest::sum_with_lambda(a, b);
        let sum2 = LambdaTest::sum_with_lambda(sum1, b);
        sum2
    }

    public fun runner(): u8 {
        double_add(10u8, 20u8)
    }
}


//# run 0xCAFE::InlineCall::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 7dcd99288efac8956318da471526087a: Use reserved keywords such as 'abort', 'acquires', 'as', 'break', 'const', 'continue', 'copy', 'else', 'false', 'fun', 'friend', 'if', 'invariant', 'let', 'loop', 'inline', 'module', 'move', 'native', 'public', 'return', 'script', 'spec', 'struct', 'true', 'use', 'while' as identifiers in Move code.
// 34183dbe62dabfa8fcd639e71d83badf: Add functions to a module with associated attributes and kind annotations.
// e51a13f151c79b9b3b0d4ad12d73a0c0: Test that dead code in the else branch after a conditional with a loop and break does not affect execution or cause errors.
