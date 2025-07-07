//# publish
module 0xCOFFEE::TypeFeatureTest {
    use std::vector;
    use std::type_name;
    use std::type_info;
    use std::signer;

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
    public fun create_resource(signer_addr: &signer::Signer, id: u64, data: vector<u8>) {
        let res = ResourceStruct { id, data };
        move_to<ResourceStruct>(signer_addr, res);
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
                internal_sum(x, if (y) { 1 } else { 0 })
            },
            SampleEnum::VariantC { label } => {
                vector::length(&label) as u64
            },
        };
        result
    }

    // Function to test vector and nested types
    public fun test_vector_types() {
        let v_u8: vector<u8> = vector::from_bstring(b"abc");
        let v_u64: vector<u64> = vector::empty();
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
        // For simplicity, check divisibility by 1..n
        let i = 1;
        while (i <= n) {
            if (k % i != 0) {
                return false;
            }
            i = i + 1;
        }
        true
    }
}

// Usage commands should refer to the module and function names directly

// Example run commands (uncomment as needed):

// run 0xCOFFEE::TypeFeatureTest::get_type_of_u8

// run 0xCOFFEE::TypeFeatureTest::get_type_id_of_resource

// run 0xCOFFEE::TypeFeatureTest::create_resource --signers 0xBADD --args 999u64, vector::from_bstring(b"data")

// run 0xCOFFEE::TypeFeatureTest::shadowing_loop --args 5u64

// run 0xCOFFEE::TypeFeatureTest::match_enum_value --args SampleEnum::VariantA

// run 0xCOFFEE::TypeFeatureTest::match_enum_value --args SampleEnum::VariantB(10u64, true)

// run 0xCOFFEE::TypeFeatureTest::match_enum_value --args SampleEnum::VariantC { label: vector::from_bstring(b"label") }

// run 0xCOFFEE::TypeFeatureTest::test_vector_types

// run 0xCOFFEE::TypeFeatureTest::smallest_multiple --args 10u64

// run 0xCOFFEE::TypeFeatureTest::smallest_multiple --args 20u64
