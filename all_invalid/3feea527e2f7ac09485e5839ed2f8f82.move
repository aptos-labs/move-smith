
//# publish
module 0xDEAD::TestModule {

    use std::vector;

    // Test destructuring with re-binding and mutable assignment
    public fun test_destructure_rebind() {
        struct Person has copy, drop {
            name: vector<u8>,
            age: u8,
        }

        // Create a new Person
        let p = Person {name: b"John", age: 30u8};

        // Destructuring with pattern matching, allowing re-binding
        let Person {name: n, age: a} = p;

        // Rebind the variables
        let n = vector::append(b"", &n);
        let a = a + 1;

        // Construct a new struct with updated values
        let updated_person = Person {name: n, age: a};

        // Use destructuring again to bind in pattern
        let Person {name: mut new_name, age: new_age} = updated_person;

        // Mutate the fields via mutable binding
        new_name = vector::append(b" Doe", &new_name);
        let new_age = new_age + 1;

        // Final struct with mutated fields
        let _final_person = Person {name: new_name, age: new_age};

        // Indication that the code is not reachable after this point
        // (for test purposes, we do not execute further)
        // no-op
    }

    // Define a generic struct with type parameter
    struct Container<T> has copy, drop {
        value: T,
        valid: bool,
    }

    // Define a struct with nested type parameter
    struct OuterStruct<U> has copy, drop {
        inner: Container<U>,
        description: vector<u8>,
    }

    // Function to instantiate such generic structs
    public fun instantiate_structs() {
        let c = Container<u64> {value: 42, valid: true};
        let o = OuterStruct<u64> {inner: c, description: b"nested struct"};
        // For test, we do not do further
        no;
    }
}


//# run 0xDEAD::TestModule::test_destructure_rebind


//# run 0xDEAD::TestModule::instantiate_structs

// Featurres:
// 0f969730f1ad33e58b8fdc7180c14a97: Use 'no' as an indication that a code segment is definitely not reachable.
// 231fb386dc3fd9532a76e769bff5f658: Test destructuring a struct while allowing re-binding and mutable assignment of variables in the struct literal expression.
// 9b265d2bf6b06a6082cc900e138e6587: Define modules containing structs with type parameters
