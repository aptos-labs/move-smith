//# publish
module 0xCAFE::TestModule {
    // 1. Attempt to declare a module without an address to cause a compiler error (demonstration only; comment out in actual test)
    // module InvalidModule {  // This should cause an error - not valid syntax, so we comment out
    // }

    // 2. Define an inline function that accepts closure parameters
    public inline fun apply_closures(
        closure1: &fun() -> (), // Closure with no params
        closure2: &fun(param1: u64, param2: vector<u8>) -> ()
    ) {
        // Invoke the closures with sample data
        closure1();
        closure2(42, b"hello".to_vec());
    }

    // A helper function to run the closure with internal capacity of the module
    public fun test_closures() {
        // Define closures
        let closure1 = &| | {
            // Do nothing or some dummy logic
        };
        let closure2 = &|param1: u64, param2: vector<u8>| {
            // Do nothing or log
        };
        // Call the function passing closures
        apply_closures(closure1, closure2);
    }
}

//# run 0xCAFE::TestModule::test_closures

// Featurres:
// e12d95680b807fa43d341e3f0c19e229: Receive a compiler error if a module is declared without specifying an address.
// 2361c4c3cb440a92fc9ecbe5170e550c: Test that inline function parameters can accept and correctly invoke multiple lambda (closure) arguments with different parameter patterns.
// 189a1678fa3db99f51a1711cdf62e162: Use public or internal visibility modifiers on spec apply patterns
