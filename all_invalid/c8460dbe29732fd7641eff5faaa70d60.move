
// deprecated]
//# publish
module 0xDEAD::DeprecatedNamespace {
    use std::signer;

    public fun deprecated_func(x: u64): u64 {
        x + 42
    }
}

// Define a module that uses nested field access, functions, generics, pattern matching, and function variables

//# publish
module 0xCAFE::AdvancedTest {
    use std::signer;
    use 0xCAFE::MyModule;

    // Define a nested structure to test deep access
    struct OuterStruct has store {
        inner: InnerStruct,
        id: u64,
    }

    struct InnerStruct has store {
        deep_value: u64,
        nested: DeepNested,
    }

    struct DeepNested has store {
        value: u64,
    }

    // Function to create a deeply nested structure
    public fun create_deep_struct(x: u64): OuterStruct {
        let nested = DeepNested { value: x };
        let inner = InnerStruct { deep_value: x + 1, nested };
        OuterStruct { inner, id: x + 2 }
    }

    // Function to access nested fields and perform a check
    public fun check_nested_access(s: &OuterStruct): bool {
        let value = s.inner.nested.value; // deep nested access
        value == s.id - 2
    }

    // Function to test deprecated module usage
    public fun use_deprecated_module(x: u64): u64 {
        // Access deprecated module function, expecting deprecation warning
        0xDEAD::DeprecatedNamespace::deprecated_func(x)
    }

    // Generic function to test passing functions as first-class values
    public fun call_generic_with_fn<T>(f: fn(T): T, arg: T): T {
        f(arg)
    }

    // A simple generic identity function
    public fun identity<T>(x: T): T {
        x
    }

    // Function to assign functions to variables and invoke them
    public fun function_pointer_tests(): u64 {
        let f: fn(u64): u64 = identity;
        let result = f(100);
        // Also testing passing function as argument
        let result2 = call_generic_with_fn(identity, 200);
        // Sum results
        result + result2
    }

    // Function to test specification checks (simulated via pure functions)
    public fun pure_function(x: u64): u64 {
        x * 2
    }

    // Function to assign, invoke, and verify 'purity' (assuming purity enforced)
    public fun test_purity_compliance(): u64 {
        let f: fn(u64): u64 = pure_function;
        f(10)
    }

    // Pattern matching with local variable declaration
    public fun pattern_match_example(option_value: u64?): u64 {
        let result: u64;
        if (option_value.is_some()) {
            let value = option_value.extract();
            result = value + 1;
        } else {
            result = 0;
        };
        result
    }

    // Function that combines multiple features: access, functions, pattern match, and generics
    public fun comprehensive_test(x: u64, opt: u64?): u64 {
        // Access nested field inside deprecated module
        let dep_result = use_deprecated_module(x);
        // Invoke generic function as first-class value
        let val = call_generic_with_fn(identity, dep_result);
        // Pattern match with local variable
        pattern_match_example(opt)
            + val
    }

    // A helper to create and initialize a nested structure
    public fun init_structs() {
        let s = create_deep_struct(5);
        let _ = check_nested_access(&s);
    }
}


//# run 0xCAFE::AdvancedTest::create_deep_struct --args 42u64

//# run 0xCAFE::AdvancedTest::check_nested_access --args 0x0 // would be called with a reference to created struct

//# run 0xCAFE::AdvancedTest::use_deprecated_module --args 100u64

//# run 0xCAFE::AdvancedTest::function_pointer_tests

//# run 0xCAFE::AdvancedTest::test_purity_compliance

//# run 0xCAFE::AdvancedTest::pattern_match_example --args 10u64?
// Note: For pattern_match_example, pass an option (some value or none), e.g. 10u64? or none.u64


// Featurres:
// 78f8dc464195108ec06049bb15ab9fa2: Access nested fields of expressions using dot notation in Move code.
// c1367d37b2075aa6fdcc5740b3ac2c36: Attach deprecation attributes at the address (namespace) level to mark all modules under it as deprecated.
// c75b5002236cb27e7430836ca3ad0a31: Test that functions (including generic functions) can be used as first-class values—assigned to variables, passed as closures and function pointers, and invoked as arguments or with type arguments.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
// f88406655feb90bcc45b9908e95b74a2: Declare and use local variables in patterns on the left-hand side of assignments.
