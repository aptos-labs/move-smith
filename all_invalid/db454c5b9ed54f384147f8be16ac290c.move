
//# publish
module 0xC0DE::CycleTest {
    use std::vector;

    // Modular declaration to test dependency graphs and cyclic references
    // Attempt to create minimal cycle between modules using referencing
    
//# publish
    module 0xC0DE::CycleDependencyA {
        use 0xC0DE::CycleDependencyB;
        public fun dep_a_func() {
            0xC0DE::CycleDependencyB::dep_b_func();
        }
    }

    
//# publish
    module 0xC0DE::CycleDependencyB {
        use 0xC0DE::CycleDependencyA;
        public fun dep_b_func() {
            0xC0DE::CycleDependencyA::dep_a_func();
        }
    }

    // Struct with nested expressions in destructuring to validate assignment and sum
    public struct NestedStruct has copy, drop, store {
        inner_x: u64,
        inner_y: u64,
    }

    // Function to destructure nested struct and compute sum
    public fun destructure_and_sum(nested: NestedStruct): u64 {
        let NestedStruct { inner_x, inner_y } = nested;
        let sum = inner_x + inner_y;
        sum
    }

    // Function to create a nested struct, destructure it and return the sum
    public fun run_destructure_test(): u64 {
        let nested = NestedStruct { inner_x: 10, inner_y: 20 };
        destructure_and_sum(nested)
    }

    // Address block with modules for Address test
    
//# publish
    module 0xABCD::AddressModule {
        struct AddressHolder has store, key {
            address_val: address,
        }

        public fun store_address(signer: std::signer::Signer, addr: address) {
            let holder = AddressHolder { address_val: addr };
            move_to<AddressHolder>(&signer, holder);
        }

        public fun get_address(s: address): address {
            borrow_global<AddressHolder>(s).address_val
        }
    }
}


//# run 0xC0DE::CycleTest::run_destructure_test

//# run 0xC0DE::CycleDependencyA::dep_a_func --signers 0xBADD

//# run 0xC0DE::CycleDependencyB::dep_b_func --signers 0xBADD


//# run 0xC0DE::AddressModule::store_address --signers 0xBADD --args 0xBADD

//# run 0xC0DE::AddressModule::get_address --args 0xBADD


// Featurres:
// 74454629fd6094069b32ea18cde73d14: Analyze dependency graphs to identify minimal cycles in module references
// 63eaf0ea8957190ee5813e1f280549cf: Test that destructuring a struct with nested expressions correctly assigns values and computes the sum of its fields.
// 3a979246d73d638ae602541c01e69ff2: Define an 'address' block with associated modules in Move code.
