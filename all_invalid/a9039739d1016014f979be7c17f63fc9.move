
//# publish
module 0xCAFE::AdvancedFeatures {
    use std::vector;

    struct Point has copy, drop, store {
        x: u32,
        y: u32,
    }

    public fun test_assignments() {
        let a = 10u32;
        let b = 20u32;
        b = a + 5;
        let c = b;

        let point = Point { x: 1, y: 2 };
        // mutate struct fields
        let p = point;
        p.x = 42;
        p.y = p.y + 10;

        // assign a tuple to variables
        let (m, n) = (100u32, 200u32);
        // instantiate a struct with fields assigned from variables
        let s = Point { x: m, y: n };

        // use literals in variable assignment
        let addr: address = @0xBADD;
        // Store address as a literal in a variable (not used further here)

        // all last expressions will serve as return values (no explicit return)
        addr
    }

    public fun test_struct_field_mutation() {
        let s = Point { x: 5, y: 10 };
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

        // Use addresses in some way
        let sum = (addr1 as u64) + (addr2 as u64);
        sum
    }
}


//# run 0xCAFE::AdvancedFeatures::test_assignments


//# run 0xCAFE::AdvancedFeatures::test_struct_field_mutation


//# run 0xCAFE::AdvancedFeatures::test_mutate_local


//# run 0xCAFE::AdvancedFeatures::test_literal_addresses

// Featurres:
// 17e32096043b947e097ce2fa11e19fc5: Perform assignments to local variables, struct fields, or perform mutate operations with the `assign` and `mutate` expressions.
// 1d9fa496d61af9b5404ccf32b1548863: Use module keys that include an optional address and a module name.
// d21bddb9b06888597dffcc51e2c51d89: Use literal addresses prefixed by '@' directly in code.
