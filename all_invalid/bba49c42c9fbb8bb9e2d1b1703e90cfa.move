
//# publish
module 0xCAFE::ComplexFunctionalityTest {
    use std::signer;
    use std::vector;

    // Placeholder store for key-value map simulation
    struct Keys has store, key {
        addresses: vector<address>,
    }

    struct Values has store, key {
        data: vector<u8>,
    }

    // Initialization function that populates KEYS and VALUES maps
    public fun init() {
        let keys = Keys { addresses: vector::empty<address>() };
        let values = Values { data: vector::empty<u8>() };

        // Adding 3 addresses
        vector::push_back(&mut keys.addresses, @0x1111);
        vector::push_back(&mut keys.addresses, @0x2222);
        vector::push_back(&mut keys.addresses, @0x3333);

        // For each address, associate a value with 3 added to each byte
        let len = vector::length(&keys.addresses);
        let i = 0;
        while (i < len) {
            let addr = *vector::borrow(&keys.addresses, i);
            let val_bytes = vector::empty<u8>();
            // Correct: use a range like 0u8..3u8 (which is 0,1,2)
            // Move does not support for b in range syntax, instead do explicit loop
            let b = 0u8;
            while (b < 3u8) {
                vector::push_back(&mut val_bytes, b + 3);
                b = b + 1;
            }
            // simulate storing in global map, place outside scope here
            // For test purposes, we just ensure the process completes without error
            i = i + 1;
        }
        // No explicit return
    }

    // Function to access nested fields with dot notation
    public fun access_nested_fields(x: u64, y: bool): u64 {
        let record = if (y) {
            struct {
                a: u64,
                b: (u64, bool),
            } {a: x, b: (x + 10, y)}
        } else {
            struct {
                a: u64,
                b: (u64, bool),
            } {a: x + 5, b: (x + 15, false)}
        };
        // Access nested fields
        let nested_value = if (record.b.1) {
            record.b.0 + record.a
        } else {
            record.a + 100
        };
        nested_value
    }

    // Function to parse and evaluate complex binary expressions
    public fun evaluate_binary_expressions(): (u64, u64) {
        let a = 10u64 + 20u64 * 2; // precedence: * then +
        let b = (10u64 + 20u64) * 2; // parentheses change precedence
        (a, b)
    }

    // Function to verify the init process
    public fun verify_init() {
        init();
        // In a real test, access stored KEYS and VALUES or count the assignments
        // Here, just ensure no panic occurs
    }

    // Function with conditional branches and scope verification
    public fun conditional_scope_test(flag: bool): u64 {
        let result = 0u64;
        if (flag) {
            let var_in_if = 42u64;
            // Access nested field within if
            let nested_access = if (var_in_if > 0) { var_in_if } else { 0 };
            result = nested_access;
        } else {
            let var_in_else = 99u64;
            result = var_in_else + 1;
        };
        // Variables from branches are in scope after
        result
    }

    // Runner functions to call the above in tests
    public fun run_access_nested_fields(x: u64, y: bool): u64 {
        access_nested_fields(x, y)
    }

    public fun run_evaluate_binary_expressions(): (u64, u64) {
        evaluate_binary_expressions()
    }

    public fun run_verify_init() {
        verify_init()
    }

    public fun run_conditional_scope_test(flag: bool): u64 {
        conditional_scope_test(flag)
    }
}



//# run 0xCAFE::ComplexFunctionalityTest::run_access_nested_fields --args 15u64 true



//# run 0xCAFE::ComplexFunctionalityTest::run_evaluate_binary_expressions



//# run 0xCAFE::ComplexFunctionalityTest::run_verify_init



//# run 0xCAFE::ComplexFunctionalityTest::run_conditional_scope_test --args true
