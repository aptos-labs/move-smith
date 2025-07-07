
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
        let addr_obj = AnnotatedStruct { attr_value: 255, attr_addr: 0xDEADBEEF };
        move_to<AnnotatedStruct>(&signer::address_of(&signer::placeholder()), addr_obj);
    }

    // Spec function using prefix notation
    // For the purpose of testing, define functions with `$` prefix
    public fun $f_spec(x: u64): u64 {
        // For demonstration, just return x + 1
        if (x == 0) {
            1
        } else {
            $f_accept(x)
        }
    }

    // Acceptance function
    public fun $f_accept(x: u64): u64 {
        x + 42
    }

    // Function that uses spec functions
    public fun f_with_spec_and_attr() {
        let result = $f_spec(10);
        assert!(result > 0, 999);
    }
}


//# run 0xBADD::AnnotationsTest::f_with_literal_attr

//# run 0xBADD::AnnotationsTest::f_with_address_attr --signers 0xFACE

//# run 0xBADD::AnnotationsTest::f_with_spec_and_attr

// Featurres:
// 08bc0dcc6a7934f59bc9ea6d24f01a05: Annotate Move code using attributes that accept literal values.
// 8126be794e550d2d18902def6bd87eb6: Convert attribute values to Move address values, supporting both numerical and symbolic addresses.
// df863012fa11e7aed80792bdd91f0c86: Define Move specification functions ($-prefixed) that correspond to regular Move functions for use in specifications.
