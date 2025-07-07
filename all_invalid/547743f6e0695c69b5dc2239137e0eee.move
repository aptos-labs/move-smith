//# publish
module 0xCAFE::TestModule {
    // 1. Attempt to declare a module without an address to cause a compiler error (demonstration only; comment out in actual test)
    // module InvalidModule {  // This should cause an error - not valid syntax, so we comment out
    // }

    // 2. Define an inline function that accepts closure parameters
    public inline fun apply_closures(
        closure1: &fun() { }, // Closure with no params
        closure2: &fun(param1: u64, param2: vector<u8>) { }
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