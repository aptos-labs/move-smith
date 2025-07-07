
//# publish
module 0xCAFE::Keywords {
    const abort: u8 = 1;
    const acquires: u8 = 2;
    const as: u8 = 3;
    const break_: u8 = 4;
    const const_: u8 = 5;
    const continue_: u8 = 6;
    const copy_: u8 = 7;
    const else_: u8 = 8;
    const false_: u8 = 9;
    const fun_: u8 = 10;
    const friend_: u8 = 11;
    const if_: u8 = 12;
    const invariant_: u8 = 13;
    const let_: u8 = 14;
    const loop_: u8 = 15;
    const inline_: u8 = 16;
    const module_: u8 = 17;
    const move_: u8 = 18;
    const native_: u8 = 19;
    const public_: u8 = 20;
    const return_: u8 = 21;
    const script_: u8 = 22;
    const spec_: u8 = 23;
    const struct_: u8 = 24;
    const true_: u8 = 25;
    const use_: u8 = 26;
    const while_: u8 = 27;

    public fun sum_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun create_add_lambda(): |u8, u8| u8 has copy {
        let lambda: |u8, u8| u8 has copy = |x: u8, y: u8| {
            x + y
        };
        lambda
    }

    public inline fun inline_add(x: u8, y: u8): u8 {
        x + y
    }

    public fun assert_example(x: u8) {
        // Condition that x must be less than 100, abort code 1000 if false
        assert!(x < 100, 1000);
    }
}


//# run 0xCAFE::Keywords::sum_add --args 42u8 58u8


//# run 0xCAFE::Keywords::assert_example --args 50u8


//# run 0xCAFE::Keywords::assert_example --args 150u8


//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Keywords;

    // Call the inline function from Keywords module and use the sum_add function
    public fun call_inline_sum(a: u8, b: u8): u8 {
        let add_result = Keywords::inline_add(a, b);
        let sum_result = Keywords::sum_add(add_result, 1u8);
        sum_result
    }

    public fun use_lambda_to_sum(a: u8, b: u8): u8 {
        let lambda = Keywords::create_add_lambda();
        let result = lambda(a, b);
        result
    }
}


//# run 0xCAFE::Caller::call_inline_sum --args 20u8 21u8


//# run 0xCAFE::Caller::use_lambda_to_sum --args 10u8 15u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 5e0902799ab755c35a5cabcf13775d0a: Write 'assert' specifications in Move code to add conditions that must hold at a point.
// c7de6dbbd59579017d1bb297b05f4853: Use the `program` function to filter out non-unit-test modules from your program before compilation.
// 7dcd99288efac8956318da471526087a: Use reserved keywords such as 'abort', 'acquires', 'as', 'break', 'const', 'continue', 'copy', 'else', 'false', 'fun', 'friend', 'if', 'invariant', 'let', 'loop', 'inline', 'module', 'move', 'native', 'public', 'return', 'script', 'spec', 'struct', 'true', 'use', 'while' as identifiers in Move code.
