//# publish
module 0xabc::InteractionTest {
    // Module to test various interactions and control flow effects on mutable references
    
    // Function to test reassignment of references inside nested blocks and conditional branches
    public fun complex_mutation(r: u64): u64 {
        let base_value = 5;
        // Assign a mutable reference to either r or base_value, depending on condition
        let tref = &mut { if (r % 2 == 0) { r } else { base_value } }; // &mut u64
        *tref = *tref + 3; // modifies either r or base_value
        
        // Create a new variable and mutate through a reference
        let y = r;
        let tref2 = &mut y;
        *tref2 = *tref2 * 2; // double y
        
        // Nested block with local variable and reference
        let z = {
            let temp = y;
            let tref3 = &mut temp;
            *tref3 = *tref3 - 1; // decrement temp
            *tref3
        }; // z holds the decremented value of y
        
        // Assign through a mutable reference to a nested expression
        let tref4 = &mut { z + 4 };
        *tref4 = *tref4 + 2; // z + 4 + 2, but writes to temp
        // Final assignment to z to reflect mutation
        let z = *tref4 - 6; // adjusting back
        
        // Use a block with a statement that doesn't affect the outer scope
        let _temp_unused = {
            let inner = 10;
            inner + 1
        };
        
        // Final value based on previous mutations
        *tref + z
    }
    
    public fun combined_test(): u64 {
        let result1 = complex_mutation(10); // should modify mutable op
        let result2 = complex_mutation(3);
        result1 + result2 // combine results
    }

    // Struct with copy and drop to test reference interactions with data structures
    struct S has copy, drop {
        f: u64
    }

    // Function to test references inside struct lifecycle interactions
    public fun struct_mutation(r: S): u64 {
        let s_copy = r;
        let tref = &mut { if (s_copy.f % 3 == 0) { r } else { s_copy } }; // mut reference
        (*tref).f = (*tref).f + 5; // mutate the selected struct
        
        let y = r;
        let tref2 = &mut y;
        (*tref2).f = (*tref2).f * 2; // mutate y
        
        // Nested block affecting struct's field
        let z_field = {
            let temp_field = y.f;
            let tref3 = &mut temp_field;
            *tref3 = *tref3 - 2;
            *tref3
        };
        // Update actual struct field via temp variable
        let mut z = y;
        z.f = z_field + 3; 
        
        // Use another block with an expression that won't affect the outer scope
        let _unused_block = {
            let dummy = 42;
            dummy - 1
        };
        z.f
    }
    
    public fun test_structs(): u64 {
        let s1 = S { f: 9 };
        let s2 = S { f: 4 };
        struct_mutation(s1) + struct_mutation(s2)
    }
}

//# run 0xabc::InteractionTest::combined_test
//# run 0xabc::InteractionTest::test_structs