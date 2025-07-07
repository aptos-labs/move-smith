
//# publish
module 0xCAFE::GenericStructTest {
    struct Container<T> has copy, drop, store {
        value: T
    }

    public fun create_u8_container(x: u8): Container<u8> {
        Container { value: x }
    }

    public fun create_bool_container(b: bool): Container<bool> {
        Container { value: b }
    }

    public fun read_u8_container(c: &Container<u8>): u8 {
        c.value
    }

    public fun read_bool_container(c: &Container<bool>): bool {
        c.value
    }
}


//# publish
module 0xCAFE::TestBoolReturn {
    public fun test(b: bool): u8 {
        if (b) {
            1
        } else {
            9
        }
    }
}


//# publish
module 0xCAFE::AttributeUse {
    use 0xCAFE::TestBoolReturn;

    const MODULE_NAME: vector<u8> = b"TestBoolReturn";

    public fun call_test_true(): u8 {
        TestBoolReturn::test(true)
    }

    public fun call_test_false(): u8 {
        TestBoolReturn::test(false)
    }
}


//# run 0xCAFE::GenericStructTest::create_u8_container --args 42u8


//# run 0xCAFE::GenericStructTest::create_bool_container --args true


//# run 0xCAFE::GenericStructTest::read_u8_container --args 0x1


//# run 0xCAFE::GenericStructTest::read_bool_container --args 0x2


//# run 0xCAFE::TestBoolReturn::test --args true


//# run 0xCAFE::TestBoolReturn::test --args false


//# run 0xCAFE::AttributeUse::call_test_true


//# run 0xCAFE::AttributeUse::call_test_false


// Featurres:
// 18fcecd82c824bb4e2905d9002af0910: Create struct types with type parameters and instantiate them with specific type arguments.
// 16b3afc48b9f91989178261552f7543c: Test that the `test` function correctly returns 1 when the argument is true and 9 when the argument is false.
// e1c3cb622fa8ea3df6f7d8e7ccca3131: Use attribute values to specify module references or names in Move code.
