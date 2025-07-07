
//# publish
module 0xCOFFEE::TypeFeatureTest {
    use std::vector;
    use std::type_name;
    
    // Test resource and enum distinctions, plus internal function usage
    struct ResourceStruct has store, key {
        id: u64,
        data: vector<u8>,
    }
    
    enum SampleEnum has copy, drop {
        VariantA,
        VariantB(u64, bool),
        VariantC { label: vector<u8> },
    }

    // Internal function to test accessibility
    internal fun internal_sum(x: u64, y: u64): u64 {
        x + y
    }

    // Function exposing type recognition
    public fun get_type_of_u8(): vector<u8> {
        let t_name = type_name<u8>();
        t_name
    }

    // Function to get type id (simulate type identifier)
    public fun get_type_id_of_resource(): type_info::TypeId {
        type_info::type_of<ResourceStruct>()
    }

    // Function to instantiate resource
    public fun create_resource(id: u64, data: vector<u8>) {
        let res = ResourceStruct {id, data};
        move_to<ResourceStruct>(&signer::borrow_account(), res);
    }

    // Internal function involving shadowing variables inside loop
    fun shadowing_loop(x: u64): u64 {
        let a = x;
        let b = 0;
        let i = 0;
        while (i < 3) {
            let a = a + 1; // shadow outer 'a'
            b = a * 2;
            i = i + 1;
        };
        b
    }

    // Test handling of enum with internal and external usage
    public fun match_enum_value(ev: SampleEnum): u64 {
        let result = match (ev) {
            SampleEnum::VariantA => 0,
            SampleEnum::VariantB(x, y) => {
                internal_sum(x, if (y) {1} else {0})
            },
            SampleEnum::VariantC { label } => {
                vector::length(&label) as u64
            },
        };
        result
    }

    // Function to test vector and nested types
    public fun test_vector_types() {
        let v_u8: vector<u8> = b"abc";
        let v_u64: vector<u64> = vector::empty<u64>();
        vector::push_back(&mut v_u64, 42);
        vector::push_back(&mut v_u64, 100);
        let v_nested: vector<vector<u8>> = vector::empty();
        vector::push_back(&mut v_nested, v_u8);
        vector::push_back(&mut v_nested, vector::from_bstring(b"xyz"));
    }

    // Function to compute smallest multiple
    public fun smallest_multiple(n: u64): u64 {
        let candidate = n;
        loop {
            if (multiple_of_all(candidate, n)) {
                break;
            };
            candidate = candidate + n;
        };
        candidate
    }

    fun multiple_of_all(k: u64, n: u64): bool {
        // For simplicity, check divisibility by 1..n (only example)
        let i = 1;
        while (i <= n) {
            if (k % i != 0) {
                false
            } else {
                i = i + 1;
                continue;
            }
        };
        true
    }
}


//# run 0xCOFFEE::TypeFeatureTest::get_type_of_u8


//# run 0xCOFFEE::TypeFeatureTest::get_type_id_of_resource


//# run 0xCOFFEE::TypeFeatureTest::create_resource --signers 0xBADD --args 999u64, vector::from_bstring(b"data")

// Shadowing var inside loop test

//# run 0xCOFFEE::TypeFeatureTest::shadowing_loop --args 5u64

// Enum matching test with all variants

//# run 0xCOFFEE::TypeFeatureTest::match_enum_value --args SampleEnum::VariantA


//# run 0xCOFFEE::TypeFeatureTest::match_enum_value --args SampleEnum::VariantB(10u64, true)


//# run 0xCOFFEE::TypeFeatureTest::match_enum_value --args SampleEnum::VariantC { label: vector::from_bstring(b"label") }

// Vector and nested types test

//# run 0xCOFFEE::TypeFeatureTest::test_vector_types

// Smallest multiple calculation for 10

//# run 0xCOFFEE::TypeFeatureTest::smallest_multiple --args 10u64

// Smallest multiple for higher number (20)
// Adjust the function if needed to properly check multiple conditions

//# run 0xCOFFEE::TypeFeatureTest::smallest_multiple --args 20u64


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 38d9f19717f4d38f588ea3ae0f8eb41f: Identify a type starting with an identifier, such as a type name or generic parameter.
// 062c51c830fe9e6081fde75e5921eab7: Use addresses from the module or script's used addresses for referencing resources and code.
// 14f416cf0e16ffc2d73fdf49543fe0d6: Ensure that the `smallest_multiple` function correctly computes the least common multiple of all numbers from 1 up to the specified limit, specifically verifying it returns 2520 for 10 and 232792560 for 20.
