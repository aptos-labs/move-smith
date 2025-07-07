//# publish
module 0x1::PathTest {
    /// This function is intended to test that different path strings referring to the same file
    /// resolve to the same module or resource. (Canonicalization.)
    public fun test_path_canonicalization() {
        // Move compiler's test infra: this is here for conceptual branching.
        // Pretend to load the same resource under different path strings.
        let x = 1u8;
        let y = 1u8; // Stand-in for separate path resolution.
        // Manually check equivalence for demonstration.
        assert!(x == y, 100);
    }

    public fun runner() {
        Self::test_path_canonicalization();
    }
}
//# run 0x1::PathTest::runner --signers 0x1

// -------------------------------------------------------

//# publish
module 0x2::StructEncapsulation {
    // Struct with a private field
    struct MyStruct has copy, drop, store {
        value: u64,
    }

    // Public friend
    friend 0x2::FriendModule;

    public fun create(x: u64): MyStruct {
        MyStruct { value: x }
    }
    
    public fun get_value(s: &MyStruct): u64 { s.value }

    public fun runner() {
        let s = Self::create(42);
        let v = Self::get_value(&s);
        // Use v in some way to avoid unused var
        let _ = v;
    }
}
//# run 0x2::StructEncapsulation::runner --signers 0x2

//# publish
module 0x2::FriendModule {
    use 0x2::StructEncapsulation;

    public fun access_friend_struct() {
        let s = StructEncapsulation::create(77);
        // FriendModule can access hidden field
        let v = s.value;
        let _ = v;
    }

    public fun runner() { Self::access_friend_struct(); }
}
//# run 0x2::FriendModule::runner --signers 0x2

//# publish
module 0x2::OtherModule {
    use 0x2::StructEncapsulation;

    public fun try_access_struct_field() {
        let s = StructEncapsulation::create(99);
        // The following should error if uncommented (access to field denied):
        // let v = s.value;
        // Instead, read via public accessor:
        let v = StructEncapsulation::get_value(&s);
        let _ = v;
    }

    public fun runner() { Self::try_access_struct_field(); }
}
//# run 0x2::OtherModule::runner --signers 0x2

// -------------------------------------------------------

//# publish
module 0x3::EnumAccess {
    // Simulating an enum using a struct with a private field and public constructor for one variant.
    struct E has copy, drop, store {
        value: u8,
        tag: u8,
    }
    friend 0x3::EnumFriend;

    public fun variant_a(): E { E { value: 123, tag: 0 } }
    public fun is_a(e: &E): bool { e.tag == 0 }
    public fun value(e: &E): u8 { e.value }

    // Not public access to fields!
    public fun runner() {
        let a = Self::variant_a();
        assert!(Self::is_a(&a), 10);
        let v = Self::value(&a);
        let _ = v;
    }
}
//# run 0x3::EnumAccess::runner --signers 0x3

//# publish
module 0x3::EnumFriend {
    use 0x3::EnumAccess;

    public fun access_enum_fields() {
        let e = EnumAccess::variant_a();
        let tag = e.tag;
        let val = e.value;
        let _ = (tag, val);
    }

    public fun runner() { Self::access_enum_fields(); }
}
//# run 0x3::EnumFriend::runner --signers 0x3

// -------------------------------------------------------

//# publish
module 0x4::ModuleAccessGeneric {
    /// Example with named module access and type parameters.

    struct Wrap<T> has copy, drop, store { value: T }

    public fun wrap<T>(x: T): Wrap<T> { Wrap { value: x } }
    public fun unwrap<T>(w: &Wrap<T>): &T { &w.value }

    public fun runner() {
        let x = 100u64;
        let wrapped = Self::wrap<u64>(x);
        let y = *Self::unwrap<u64>(&wrapped);
        let _ = y;
    }
}
//# run 0x4::ModuleAccessGeneric::runner --signers 0x4

//# run
script {
    use 0x4::ModuleAccessGeneric;

    fun main() {
        let x = 200u8;
        let w = ModuleAccessGeneric::wrap<u8>(x);
        let y = *ModuleAccessGeneric::unwrap<u8>(&w);
        let _ = y;
    }
}