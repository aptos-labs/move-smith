module 0xCAFE::AdvancedFeatures {
    // Removed unused alias 'vector' to fix warning
    // use std::vector;

    struct Point has copy, drop, store {
        x: u32,
        y: u32,
    }

    public fun test_assignments() {
        let a = 10u32;
        let b = 20u32;
        // Variables are immutable by default, so to assign new value to 'b', we need to declare it as 'mut'
        // Also, Move variables are immutable, so reassigning requires 'mut'
        // Correct approach:
        let b_mut = b;
        b_mut = a + 5;
        let c = b_mut;

        let point = Point { x: 1, y: 2 };
        // mutate struct fields
        // Move 'point' into 'p' mut variable
        let p = point;
        p.x = 42;
        p.y = p.y + 10;

        // assign a tuple to variables
        let (m, n) = (100u32, 200u32);
        // instantiate a struct with fields assigned from variables
        let s = Point { x: m, y: n };

        // use literals in variable assignment
        let addr: address = @0xBADD;
        // store address as a literal in a variable (not used further here)

        // return the address
        addr
    }

    public fun test_struct_field_mutation() {
        let s = Point { x: 5, y: 10 };
        // To mutate struct fields, 's' must be mutable
        let s_mut = s;
        s_mut.x = s_mut.x + 1;
        s_mut.y = s_mut.y + 2;

        s_mut
    }

    public fun test_mutate_local() {
        let counter = 0u64;
        // mutate
        counter = counter + 1;
        // mutate again
        counter = counter + 10;

        counter
    }

    public fun test_literal_addresses() {
        // Assign literal addresses to variables
        let addr1: address = @0xDEED;
        let addr2: address = @0xFEED;

        // Use addresses in some way: convert to u64 using 'as' for address type
        // Moving from address to u64: cast address to u64 via 'as u64'
        let sum = (addr1 as u64) + (addr2 as u64);
        sum
    }
}


//# run 0xCAFE::AdvancedFeatures::test_assignments

//# run 0xCAFE::AdvancedFeatures::test_struct_field_mutation

//# run 0xCAFE::AdvancedFeatures::test_mutate_local

//# run 0xCAFE::AdvancedFeatures::test_literal_addresses