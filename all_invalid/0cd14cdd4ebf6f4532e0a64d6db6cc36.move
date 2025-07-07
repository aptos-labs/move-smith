//# publish
module 0x1::EscapeSequencesTest {
    public fun test_escape_sequences() {
        // Function to test parse escape sequences in byte string literals
        let byte_str = b"Line1\nLine2\t\"Quote\"\\Backslash\\";
        // potentially just return or do nothing; focus on compile
        move(());
    }
}

//# publish
module 0x2::DependencyModule {
    // Dependency declaration to test dependency analysis
    use 0x1::EscapeSequencesTest;
    public fun dependency_function() {
        EscapeSequencesTest::test_escape_sequences();
    }
}

//# publish
module 0x3::FunctionInvoker {
    // Define a function to demonstrate multiple invocation styles
    public fun my_func(x: u64): u64 {
        x + 1
    }

    public fun get_func_reference(): fun(x: u64): u64 {
        my_func
    }

    public fun run_function_styles() {
        let f = get_func_reference(); // assign to variable
        let result1 = my_func(10); // direct call
        let result2 = f(20); // call via variable
        let lambda = |x: u64| my_func(x); // lambda wrapping function
        let result3 = lambda(30);
        // no assertions required
        move(());
    }
}

//# publish
module 0x4::ComplexSamples {
    // Struct with singleton layout
    struct SingletonStruct has key {
        id: u64,
        name: vector<u8>,
    }

    // Struct with variant-like layout
    struct VariantStruct has key {
        variant_type: u8,
        data: vector<u8>,
    }

    public fun create_singleton_struct(id: u64, name: vector<u8>): SingletonStruct {
        SingletonStruct { id, name }
    }

    public fun create_variant_struct(variant_type: u8, data: vector<u8>): VariantStruct {
        VariantStruct { variant_type, data }
    }
}

//# run 0x3::FunctionInvoker::run_function_styles