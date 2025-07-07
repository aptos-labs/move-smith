
//# publish
module 0xCAFE::TestModule {
    use std::signer;
    use std::vector;

    // Entry function that runs all tests
    public fun run_all_tests(s: signer) {
        test_variable_scoping(s);
        test_shadowing(s);
        test_access_control();
    }

    // Function to test variable creation, shadowing, and scope within loops
    public fun test_variable_scoping(_s: &signer) {
        // Outside while loop: variable x
        let x = 0u64;

        // Outer while loop
        while (x < 3) {
            // Shadowed variable x inside inner scope
            let x_inner = x;
            // Shadowed 'x' in inner scope: create new binding
            let x_shadow = x_inner + 10;
            // For demonstration, update inner shadow variable
            x_inner = x_shadow;
            // After inner scope: updating outer x
            x = x + 1;
        };

        // For loop with local variable
        let i = 0u8;
        while (i < 2) {
            let i_shadow = i + 1; // shadowing local variable
            // Update outer i
            i = i_shadow + 1;
        };
        // At the end, assign to a final variable to check
        let final_x = x;
        // Use final_x to prevent unused variable warning
        final_x
    }

    // Function to test variable shadowing and scope with nested shadowing
    public fun test_shadowing(_s: &signer) {
        let a = 5u8;
        let a = 10u8; // shadow outer a
        {
            let a = 20u8; // inner shadowing
            // use inner a
            let _ = a;
        };
        // Outer a should still be 10
        let _ = a;
    }

    // Internal function: can only be called within this module
    internal fun internal_function() {
        // simple no-op
    }

    // Function trying to access internal function from outside (should cause compile error if attempted)
    public fun test_access_control() {
        // Cannot access internal_function from outside, so comment out
        // internal_function(); // *This line should cause compile error if uncommented*
        ()
    }

    // Store module member: Person struct
    struct Person has store, key {
        name: vector<u8>,
        age: u8,
    }

    record store PersonStore has key {
        person: Person,
    }

    // Function to store Person
    public fun store_person(s: &signer, name: vector<u8>, age: u8) {
        let person = Person { name, age };
        move_to<PersonStore>(s, PersonStore { person });
    }

    // Function to retrieve Person
    public fun get_person(s: &signer): Person acquires PersonStore {
        let store_ref = borrow_global::<PersonStore>(signer::address_of(s));
        let PersonStore { person } = *store_ref;
        person
    }

    // Entry point to run all tests
    public fun run(s: &signer) {
        store_person(s, b"Alex", 30);
        let _ = get_person(s);
        test_variable_scoping(s);
        test_shadowing(s);
        test_access_control();
        ()
    }
}
