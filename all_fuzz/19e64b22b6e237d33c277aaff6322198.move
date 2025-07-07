
//# publish
module 0xCAFE::AddModule {
    // skip(unused_variable)]
    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        // add 10 after sum and return
        sum + 10
    }

    // skip(unused_variable)]
    public fun lambda_adder(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        adder(x, y)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::WrapperModule {
    use 0xCAFE::AddModule;

    public fun nested_inline_call(x: u8, y: u8): u8 {
        // call AddModule::inline_add twice nestedly
        let first = AddModule::inline_add(x, y);
        let second = AddModule::inline_add(first, 5u8);
        second
    }
}


//# run 0xCAFE::AddModule::add_and_return --args 3u8 7u8


//# run 0xCAFE::AddModule::lambda_adder --args 10u8 15u8


//# run 0xCAFE::WrapperModule::nested_inline_call --args 5u8 10u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// f2bc941881ae8e37583b110c4a3124f1: Mark specific lint checks to be skipped by adding a `#[skip(lint_name)]` attribute to your code.
