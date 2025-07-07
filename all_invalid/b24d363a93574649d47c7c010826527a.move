
//# publish
module 0xBADD::AnnotationsTest {
    use std::signer;

    struct AnnotatedStruct has store, key {
        attr_value: u8,
        attr_addr: address,
    }

    // Function with attribute that takes a literal u8 value
    public fun f_with_literal_attr() {
        // Simulate attribute annotation with a literal number
        // (In actual Move code, annotations accept literals; here it's a conceptual demonstration)
        // e.g., // custom_attr(42u8)]
        // For testing, we just define the function
    }

    // Function with attribute that takes an address literal (numeric)
    public fun f_with_address_attr() {
        // e.g., // another_attr(0xDEADBEEF)]
        // create an instance with attribute value to test parsing
        let addr_obj = AnnotatedStruct { attr_value: 255, attr_addr: @0xDEADBEEF };
        // Use signer address as placeholder, for example, or any address
        move_to<AnnotatedStruct>(&signer::address_of(&signer::placeholder()), addr_obj);
    }

    // Spec function using prefix notation
    // Note: Move doesn't support function names starting with `$`
    // We'll rename functions to avoid invalid characters
    public fun spec_f(x: u64): u64 {
        if (x == 0) {
            1
        } else {
            accept_f(x)
        }
    }

    // Acceptance function
    public fun accept_f(x: u64): u64 {
        x + 42
    }

    // Function that uses spec functions
    public fun f_with_spec_and_attr() {
        let result = spec_f(10);
        assert!(result > 0, 999);
    }
}


//# run 0xBADD::AnnotationsTest::f_with_literal_attr


//# run 0xBADD::AnnotationsTest::f_with_address_attr --signers 0xFACE


//# run 0xBADD::AnnotationsTest::f_with_spec_and_attr

// Features:
// 08bc0dcc6a7934f59bc9ea6d24f01a05: Annotate Move code using attributes that accept literal values.
// 8126be794e550d2d18902def6bd87eb6: Convert attribute values to Move address values, supporting both numerical and symbolic addresses.
// df863012fa11e7aed80792bdd91f0c86: Define Move specification functions (without `$`) that correspond to regular Move functions for use in specifications.