//# publish
module 0xCAFE LiteralAbilities {
    // Test abilities: store, key, drop, copy, drop

    #[test]
    public fun test_literal_and_abilities() {
        let a: u8 = 255; // maximum u8
        let b: u64 = 1234567890;
        let c: bool = true;
        let d: vector<u8> = b"test_buffer";

        // Resulting values are not used further; this is to just test literal parsing and abilities
        // No actions needed
    }

    // Test different ability declarations
    resource struct MyResource has store, key, drop {}

    public fun create_resource(): MyResource {
        let res = MyResource{};
        move_to<MyResource>(@0xCAFE, res);
        res
    }
}

//# run 0xCAFE::LiteralAbilities::test_literal_and_abilities

//# publish
module 0xCAFE AbilityTests {
    #[test]
    public fun test_ability_declaration() {
        // Declare a resource with multiple abilities
        resource struct MultiAbilityResource has store, key, drop {}
        let res = MultiAbilityResource{};
        move_to<MultiAbilityResource>(@0xCAFE, res);
    }

    // Function to instantiate and borrow global resource to exercise abilities
    public fun use_resource() {
        let res_ref = borrow_global<MultiAbilityResource>(@0xCAFE);
        // No further actions needed for this test
    }
}

//# run 0xCAFE::AbilityTests::test_ability_declaration
//# run 0xCAFE::AbilityTests::use_resource --signers 0xCAFE

//# publish
module 0xCAFE StoreAndDrop {
    resource struct Data has store, drop {}

    public fun create_data(): Data {
        let data = Data{};
        move_to<Data>(@0xCAFE, data);
        data
    }

    public fun remove_data() {
        let data = move_from<Data>(@0xCAFE);
        // resource is moved out; no explicit drop required
    }
}

//# run 0xCAFE::StoreAndDrop::create_data
//# run 0xCAFE::StoreAndDrop::remove_data --signers 0xCAFE

//# publish
module 0xCAFE NumericExpressionTest {
    #[test]
    public fun test_numeric_casts() {
        let x: u8 = 10;
        let y: u16 = (x as u16) + 300; // 10 + 300 = 310
        let z: u32 = (x as u32) + 1000; // 10 + 1000 = 1010
        let large: u128 = (y as u128) + (z as u128);
        // Just exercise casting expressions
    }

    #[test]
    public fun test_arithmetic_expressions() {
        let a: u64 = 10;
        let b: u64 = 20;
        let sum = a + b;
        let diff = b - a;
        let prod = a * b;
        let quotient = b / a;
        let remainder = b % a;
    }
}

//# run 0xCAFE::NumericExpressionTest::test_numeric_casts
//# run 0xCAFE::NumericExpressionTest::test_arithmetic_expressions

//# publish
module 0xCAFE TupleTests {
    #[test]
    public fun test_tuple_unpacking() {
        let tup = (1u8, 2u16, 3u32);
        let (a, b, c) = tup;
        // Tuples are unpacked into variables
        // Test tuple with different types
    }

    #[test]
    public fun test_tuple_with_unsupported_pack() {
        // This will cause a compile error if uncommented, to ensure testing behavior
        // let tup = (1u8, 2u16);
        // let _ = (a, b) = tup; // invalid assignment
    }
}

//# run 0xCAFE::TupleTests::test_tuple_unpacking

//# publish
module 0xCAFE LogicalOperators {
    #[test]
    public fun test_booleans() {
        let x = true;
        let y = false;
        let and_result = x && y;
        let or_result = x || y;
        let not_x = !x;
    }

    #[test]
    public fun test_comparison() {
        let a: u32 = 10;
        let b: u32 = 20;
        let eq = a == b;
        let neq = a != b;
        let gt = b > a;
        let lt = a < b;
        let gte = b >= a;
        let lte = a <= b;
    }
}

//# run 0xCAFE::LogicalOperators::test_booleans
//# run 0xCAFE::LogicalOperators::test_comparison