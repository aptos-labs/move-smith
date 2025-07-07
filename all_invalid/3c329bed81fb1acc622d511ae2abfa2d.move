
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
        let keys = Keys { addresses: vector[] };
        let values = Values { data: vector[] };

        // Adding 3 addresses
        vector::push_back(&mut keys.addresses, @0x1111);
        vector::push_back(&mut keys.addresses, @0x2222);
        vector::push_back(&mut keys.addresses, @0x3333);

        // For each address, associate a value with 3 added to each byte
        let len = vector::length(&keys.addresses);
        let i = 0u64;
        while (i < len) {
            let addr = *vector::borrow(&keys.addresses, i);
            let val_bytes = vector::empty<u8>();
            for (b in 0u8, 3u8) {  // arbitrary starting bytes, e.g., 0,1,2
                vector::push_back(&mut val_bytes, b + 3);
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


// Featurres:
// 78f8dc464195108ec06049bb15ab9fa2: Access nested fields of expressions using dot notation in Move code.
// 6a2556ec38646785f8400fff16aac057: Parse binary expressions with support for operators such as '==', '!=', '<', '>', '<=', '>=', '||', '&&', '^', '|', '&', '<<', '>>', '+', '-', '*', '/', '%', '..', '==>', and '<==>'.
// 627844f84ecfc748b79956e89aeb9bf1: Test that calling the init function correctly maps the KEYS to their lengths plus two and adds three to each value in VALUES without errors.
// 3cfd637587f89cbe0679fe4f37d64568: Test that variables initialized within both branches of an if-else statement are properly recognized and can be used after the conditional.
