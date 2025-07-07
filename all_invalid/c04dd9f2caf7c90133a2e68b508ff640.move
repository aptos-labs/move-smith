
//# publish
module 0xCAFE::LambdaVectorTest {
    use std::vector;

    struct VecContainer has store, key {
        vec: vector<u8>,
    }

    public fun create_container(): VecContainer {
        let v = vector::empty<u8>();
        vector::push_back(&mut v, 0u8);
        VecContainer { vec: v }
    }

    public fun update_first_element(container: &mut VecContainer, new_value: u8) {
        if (vector::length(&container.vec) > 0) {
            vector::borrow_mut(&mut container.vec, 0) = new_value;
        };
    }

    public fun get_first_element(container: &VecContainer): u8 {
        if (vector::length(&container.vec) > 0) {
            *vector::borrow(&container.vec, 0)
        } else {
            0u8
        }
    }

    public fun test_lambda_lifting_and_multiple_bindings() {
        // Step 1: Create a vector and container
        let container = create_container();

        // Step 2: Define a lambda that takes the container and a new value,
        // updates the first element, and returns the new value
        let lambda: |&mut VecContainer, u8| u8 = |cont: &mut VecContainer, val: u8| {
            update_first_element(cont, val);
            get_first_element(cont)
        };

        // Step 3: Clone lambda and call outside scope (lifting)
        let lambda_clone = copy lambda;
        // Apply lambda to update first element to 42
        let new_val = lambda(&mut (container), 42u8);
        // Bind multiple variables: destructure tuple and assign to two variables
        let (updated_value, _unused) = (new_val, 0u8);

        // Step 4: Ensure the vector's first element is updated correctly
        let updated_element = get_first_element(&container);

        // Step 5: Use the lambda again with a different value
        let result_value = lambda_clone(&mut (container), 255u8);

        // Binding multiple variables from lambda result and a separate vector state
        let (final_value, _) = (result_value, 0u8);

        // Step 6: Assertions (simulate, or just check multiple assignment and mutation)
        assert!(updated_element == 42, 999);
        assert!(final_value == 255, 998);
        // For completeness, ensure the container struct's vector contains the last value
        let last_element = get_first_element(&container);
        assert!(last_element == 255, 997);
    }
}


//# run 0xCAFE::LambdaVectorTest::test_lambda_lifting_and_multiple_bindings


// Featurres:
// e2044e4313b5dabba6686e18fdf18641: Write Move code that uses lambda expressions, with the compiler performing lambda lifting to support them.
// 1906cb0341c5279da7dce89c8d5e75fb: Bind the results of an expression to multiple local variables using lvalues in assignments and patterns
// e6924546d1f2fbe9da61cc0a787bb1d2: Test creating and mutating a struct containing a vector field by updating its first element via a mutable borrow in Move.
