
//# publish
module 0xDEAD::FeatureTest {
    use std::vector; // Optional: remove if unused in this module

    // To fix the 'unbound module' errors, we need to add the 'signer' import
    use std::signer;

    struct MultiAccessStruct has store, key {
        a: u8,
        b: u16,
        c: u32,
    }

    //@ This public function tests handling multiple access specifiers in sequence
    public fun test_access_specifiers(
        s: signer,
        a: u8,
        b: u16,
        c: u32,
    ) {
        // Create an object
        let obj = MultiAccessStruct {a, b, c};
        move_to<MultiAccessStruct>(&s, obj);
        // Borrow global
        let _obj_ref: &MultiAccessStruct = borrow_global<MultiAccessStruct>(signer::address_of(&s));
        // Borrow global mut
        let _obj_mut_ref: &mut MultiAccessStruct = borrow_global_mut<MultiAccessStruct>(signer::address_of(&s));
        // Remove from storage
        let _removed_obj = move_from<MultiAccessStruct>(signer::address_of(&s));
    }

    //@ This function creates a tuple-like struct with positional fields
    public fun create_tuple_struct(a: u8, b: u16): (u8, u16) {
        (a, b)
    }

    //@ This function constructs a nested tuple with numeric positional fields
    public fun nested_tuple(
        a: u8,
        b: u16,
        c: u32,
    ): (u8, (u16, u32)) {
        (a, (b, c))
    }

    //@ This function creates a variant with positional fields
    public fun variant_with_positional_fields(a: u8, b: u16): E {
        E::V2(a as u32, b as u32)
    }

    enum E {
        V1,
        V2(u32, u32),
        V3 { a: bool }
    }
}



//# run 0xDEAD::FeatureTest::test_access_specifiers --signers 0xBADA --args 1u8 2u16 3u32



//# run 0xDEAD::FeatureTest::create_tuple_struct --args 10u8 20u16



//# run 0xDEAD::FeatureTest::nested_tuple --args 5u8 15u16 25u32



//# run 0xDEAD::FeatureTest::variant_with_positional_fields --args 7u8 14u16


// Features:
// a440e58d891781b6fb14de77ca4e6818: Handle multiple access specifiers in a sequence possibly separated by commas, including a trailing comma.
// 49a38dbe507af0066c13c00caeaa89c3: Create tuple-like struct variants with positional fields enclosed in parentheses.
// 1ec968b9866c644bfe28fd6c982f270e: Use numeric tokens to identify positional fields in Move code.
