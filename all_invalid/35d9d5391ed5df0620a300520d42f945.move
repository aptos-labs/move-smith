
//# publish
module 0xBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEE {
    // Testing nested field access and assignment with dot notation, including complex patterns
    struct NestedStruct has store {
        nested_field: vector<key>,
    }

    public fun access_and_assign() {
        // Initialize nested struct with nested fields
        let ns = NestedStruct { nested_field: vector::empty<key>() };

        // Nested block to group multiple statements for ordering
        block {
            let keys_vec = vector::empty<key>();
            vector::push_back(&mut keys_vec, @0xCAFE);
            vector::push_back(&mut keys_vec, @0xBABE);

            // Assign the vector to nested_field using dot notation
            // Note: Since ns is not mutable, we need to declare ns as mutable and assign
            // but Move does not support reassigning immutables like this; must declare as mutable
            // Fix: declare ns as mutable and assign
          // Correction: declare ns as mutable and assign to field
        }
        // Re-initialize ns as mutable
        let ns = NestedStruct { nested_field: vector::empty<key>() };
        let keys_vec = vector::empty<key>();
        vector::push_back(&mut keys_vec, @0xCAFE);
        vector::push_back(&mut keys_vec, @0xBABE);
        ns.nested_field = keys_vec;

        // Complex pattern assignment: destructure nested struct (simulate pattern)
        // Move does not support pattern matching like in some languages, so emulate by manual extraction
        let nested_vec = &ns.nested_field;
        let first_key = match vector::borrow(nested_vec, 0) {
            key_ref => *key_ref
        };
        let second_key = match vector::borrow(nested_vec, 1) {
            key_ref => *key_ref
        };

        // Use the nested field in a computation
        let sum_keys = u64::from(first_key) + u64::from(second_key);
        // Assignment to variable for validation
        let _computed_sum = sum_keys;
    }
}



//# run 0xBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEE::access_and_assign



//# publish
module 0xBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEE_ControlFlow {
    // Function with multiple abort points to test program flow
    public fun multiple_aborts(x: u8): u8 {
        if (x == 0) {
            abort 100;
        };
        if (x == 1) {
            abort 200;
        };
        // Normal execution continues
        let result = x + 10;
        // Another abort point
        if (result > 15) {
            abort 300;
        };
        result
    }

    // Function with expected failure annotation to confirm detection of logical failure conditions
    // expected_failure
    public fun intentionally_fail() {
        abort 999;
    }

    // Function that calls `multiple_aborts` with different inputs
    public fun test_multiple_aborts(): u8 {
        let r1 = multiple_aborts(0);
        let r2 = multiple_aborts(1);
        let r3 = multiple_aborts(4);
        r3 // Returns 14 if no aborts
    }

    // Function that calls intentionally_failing function (expected to fail)
    // expected_failure
    public fun trigger_failure() {
        intentionally_fail();
    }
}



//# run 0xBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEE_ControlFlow::test_multiple_aborts



//# run 0xBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEE_ControlFlow::trigger_failure



//# publish
module 0xBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEE_ModuleFormatCheck {
    // Module to test binary structure against magic number
    const MAGIC_NUMBER: u32 = 0xCADE;

    // Function to check if binary starts with expected magic
    public fun check_module_magic(binary: vector<u8>): bool {
        // The first 4 bytes represent the magic number in big-endian
        let magic_bytes = vector::slice(&binary, 0, 4);
        let magic_value = u32::from_bytes_be(&magic_bytes);
        magic_value == MAGIC_NUMBER
    }

    // Function to produce a valid module binary for test
    public fun generate_valid_binary(): vector<u8> {
        // In actual test, we would load or simulate the binary
        // For simplicity, assume the first 4 bytes are the magic number
        let binary = vector::empty<u8>();
        vector::push_back(&mut binary, 0xCA);
        vector::push_back(&mut binary, 0xDE);
        vector::push_back(&mut binary, 0xAD);
        vector::push_back(&mut binary, 0xBE);
        // Rest of the binary would follow; omitted here
        binary
    }
}



//# run 0xBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEE_ModuleFormatCheck::check_module_magic --args 0xCA 0xDE 0xAD 0xBE



//# publish
module 0xBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEE_TokenSyntacticErrors {
    // Deliberately wrong syntax to trigger parse failures and test failure detection
    // For example: missing semicolon
    public fun missing_semicolon() {
        let x = 10 // missing semicolon here should cause parse error
    }
    // Misplaced tokens, e.g., missing parentheses
    public fun misplaced_token() {
        if x > 5 { // missing parentheses, should cause parse failure
            abort 1;
        };
    }
    // Incorrect use of else without prior if
    public fun else_without_if() {
        else { // invalid syntax
            abort 2;
        }
    }
    // Using an unmatched bracket
    public fun unmatched_bracket() {
        let v = vector::empty<u8>();
        v[0]; // missing closing bracket intentionally
    }
}



//# run 0xBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEE_TokenSyntacticErrors::missing_semicolon



//# run 0xBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEE_TokenSyntacticErrors::misplaced_token



//# run 0xBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEE_TokenSyntacticErrors::else_without_if



//# run 0xBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEE_TokenSyntacticErrors::unmatched_bracket



//# publish
module 0xBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEE_ComplexInteraction {
    // Combining multiple features: nested block, complex expressions, constants, and module interaction
    const MAX_LIMIT: u64 = 1000;

    public fun complex_test(s: signer): u64 {
        // Nested block with multiple expressions
        let final_value: u64;
        block {
            let counter = 0u64;
            // Loop with multiple aborts
            loop {
                if (counter >= 10) {
                    break;
                };
                // Simulate aborts at certain condition
                if (counter == 5) {
                    abort 42;
                };
                // Increment counter
                counter = counter + 1;
            };
            // Final assignment inside block
            final_value = counter;
        };
        // Final expression uses constant, nested access, and interaction
        if (final_value < MAX_LIMIT) {
            let module_magic = 0xCADE as u64;
            // Access nested fields via module
            // Assuming 0xCAFE::MyModule::f3 exists and returns a struct with field x
            let nested_struct = 0xCAFE::MyModule::f3(20u16);
            // Use field access
            let nested_field_value = nested_struct.x as u64;
            // Compose result
            final_value + nested_field_value + module_magic
        } else {
            // Alternative path
            0u64
        }
    }

    // Additional test: complex pattern involving multiple nested block expressions
    public fun nested_blocks() {
        let v = vector::empty<u64>();
        // Add multiple values with nested blocks
        block {
            vector::push_back(&mut v, 1);
            block {
                vector::push_back(&mut v, 2);
                // Nested block with expression
                let sum = 1 + 2;
                vector::push_back(&mut v, sum);
            };
        };
        // Use vector to verify
        let _first = *vector::borrow(&v, 0);
        let _second = *vector::borrow(&v, 1);
        let _sum = *vector::borrow(&v, 2);
    }

    // Run a function interacting with storage, constants, nested access
    public fun storage_and_constants(s: signer): u64 {
        // Store object at signer's address
        0xCAFE::StorageUsage::store_at_signer_address(s, 5, 6);
        // Inspect value
        let (x, y) = 0xCAFE::StorageUsage::inspect_value(s);
        // Update value
        0xCAFE::StorageUsage::update_value(s, 7, 8);
        // Re-inspect
        let (nx, ny) = 0xCAFE::StorageUsage::inspect_value(s);
        // Return sum
        (nx + ny) as u64
    }
}



//# run 0xBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEE::complex_test --signers 0xDEAD



//# run 0xBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEE::nested_blocks



//# run 0xBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEEFBEE::storage_and_constants --signers 0xFEED
