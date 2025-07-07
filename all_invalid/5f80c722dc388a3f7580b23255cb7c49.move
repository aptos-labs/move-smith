
//# publish
module 0xCAFE::LValueDestructuringTest {
    // Removed unused import 'signer'
    use std::vector;

    struct Container has store {
        a: u8,
        b: u16,
        c: vector<u8>
    }

    public fun create_container(a: u8, b: u16, c: vector<u8>): Container {
        Container { a, b, c }
    }

    public fun destructure_lvalues() {
        // Example 1: Unbound names in typed LValue list with simple variables
        let x: u8 = 5;
        let y: u16 = 300;
        let z: vector<u8> = b"abc";
        let _x = x;
        let _y = y;
        let _z = z;

        // Example 2: Destructuring with a range (slice) element in LValue
        let v: vector<u8> = vector[1u8, 2u8, 3u8, 4u8, 5u8];
        // Destructure into first, middle slice, last
        let first_ref = vector::borrow(&v, 0);
        let len = vector::length(&v);
        // No vector::sub_range function, but vector::slice exists 
        let middle = vector::slice(&v, 1, len - 1);
        let last_ref = vector::borrow(&v, len - 1);
        let first: u8 = *first_ref;
        let last: u8 = *last_ref;

        // Use extracted variables to avoid warnings
        let _m = middle;
        let _f = first;
        let _l = last;

        // Example 3: Destructuring a struct fields with mutable references and mutate them
        let container = create_container(10u8, 1000u16, vector[10u8, 20u8, 30u8]);
        // mutable references to fields
        let c_ref = &mut container.c;
        let a_ref = &mut container.a;
        let b_ref = &mut container.b;

        // Mutate fields using references (FieldMutate equivalent)
        *a_ref = 42u8;
        *b_ref = 4242u16;
        // Mutate vector field by push_back and pop_back (mutate expressions)
        vector::push_back(c_ref, 40u8);
        vector::pop_back(c_ref);

        // To satisfy "mutate" expressions testing, let's create a mutable variable and mutate it
        let val: u8 = 100;
        val = val + 1;

        // To test multiple mutation steps
        let s = 0u8;
        s = s + 10;
        s = s * 2;

        // Use the variables to avoid warnings
        let _container = container;
        let _val = val;
        let _s = s;
    }

    public fun run() {
        destructure_lvalues();
    }
}



//# run 0xCAFE::LValueDestructuringTest::run
