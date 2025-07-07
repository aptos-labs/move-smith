
//# publish
module 0xCAFE::TempVariableAndRefTest {
    use std::vector;

    // A utility function to create a boolean vector for later tests
    public fun create_bool_vector(): vector<bool> {
        vector::empty<bool>()
    }

    // Test assigning a name and optional type parameters to a spec variable
    public fun test_spec_variable_with_type_params() {
        // Define a spec variable with name "spec_var" and type parameter of u8
        let spec_var: u8 = 10;

        // Reassign a new value and check it (simulate name/parameter assignment)
        let spec_var_updated: u8 = 20;
        // Since no assertion, just usage
        spec_var_updated
    }

    // Test assigning literal properties with '='
    public fun test_literal_properties() {
        // Assign property 'at' (address) with a literal value
        let at_prop: address = @0xABCD;
        // Assign boolean property
        let boolean_prop: bool = true;
        // Assign numeric property
        let numeric_prop: u16 = 65535;
        // Assign byte string property
        let byte_string_prop: vector<u8> = x"deadbeef";

        // Return the assigned values as a tuple
        (at_prop, boolean_prop, numeric_prop, byte_string_prop)
    }

    // Helper function to mutate a mutable reference but do nothing
    public fun noop_mutate_ref<T>(_ref: &mut T) {}

    // Test that taking mutable references to complex temporaries doesn't affect original variables
    public fun test_temp_ref_and_mutation() {
        // Start with a complex variable: a vector of booleans
        let bools: vector<bool> = create_bool_vector();

        // Take mutable reference to a temporary expression: a conditional expression
        let x_ref: &mut bool;
        {
            let cond = true;
            let temp_bools: vector<bool> = if (cond) {
                vector::singleton(true)
            } else {
                vector::singleton(false)
            };
            // Borrow mutable reference to first element, after setting it
            // To do this correctly, create a mutable variable that holds the vector
            let temp = temp_bools;
            // Take mutable reference to the first element
            x_ref = &mut vector::borrow_mut(&mut temp, 0);
            // Note: 'temp' is dropped here, but x_ref points into local 'temp'
        }

        // Mutate the temporary boolean (should not affect 'bools')
        *x_ref = false;

        // Assert that original 'bools' remains unchanged (simulate with last expression)
        // But as per instruction, ignore assertions, so just return
        // For demonstration, read first element
        let first_bool_ref: &bool = if (vector::length(&bools) > 0) {
            vector::borrow(&bools, 0)
        } else {
            &false
        };

        // Take mutation to a block expression
        let block_vec: vector<bool>;
        {
            let local_vec: vector<bool> = vector::empty<bool>();
            local_vec = vector::push_back(local_vec, true);
            block_vec = local_vec;
        }

        let mut_block_vec = block_vec;
        let block_ref: &mut bool = &mut vector::borrow_mut(&mut mut_block_vec, 0);
        // Mutate the block's first element
        *block_ref = false;

        // Similarly, assign a temporary to a variable, mutate it, ensure original unaffected
        let temp_struct = S { x: 42, y: 100 };
        let temp_struct_mut = temp_struct;
        temp_struct_mut.x = 0; // mutation, but 'temp_struct' remains unchanged

        // Return some value to prevent unused warnings
        *first_bool_ref
    }

    // Define a simple struct for testing
    struct S has copy, drop {
        x: u64,
        y: u64,
    }

    // Function to run the tests
    public fun run_tests() {
        test_spec_variable_with_type_params();
        test_literal_properties();
        test_temp_ref_and_mutation();
    }
}


//# run 0xCAFE::TempVariableAndRefTest::run_tests

// Features:
// caa551bd1b4bd11cc92df5471ec58eab: Assign a name and an optional list of type parameters to a spec variable.
// 832c91f7f3c35b3fb61b5e7ce213244d: Assign literal values (such as at-sign, boolean, numeric, or byte string) to pragma properties using '=', optionally following the property name.
// 3497bb6cfac0ff6bb6fc5865570f2421: Test that taking mutable references to complex temporary expressions, including conditionals, block expressions, and field accesses, does not affect the original variable bindings and that mutations to such temporaries are ignored as expected.