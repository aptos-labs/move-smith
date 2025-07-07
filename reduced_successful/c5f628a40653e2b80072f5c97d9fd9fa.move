
//# publish
module 0xCAFE::AddAndReturn {
    public fun add_then_return(a: u8, b: u8, return_value: u8): u8 {
        let sum = a + b;
        sum; // compute sum first, but return return_value as specified
        return_value
    }

    public fun run_add_then_return() {
        let _ = add_then_return(5u8, 7u8, 42u8);
    }
}


//# run 0xCAFE::AddAndReturn::run_add_then_return


//# publish
module 0xCAFE::LambdaExamples {
    public fun apply_lambda(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| { a + b };
        add_lambda(x, y)
    }

    public fun run_lambda_examples() {
        let result = apply_lambda(10u8, 20u8);
        let mul_lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| { a * b };
        let product = mul_lambda(3u8, 4u8);
        let identity_lambda: |u8|u8 has copy+drop = |v: u8| { v };
        let identity = identity_lambda(99u8);
    }
}


//# run 0xCAFE::LambdaExamples::run_lambda_examples


//# publish
module 0xCAFE::CallInlineFns {
    use 0xCAFE::LambdaExamples;

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_lambda_examples_lambda(x: u8, y: u8): u8 {
        LambdaExamples::apply_lambda(x, y)
    }

    public fun call_inline_and_lambda(x: u8, y: u8): u8 {
        let sum = inline_add(x, y);
        let applied = call_lambda_examples_lambda(x, y);
        sum + applied
    }

    public fun run_call_inline_fns() {
        let _ = call_inline_and_lambda(11u8, 22u8);
    }
}


//# run 0xCAFE::CallInlineFns::run_call_inline_fns


// Features:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two
//                                   u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within anothe
//                                   module correctly performs the nested function calls and returns the
//                                   expected result.
// 9215ae1df667395735358a83241850e3: Test that variables declared before an if-else statement are correctly
//                                   recognized as potentially uninitialized if a return occurs in one branch.
// 616f16896c7e0fdcbc2027f751f2c465: Receive errors when trying to use member accesses (like module fields or
//                                   functions) in places where only a module identifier is expected.
// ...
