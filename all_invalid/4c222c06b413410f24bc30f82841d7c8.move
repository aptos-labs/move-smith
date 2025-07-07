
//# publish
module 0xCAFE::TestModule {
    use std::vector;

    // Define a struct to serve as a test object
    struct Obj has store, key {
        id: u64,
        label: vector<u8>,
    }

    // Function to create an Obj and move it to global storage
    public fun create_obj(s: &signer, id: u64, label: vector<u8>) {
        let obj = Obj { id, label };
        move_to<Obj>(s, obj);
    }

    // Function to borrow global Obj and return its id
    public fun get_obj_id(addr: address): u64 {
        let obj_ref: &Obj = borrow_global<Obj>(addr);
        obj_ref.id
    }

    // Function to mutate Obj label
    public fun update_obj_label(s: &signer, new_label: vector<u8>) {
        let obj_ref: &mut Obj = borrow_global_mut<Obj>(signer::address_of(s));
        obj_ref.label = new_label;
    }

    // Function to delete Obj
    public fun delete_obj(s: &signer) {
        move_from<Obj>(signer::address_of(s));
    }

    // Function to implement and test match with expression in arm
    public fun match_with_expression(choice: u8): u8 {
        match (choice) {
            0 => {
                let res = 42;
                res
            },
            1 => 100,
            2 => {
                // Block in match arm
                let temp = 7;
                temp
            }
            _ => 255,
        }
    }

    // Function to test cycle detection: create a dependency cycle
    // Note: dependencies cross modules and structs
    public fun create_cycle_in_dependency() {
        // This function exists to induce dependency cycle: 
        // A: starts with cycle, depends on B
        // B: depends on C
        // C: depends on A
        // It is a conceptual cycle; in actual Move code, dependency cycle check is at compile time.
        create_a();
        create_b();
        create_c();
    }

    public fun create_a() {}
    public fun create_b() {}
    public fun create_c() {}
}

// Separate module to establish dependency cycle

//# publish
module 0xCAFE::CycleA {
    use 0xCAFE::TestModule;

    public fun create_a() {
        // Depend on cycle_b
        0xCAFE::CycleB::create_b()
    }
}

module 0xCAFE::CycleB {
    use 0xCAFE::TestModule;

    public fun create_b() {
        // Depend on cycle_c
        0xCAFE::CycleC::create_c()
    }
}

module 0xCAFE::CycleC {
    use 0xCAFE::TestModule;

    public fun create_c() {
        // Depend on cycle_a
        0xCAFE::CycleA::create_a()
    }
}


//# run 0xCAFE::TestModule::match_with_expression --args 0u8

//# run 0xCAFE::TestModule::match_with_expression --args 1u8

//# run 0xCAFE::TestModule::match_with_expression --args 2u8

//# run 0xCAFE::TestModule::match_with_expression --args 3u8


//# run 0xCAFE::TestModule::create_obj --signers 0xBEEF --args 1u64, b"LabelOne"u8 vector

//# run 0xCAFE::TestModule::get_obj_id --args 0xBEEF

//# run 0xCAFE::TestModule::update_obj_label --signers 0xBEEF --args b"NewLabel"u8 vector

//# run 0xCAFE::TestModule::delete_obj --signers 0xBEEF

// Featurres:
// d0f45a8325cce9350e8c9b2b6b3cb0c2: Define a script block in your Move code using the 'script' keyword and curly braces.
// 854f81617e84b9895feb9ed044a5d0b8: Include an expression as the body of a match arm, which can be a block or a single expression.
// a10b1051a24cb0f4089ba64928937a8b: Identify a cycle in the dependency graph involving a specific starting node.
