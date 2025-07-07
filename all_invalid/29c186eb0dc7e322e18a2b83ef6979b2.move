
//# publish
module 0xCAFE::ResourceTest {
    use std::signer;

    struct MyResource<T> has store, key {
        id: u64,
        phantom: T,
    }

    public fun create_resource<T>(s: signer, id: u64) {
        let resource = MyResource<T> { id, phantom: *b"" };
        move_to<MyResource<T>>(&s, resource);
    }

    public fun borrow_id<T>(addr: address): u64 {
        let res_ref: &MyResource<T> = borrow_global<MyResource<T>>(addr);
        res_ref.id
    }

    public fun deconstruct_with_type_arg<T>(addr: address): u64 {
        let MyResource::<T> { id, phantom: _ } = borrow_global<MyResource<T>>(addr);
        id
    }

    public fun byte_string_literal(): vector<u8> {
        b"\xDE\xAD\xBE\xEF"
    }
}


//# run 0xCAFE::ResourceTest::create_resource --type-args u8 --signers 0xBEEF --args 42u64

//# run 0xCAFE::ResourceTest::borrow_id --type-args u8 --args 0xBEEF

//# run 0xCAFE::ResourceTest::deconstruct_with_type_arg --type-args u8 --args 0xBEEF

//# run 0xCAFE::ResourceTest::byte_string_literal
