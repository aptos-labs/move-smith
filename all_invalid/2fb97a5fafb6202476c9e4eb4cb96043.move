
//# publish
module 0xCAFE::TestFeatures {
    use std::signer;

    // For feature 1: simple addition and returning a specific value
    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return a specific value, say sum + 10
        sum + 10
    }

    // For feature 2: lambda expressions usage
    public fun use_lambda(x: u8, y: u8): u8 {
        let add = |a: u8, b: u8| { a + b };
        let mul = |a: u8, b: u8| { a * b };

        let s = add(x, y);
        let p = mul(x, y);
        s + p
    }

    // For feature 3: call inline function from other module with nested calls
    public fun inline_call(x: u16): u32 {
        // Call the inline function f2 from 0xCAFE::MyModule which returns a tuple (u16, u16)
        let (a, b) = 0xCAFE::MyModule::f2(x);
        // Return their sum as u32
        (a as u32) + (b as u32)
    }

    // For feature 4: categorize variables by initialization status
    public fun categorize_vars(x: u8): u8 {
        let no_init: u8; // no initialization - compiler should warn about unused and uninitialized
        let maybe_init: u8;
        if (x > 0) {
            maybe_init = 5u8;
        } else {
            maybe_init = 10u8;
        };
        let yes_init = 15u8;
        // Use the initialized variables to avoid unused variable warnings
        // Use yes_init and maybe_init, do not use no_init to test unused parameter warning
        yes_init + maybe_init
    }

    // For feature 5: declare parameters not used to test compiler warnings
    public fun unused_params(_unused1: u8, _unused2: u8, used3: u8): u8 {
        // Intentionally not use _unused1 and _unused2
        used3 + 1u8
    }

    struct RefStruct has copy, drop, store {
        a: u8,
        b: u8,
    }

    // For feature 6: reference destructuring for immutable and mutable references
    public fun ref_destructure_immutable(s: &RefStruct): u8 {
        let RefStruct { a: ref_a, b: ref_b } = *s;
        // Rebinding ref_a
        let ref_a = ref_a + 1;
        ref_a + ref_b
    }

    public fun ref_destructure_mutable(s: &mut RefStruct) {
        let RefStruct { a: ref mut ref_a, b: ref mut ref_b } = *s;
        *ref_a = *ref_a + 10;
        *ref_b = *ref_b + 20;
    }

    // Runner function to test all above features as a transactional function
    public fun runner(s: signer) {
        let _ = add_and_return(3u8, 4u8);
        let _ = use_lambda(2u8, 3u8);
        let _ = inline_call(100u16);
        let _ = categorize_vars(1u8);
        let _ = unused_params(1u8, 2u8, 3u8);

        let r = RefStruct { a: 5u8, b: 10u8 };
        let immutable_ref = &r;
        let _ = ref_destructure_immutable(immutable_ref);

        let m = RefStruct { a: 1u8, b: 2u8 };
        let mutable_ref = &mut m;
        ref_destructure_mutable(mutable_ref);
    }
}
