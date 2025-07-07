//# publish
module 0xCAFE::TestNestedAndRefs {
    struct R has store {
        a: u64,
        b: u64,
    }

    struct Container has store {
        r: R,
        s: u64,
    }

    // Test 2: Nested block expressions with assignments and arithmetic
    public fun nested_blocks(x: u64): u64 {
        let y = {
            let z = {
                let tmp = x + 1;
                tmp * 2
            };
            z + 3
        };
        y * 2
    }

    // Test 3: Reference destructuring and rebinding references
    public fun ref_destruct_and_rebind(mut c: &mut Container): u64 {
        let &mut Container {r: ref mut r_ref, s: ref mut s_ref} = c;

        // Destructuring immutable reference
        let c_imm_ref: &Container = c;
        let &Container {r: ref r_imm_ref, s: ref s_imm_ref} = c_imm_ref;

        // Rebinding refs: rebind s_ref and r_ref fields
        let ref mut a_ref = r_ref.a;
        let ref mut b_ref = r_ref.b;

        // Modify through mutable refs
        *a_ref = *a_ref + *s_ref;
        *b_ref = *b_ref + 1;
        *s_ref = *s_ref + 10;

        // Check values via immutable refs after mutation
        *r_imm_ref.a + *r_imm_ref.b + *s_imm_ref
    }

    public fun runner() {
        let mut c = Container {
            r: R {a: 10, b: 20},
            s: 5,
        };
        let _ = nested_blocks(3);
        let _ = ref_destruct_and_rebind(&mut c);
    }
}

//# run 0xCAFE::TestNestedAndRefs::nested_blocks --args 4u64

//# run 0xCAFE::TestNestedAndRefs::ref_destruct_and_rebind --args 0u64
//# run 0xCAFE::TestNestedAndRefs::runner

// Featurres:
// 9837922d1789c61afccbe05e5da0c359: Filter and extract only those attributes in your code that are recognized as testing attributes for unit test processing.
// 5dd5bb9af78300bbe8ee21a6bcd8fcf6: Test that the Move language correctly handles nested block expressions with variable assignments and arithmetic calculations within a single function.
// 9927392791575617ce5efe6a5e055ac4: Test that reference destructuring in assignments correctly creates references to fields of both immutable and mutable references to structs, and that rebinding the reference variables is allowed and works as expected.
