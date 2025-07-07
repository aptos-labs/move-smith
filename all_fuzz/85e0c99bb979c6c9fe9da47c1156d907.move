
//# publish
module 0xCAFE::MathModule {
    // A function that adds two u8 values and returns the sum plus 1
    public fun add_and_increment(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 1
    }

    // A function that defines and uses a lambda to add two u8 values and multiply the result by 2
    public fun lambda_example(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            let added = a + b;
            added * 2
        };
        lambda(x, y)
    }

    // An inline function returning a tuple (u16,u16)
    public inline fun inline_add(a: u16, b: u16): (u16, u16) {
        (a + 1, b + 1)
    }
}


//# run 0xCAFE::MathModule::add_and_increment --args 3u8 4u8


//# run 0xCAFE::MathModule::lambda_example --args 5u8 6u8


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::MathModule;

    // Calls the inline_add from MathModule and uses results to compute u32 sum
    public fun call_inline_and_process(a: u16, b: u16): u32 {
        let (x, y) = MathModule::inline_add(a, b);
        let sum: u32 = (x as u32) + (y as u32);
        sum
    }
}


//# run 0xCAFE::NestedCallModule::call_inline_and_process --args 10u16 20u16


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
