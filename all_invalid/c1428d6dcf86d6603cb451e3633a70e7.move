
//# publish
module 0xCAFE::LambdaAndAdd {
    // Test 1: Addition of two u8 values before returning a specific value
    public fun add_and_return_special(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42u8
        } else {
            0u8
        }
    }

    // Test 2: Function containing lambda expressions
    public fun apply_lambda(x: u8): u8 {
        let double: |u8|u8 has copy+drop = |a: u8| { a * 2 };
        let increment: |u8|u8 has copy+drop = |a: u8| { a + 1 };
        let v1 = double(x);
        let v2 = increment(v1);
        v2
    }
}


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::LambdaAndAdd;

    // Test 3: Inline function in LambdaAndAdd invoked here and used in nested call

    public inline fun inline_add(a: u8, b: u8): u8 {
        // call LambdaAndAdd::add_and_return_special but add 1 to it
        let val = LambdaAndAdd::add_and_return_special(a, b);
        val + 1
    }

    public fun multiply_after_inline_add(a: u8, b: u8, factor: u8): u8 {
        let temp = inline_add(a, b);
        temp * factor
    }
}


//# publish
module 0xCAFE::DiagBuffer {
    use std::vector;

    struct Diagnostic has copy, drop, store {
        msgs: vector<vector<u8>>
    }

    public fun create_diag(): Diagnostic {
        Diagnostic { msgs: vector::empty<vector<u8>>() }
    }

    public fun add_message(diag: &mut Diagnostic, msg: vector<u8>) {
        vector::push_back(&mut diag.msgs, msg);
    }

    public fun example_usage(): Diagnostic {
        let diag = create_diag();
        add_message(&mut diag, b"Warning: unused variable");
        add_message(&mut diag, b"Error: integer overflow");
        diag
    }
}


//# run 0xCAFE::LambdaAndAdd::add_and_return_special --args 5u8 6u8


//# run 0xCAFE::LambdaAndAdd::add_and_return_special --args 3u8 4u8


//# run 0xCAFE::LambdaAndAdd::apply_lambda --args 7u8


//# run 0xCAFE::NestedCalls::inline_add --args 6u8 5u8


//# run 0xCAFE::NestedCalls::multiply_after_inline_add --args 6u8 5u8 3u8


//# run 0xCAFE::DiagBuffer::example_usage


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// b47c54045accd6dc8b836826a0ccd293: Display diagnostics and error messages produced by the Move compiler in a structured buffer format for further inspection or use.
