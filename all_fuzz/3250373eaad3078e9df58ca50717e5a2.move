
//# publish
module 0xCAFE::AdditionModule {
    struct Dummy has copy, drop, store { x: u8 }

    public fun add_then_return_unique(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return sum + 10 to check correct computation + custom calculation
        sum + 10
    }

    public fun call_with_lambda_and_return_result(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            a + b
        };
        adder(x, y)
    }

    public inline fun inline_adder(x: u8, y: u8): u8 {
        x + y
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AdditionModule;

    enum SimpleEnum has copy, drop {
        Unit,
        Value(u8),
        Pair(u8, u8)
    }

    struct ContainerStruct has copy, drop, store {
        data: u8
    }

    public fun test_nested_calls(x: u8, y: u8): u8 {
        // Call the inline adder in another module, then add 5
        let base_sum = AdditionModule::inline_adder(x, y);
        base_sum + 5
    }

    public fun lambda_in_this_module(x: u8): u8 {
        let multiplier: |u8| u8 has copy + drop = |val: u8| {
            val * 2
        };
        multiplier(x)
    }
}


//# run 0xCAFE::AdditionModule::add_then_return_unique --args 10u8 20u8


//# run 0xCAFE::AdditionModule::call_with_lambda_and_return_result --args 3u8 7u8


//# run 0xCAFE::CallerModule::test_nested_calls --args 4u8 6u8


//# run 0xCAFE::CallerModule::lambda_in_this_module --args 15u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 9ba5a4a0de0763f8ddf68761933dcd21: Define structs and enums inside modules by using the 'struct' keyword, or using the 'enum' identifier for enum structs following Move 2 syntax.
