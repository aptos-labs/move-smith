// Declare an address block outside of modules or scripts
address 0x1 {
    //# publish
    module 0x1::StructModule {
        // Define a simple struct with a field
        struct MyStruct has copy, drop, store {
            field: u64,
        }

        // Function to create a new struct instance
        public fun create_struct(value: u64): MyStruct {
            MyStruct { field: value }
        }

        // Function to modify the field via a mutable reference
        public fun modify_field(s: &mut MyStruct, new_value: u64) {
            s.field = new_value;
        }

        // Function to return the value of the field by reference
        public fun get_field_value(s: &MyStruct): u64 {
            s.field
        }

        // Runner function to test assigning a local copy and modifying via mutable reference
        public fun run_assignment_and_modify(): u64 {
            let s = create_struct(10);
            let mut s_ref = &mut s;
            modify_field(&mut s_ref, 42);
            // Return the modified field value
            get_field_value(&s)
        }
    }
}

//# run 0x1::StructModule::run_assignment_and_modify
// This will compile, publish, run the function which tests modification of a copied struct and returns the field value.

// Now, test a module with a generic 'axiom' parameterized by type parameter and using braced blocks and spec blocks.
 //# publish
module 0x1::GenericAxiomModule {
    // An example 'axiom' struct with optional type parameters for conditions
    spec {
        // Specification block that includes multiple items
        // For illustration, specify a condition with a generic type parameter
        defines axioms<type T> {
            // A simple axiom that T must be a u8 or u64 type (conceptual, for test)
            // In Move, specs are just for formal verification; here we just declare the pseudocode.
        }
    }

    // Declare an axiomatic condition with a type parameter
    resource struct Axiom<Optional T> {
        condition: bool,
        // Optional type parameter is simulated with a type argument
        phantom: std::marker::PhantomData<T>,
    }

    // Function using braces and spec blocks
    public fun check_axiom_and_return(condition: bool): bool acquires Axiom<()> {
        {
            // Begin block of expressions
            let axiom = Axiom<()>{ condition, phantom: std::marker::PhantomData };
            // Further logic can be added here
            // For test, just return the condition
            condition
        }
    }

    // Runner function to test the spec block and axiom
    public fun run_axiom_check() {
        let result = check_axiom_and_return(true);
        move result;
    }
}

//# run 0x1::GenericAxiomModule::run_axiom_check