
//# publish
module 0xDEAD::CycleTest {
    use std::vector;

    struct A has copy, drop, store, key {
        id: u64,
        name: vector<u8>,
    }

    struct B has copy, drop, store, key {
        ref_a: A,
        value: u16,
    }

    enum CycleEnum has copy, drop {
        Variant1,
        Variant2(A),
        Variant3(B),
    }

    public fun create_a(id: u64, name_b: vector<u8>): A {
        A { id, name: name_b }
    }

    public fun create_b(a: A, val: u16): B {
        B { ref_a: a, value: val }
    }

    public fun create_enum_variant1(): CycleEnum {
        CycleEnum::Variant1
    }

    public fun create_enum_variant2(a: A): CycleEnum {
        CycleEnum::Variant2(a)
    }

    public fun create_enum_variant3(b: B): CycleEnum {
        CycleEnum::Variant3(b)
    }

    // Function to create a cycle with deeply nested generic instantiations to test cyclic type detection
    public fun instantiate_cyclic_type(): B { // intentionally returning B to test cycle detection
        let a_name = b"TestName";
        let a = create_a(42, a_name);
        let b = create_b(a, 123u16);
        b
    }
}



//# run 0xDEAD::CycleTest::create_a --args 42 b"TestName"


//# run 0xDEAD::CycleTest::create_b --args 42 b"TestName" 456u16


//# run 0xDEAD::CycleTest::create_enum_variant1


//# run 0xDEAD::CycleTest::create_enum_variant2 --args 0xDEAD::CycleTest::create_a --signers 0xCAFE


//# run 0xDEAD::CycleTest::create_enum_variant3 --args 0xDEAD::CycleTest::create_b


//# run 0xDEAD::CycleTest::instantiate_cyclic_type
