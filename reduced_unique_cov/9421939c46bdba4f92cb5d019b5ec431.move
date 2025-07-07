
//# publish
module 0xCAFE::Arithmetic {
    // Test addition and u8 return

    public fun add_then_return(c: u8, d: u8): u8 {
        let sum = c + d;
        42u8
    }

    public fun lambda_example(x: u8): u8 {
        let lambda: |u8| u8 has copy+drop = |a: u8| {
            a + 1u8
        };
        lambda(x)
    }

    // Inline function returning tuple
    public inline fun inline_add(a: u8, b: u8): (u8, u8) {
        (a + b, a * b)
    }
}


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::Arithmetic;

    public fun call_inline_and_return_sum(a: u8, b: u8): u8 {
        let (sum, _) = Arithmetic::inline_add(a, b);
        sum
    }

    public fun runner() {
        // call add_then_return
        let _ = Arithmetic::add_then_return(1u8, 2u8);
        // call lambda_example
        let _ = Arithmetic::lambda_example(10u8);
        // call call_inline_and_return_sum
        let _ = call_inline_and_return_sum(3u8, 4u8);
    }
}


//# publish
module 0xCAFE::LocalsInspection {
    // This function declares uninitialized locals to see if VM/compiler inspects that.

    public fun locals_with_partial_init(x: u8): u8 {
        let a: u8;
        let b: u8 = x + 1;
        a = x * 2;
        b
    }

    public fun locals_with_uninit() {
        let _a: u8;
        let _b: u8;
        // do nothing with _a and _b, not initialized before use
    }

    public fun runner() {
        let _ = locals_with_partial_init(5u8);
        locals_with_uninit();
    }
}


//# run 0xCAFE::Arithmetic::add_then_return --args 10u8 20u8


//# run 0xCAFE::Arithmetic::lambda_example --args 7u8


//# run 0xCAFE::NestedCalls::call_inline_and_return_sum --args 8u8 9u8


//# run 0xCAFE::NestedCalls::runner


//# run 0xCAFE::LocalsInspection::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// a838e2ca6e3df1cf4df3642938149fbf: Inspect which function locals are not initialized at a given program point.
