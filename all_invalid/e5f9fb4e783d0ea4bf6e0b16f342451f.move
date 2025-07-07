
//# publish
module 0xCAFE::TestInlineMutability {
    struct Container {
        field1: u64,
        field2: u64,
    }

    public inline fun update_fields(container: &mut Container, val1: u64, val2: u64) {
        container.field1 = val1;
        container.field2 = val2;
    }

    // Function to test multiple mutable references and scope
    public fun test_multi_borrow(container_vec: &mut vector<Container>) {
        let len = vector::length(container_vec);
        let i = 0;
        while (i < len) {
            let container_ref = vector::borrow_mut(container_vec, i);
            // Mutably borrow the container
            update_fields(&mut container_ref, i as u64, (i + 1) as u64);
            i = i + 1;
        }
    }
}

// Testing external module calls and named addresses
module 0xDEAD::ExternalModule {
    public fun external_non_native(): bool {
        true
    }
}

// Define a module with a non-native function to trigger lint checking
module 0xBADD::LintCheck {
    public fun linted_non_native_function(param: u64): u64 {
        param + 42
    }
}


//# run
script {
    use 0xCAFE::TestInlineMutability;

    fun main() {
        let containers = vector::empty<Container>();
        let num = 5;
        let i = 0;
        while (i < num) {
            vector::push_back(&mut containers, Container { field1: 0, field2: 0 });
            i = i + 1;
        }
        // Call the function that performs multiple mutable borrows
        TestInlineMutability::test_multi_borrow(&mut containers);
        // Use the external module function
        let _val = 0xDEAD::ExternalModule::external_non_native();

        // Call the non-native function in lint check module
        let _result = 0xBADD::LintCheck::linted_non_native_function(100);
    }

    main();
}

//# run 0xCAFE::TestInlineMutability::test_multi_borrow --signers 0xCAFE

// Featurres:
// ab1f58cc1de6658a7f70d92c549e66f8: Test that an inline function can safely take multiple mutable references to fields of a struct within a mutable vector, allowing both shared and mutable borrowing in a loop (multi-mutability), and that scoping works correctly inside the closure.
// 2bb8788985e13a0a6c230da263b8553b: Write non-native functions in modules to be subject to external Move lint checking according to the configured checkers.
// ed76520c813b9347b95ad8df42fbf757: Reference named address syntax (`address_name::module_name`) to access a module in your Move code if the named address is declared.
