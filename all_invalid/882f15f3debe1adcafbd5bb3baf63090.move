//# publish
module 0xA550C0DE::TestModuleA {
    // A simple function that accepts a u64 argument
    public fun accept_u64(val: u64) {
        // Do nothing
    }

    // A function that calls another function within the same module
    public fun call_accept_u64(val: u64) {
        Self::accept_u64(val);
    }
}

//# publish
module 0xBADDCAFEBABE::TestModuleB {
    // A simple function that accepts a bool argument
    public fun accept_bool(flag: bool) {
        // Do nothing
    }
}

 //# publish
module 0xC0FFEE::TestModuleC {
    // Function to test cross-module call (should fail)
    public fun cross_module_call(target_module: address, module_name: vector<u8>, func_name: vector<u8>) {
        // This function will attempt to call a function in another module
        // The actual call will be simulated in the test script
    }
}

//# publish
module 0xDEADBEEF::TypeUnionTest {
    // Function with type union parameter using '|' (or) syntax
    public fun process_union_type(value: u64 | bool) {
        // Do nothing
    }

    // Function with nested union types using '||' (union of unions)
    public fun process_nested_union(value: u64 || bool) {
        // Do nothing
    }
}

//# run
script {
    // Attempt to call a function from a different module domain - should produce an error
    // Call 0xA550C0DE::TestModuleA::call_accept_u64 with a value
    // Note: This is a conceptual test; in a real environment, the compiler might throw errors at compile time
}
 //# run 0xA550C0DE::TestModuleA::call_accept_u64 --signers 0x0101 --args 42u64

 //# run
script {
    // Call a function within the same module domain to ensure normal operation
}
 //# run 0xA550C0DE::TestModuleA::call_accept_u64 --signers 0x0101 --args 100u64

 //# run
script {
    // Test type union with `|` syntax - passing u64
}
 //# run 0xDEADBEEF::TypeUnionTest::process_union_type --signers 0x0101 --args 42u64

 //# run
script {
    // Test type union with `|` syntax - passing bool
}
 //# run 0xDEADBEEF::TypeUnionTest::process_union_type --signers 0x0101 --args true

 //# run
script {
    // Test nested union `||` with u64
}
 //# run 0xDEADBEEF::TypeUnionTest::process_nested_union --signers 0x0101 --args 123u64

 //# run
script {
    // Test nested union `||` with bool
}
 //# run 0xDEADBEEF::TypeUnionTest::process_nested_union --signers 0x0101 --args false