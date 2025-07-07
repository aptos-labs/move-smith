
//# publish
module 0xCAFE::TestModule {
    // Struct for testing deconstruction
    struct Person {
        name: vector<u8>,
        age: u64,
    }

    // Function to construct a Person
    public fun create_person(name: vector<u8>, age: u64): Person {
        Person { name, age }
    }

    // Function to deconstruct a Person into fields
    public fun get_person_name(person: &Person): vector<u8> {
        person.name
    }

    // Function that returns multiple values
    public fun split_tuple(): (u64, vector<u8>) {
        (42, b"test")
    }

    // Function that performs assignment and deconstruction
    public fun assign_and_deconstruct() {
        let person = create_person(b"Alice", 30);
        let Person { name, age } = person;
        // use name and age in some way (logic not needed for test)
        let (num, text) = split_tuple();
        let (num_field, text_field) = (num, text);
    }
}


//# run 0xCAFE::TestModule::assign_and_deconstruct --signers 0xCAFE

// Featurres:
// 36499f1457fd267362a473b4d1314065: Perform assignments that deconstruct structs or tuples into their individual fields in a single statement
// 9594083bbb6061427bab6369ed050333: Write identifiers, such as variable names, struct names, or function names, in your Move code.
// 69669e6897ba3c0591e53ac0d7add7eb: Define functions as members of a module
