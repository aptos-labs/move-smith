
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return sum plus 10
        sum + 10
    }

    public fun lambda_demo(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let result = adder(x, y);
        result
    }

    public inline fun inline_adder(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AddModule;

    public fun nested_calls(x: u8, y: u8): u8 {
        let first = AddModule::inline_adder(x, y);
        let second = AddModule::add_and_return(first, 5u8);
        second
    }

    public fun assign_locals_demo(x: u8, y: u8): u8 {
        let a = x;
        let b = y;
        let c = a + b;
        c
    }
}


//# run 0xCAFE::AddModule::add_and_return --args 15u8 20u8


//# run 0xCAFE::AddModule::lambda_demo --args 7u8 8u8


//# run 0xCAFE::NestedCallModule::nested_calls --args 10u8 5u8


//# run 0xCAFE::NestedCallModule::assign_locals_demo --args 4u8 9u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// a4fe7db2390dba35925d2efeae1a9883: Assign to local variables directly.
