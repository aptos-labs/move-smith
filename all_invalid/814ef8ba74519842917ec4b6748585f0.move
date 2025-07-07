
//# publish
module 0xCAFE::VariantAndVectorTest {
    use std::vector;

    // 1. Define struct variants with named attributes, names, and fields
    struct NamedStruct has copy, drop, store {
        name: vector<u8>,
        value: u64,
    }

    enum NamedEnum has copy, drop {
        VariantA,
        VariantB { id: u32, label: vector<u8> },
        VariantC { flag: bool, number: u16 },
    }

    // 2. Function to create vectors with element type parameters and arguments
    public fun create_vector_u8(elements: vector<u8>): vector<u8> {
        vector::empty<u8>() + elements
    }

    public fun create_vector_u16(elements: vector<u16>): vector<u16> {
        vector::empty<u16>() + elements
    }

    // 3. Function to demonstrate filtering module members by ignoring certain modules
    // (In practice, this is part of compilation, but we can add code that references selected members)

    // Function that uses only the above structs/enums and vector functions
    public fun test_feature() {
        // 1. Instantiate NamedStruct
        let ns = NamedStruct { name: b"test", value: 42 };

        // 2. Instantiate NamedEnum variants
        let variant_a = NamedEnum::VariantA;
        let variant_b = NamedEnum::VariantB { id: 100, label: b"label" };
        let variant_c = NamedEnum::VariantC { flag: true, number: 65535 };

        // 2. Create vectors with specific elements
        let vec_u8 = create_vector_u8(b"hello");
        let vec_u16 = create_vector_u16(vector::from_element<u16>(255, 3));

        // 3. Reference only the structs/enums that are declared above
        // (Filtering is handled during compilation - here just usage)
        let _ = ns;
        let _ = variant_a;
        let _ = variant_b;
        let _ = variant_c;
        let _ = vec_u8;
        let _ = vec_u16;
    }
}


//# run 0xCAFE::VariantAndVectorTest::test_feature

// Featurres:
// 0d49697b7af45dcb92e4c3f355a6c4cb: Define struct variants with named attributes, names, and fields.
// a9b8bb739e5fad9cf3e17a8f4d9c27e1: Create vectors with element type parameters and argument lists.
// 392b6bcaa4a347e49ff1031528c45850: Filter out module members based on specific criteria during compilation.
