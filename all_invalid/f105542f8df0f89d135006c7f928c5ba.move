//# publish
module 0x1::TypeConstraintFriendTest {
    use std::signer;
    
    // A struct with a field that has an explicit type annotation
    struct MyStruct has copy, drop, store {
        value: u64, // explicit type annotation on the field
    }

    // A generic struct with type constraint: T must have copy ability
    struct Wrapper<T: copy> has copy, drop, store {
        inner: T,
    }

    // Annotate friend declaration with attributes (attributes are in `///` doc-comments style)
    /// @friend attr "custom metadata example"
    friend 0x2;

    // A function that creates and returns MyStruct
    public fun make_struct(): MyStruct {
        MyStruct { value: 42 }
    }

    // A runner function without args for testing
    public fun runner(): bool {
        let w = Wrapper<MyStruct> { inner: make_struct() };
        // No actual runtime asserts needed
        true
    }
}
//# run 0x1::TypeConstraintFriendTest::runner

//# publish
module 0x2::FriendModule {
    // Declare 0x1 as friend with an attribute for demonstration
    /// @friend attr "friend to test annotation"
    friend 0x1;

    public fun dummy() {
        // no-op
    }
}

//# run 0x2::FriendModule::dummy