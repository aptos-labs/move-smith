
//# publish
module 0xCAFE::ComplexFeatures {
    use std::signer;
    use std::vector;

    // A nested struct with store ability
    struct Inner has store {
        a: u64,
        b: u64,
    }

    struct Outer has store {
        inner: Inner,
        c: u8,
    }

    // Native struct without explicit fields, has store ability
    native struct NativeStruct has store;

    // Wrapper for native struct to hold a reference (simulate fields externally)
    struct NativeWrapper has store {
        inner_ref: &mut NativeStruct,
    }

    // Function using &mut pattern matching with nested structs to mutate fields in-place
    public fun mutate_nested_struct_fields(o: &mut Outer, new_a: u64, new_b: u64, new_c: u8) {
        // Destructure with mutable references to inner fields
        let &mut Outer { inner: inner_mut, c: c_mut } = o;
        let &mut Inner { a: a_mut, b: b_mut } = inner_mut;

        *a_mut = new_a;
        *b_mut = new_b;
        *c_mut = new_c;
    }

    // Function with multiple inline-like code blocks with side effects,
    // which mutate a local variable and return a final value after all blocks
    public fun inline_block_side_effects(x: u64): u64 {
        let mut_val = x;

        // First block: increment mut_val by 10
        let block1 = {
            let temp = mut_val + 10;
            // shadow mut_val for effect, actually use a temp variable for mutation concept
            temp
        };

        // Second block: multiply block1 result by 2
        let block2 = {
            let temp = block1 * 2;
            temp
        };

        // Third block: add 5 to block2 result
        let block3 = {
            let temp = block2 + 5;
            temp
        };

        block3
    }

    // Combining mutable pattern matching and inline blocks to check side effects and ordering
    public fun combined_mut_pattern_and_inline(o: &mut Outer, incr: u64) {
        // Destructure Outer to get mutable reference to inner.a
        let &mut Outer { inner: inner_mut, c: c_mut } = o;
        let &mut Inner { a: a_mut, b: b_mut } = inner_mut;

        // Inline block updating a_mut, b_mut and c_mut in sequence
        let _ = {
            *a_mut = *a_mut + incr;
            *b_mut = *b_mut + 2 * incr;
            *c_mut = *c_mut + 1;
        };
    }

    // Function to assert the state of Outer struct after mutations (returns tuple)
    public fun read_outer(o: &Outer): (u64, u64, u8) {
        let &Outer { inner, c } = o;
        let &Inner { a, b } = inner;
        (a, b, c)
    }

    // Functions demonstrating native struct usage with &mut pattern matching

    // Function that takes mutable reference to native struct (simulate no fields)
    public fun mutate_native_struct(n: &mut NativeStruct) {
        // No fields to mutate, but ensure referencing is supported
        let _ = n;
    }

    // Function demonstrating inline block with native struct mutable ref as side effect
    public fun native_with_inline_block(n: &mut NativeStruct): u64 {
        let dummy_val = 42u64;

        let _ = {
            mutate_native_struct(n);
            dummy_val + 1
        };

        dummy_val
    }

    // Create an Outer resource for tests with initial values
    public fun create_outer(): Outer {
        Outer {
            inner: Inner { a: 1, b: 2 },
            c: 3,
        }
    }
}



//# run 0xCAFE::ComplexFeatures::create_outer



//# run 0xCAFE::ComplexFeatures::mutate_nested_struct_fields --args 123u64 456u64 7u8



//# run 0xCAFE::ComplexFeatures::inline_block_side_effects --args 10u64



//# run 0xCAFE::ComplexFeatures::combined_mut_pattern_and_inline --args 5u64



//# run 0xCAFE::ComplexFeatures::read_outer --args 1u64 2u64 3u8



//# run 0xCAFE::ComplexFeatures::mutate_native_struct



//# run 0xCAFE::ComplexFeatures::native_with_inline_block


// Featurres:
// cc70eb75f3379df461262797ddf37abb: Test the ability to destructure and mutate references to struct fields using pattern matching with &mut in Move functions.
// 9b6096659f32566b68b5dfcb8fef2c71: Test that the Move language correctly evaluates multiple inline-like code blocks with side effects in an expression and returns the expected final value.
// e09532b2122bc1456e92219e9f2a0683: Include native structs without field declarations.
