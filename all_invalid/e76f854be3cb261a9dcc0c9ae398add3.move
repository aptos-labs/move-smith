
//# publish
module 0xCAFE::LValueDestructuringTest {
    use std::signer;
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
        let (x, y, z): (u8, u16, vector<u8>) = (5, 300, b"abc");
        let _ = (x, y, z);

        // Example 2: Destructuring with a range (slice) element in LValue
        let v: vector<u8> = vector[1u8, 2u8, 3u8, 4u8, 5u8];
        // Destructure into first, middle slice, last
        let (first, middle, last): (u8, vector<u8>, u8) = (vector::borrow(&v, 0), vector::sub_range(&v, 1, vector::length(&v) - 1), vector::borrow(&v, vector::length(&v) - 1));
        let _ = (first, middle, last);

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
        let _ = (container, val, s);
    }

    public fun run() {
        destructure_lvalues();
    }
}


//# run 0xCAFE::LValueDestructuringTest::run


// Featurres:
// 784981e51d0960deb8932e8ae91d211b: Use unbound names in typed LValue lists during compilation.
// 6979f3dd022cb1cd7a48360a6df86d9c: Support destructuring assignment patterns with range (slice) elements in LValues for more flexible matching.
// 34378d7af0b0a616c5620c09c7adbe27: Mutate data with `FieldMutate` and `Mutate` expressions.
