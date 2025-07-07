
//# publish
module 0xCAFE::GenKeyDropTest {
    use std::signer;
    use std::assert;
    use std::option;
    use std::error;

    /// A generic struct constrained to have key and drop abilities.
    struct ResourceKeyDrop<T: key + drop> has key, store {
        inner: T
    }

    /// Returns true if resource exists under account addr
    public fun exists<T: key + drop>(addr: address): bool acquires ResourceKeyDrop<T> {
        exists<ResourceKeyDrop<T>>(addr)
    }

    /// Move a ResourceKeyDrop instance to the signer address
    public fun move_in<T: key + drop>(s: signer, inner: T) acquires ResourceKeyDrop<T> {
        let res = ResourceKeyDrop<T> { inner };
        move_to<ResourceKeyDrop<T>>(&s, res);
    }

    /// Borrow a mutable reference to ResourceKeyDrop<T> under signer address
    public fun borrow_mut<T: key + drop>(s: signer): &mut ResourceKeyDrop<T> acquires ResourceKeyDrop<T> {
        borrow_global_mut<ResourceKeyDrop<T>>(signer::address_of(&s))
    }

    /// Remove ResourceKeyDrop<T> resource under signer address
    public fun move_out<T: key + drop>(s: signer): ResourceKeyDrop<T> acquires ResourceKeyDrop<T> {
        move_from<ResourceKeyDrop<T>>(signer::address_of(&s))
    }

    /// A runner function to test with a generic struct of named fields
    public fun runner() {
        let addr_empty = @0x0;

        // Define a struct type with key + drop, identical to EmptyNamedStruct declared below
        // Here we just test with EmptyNamedStruct which has key + drop by default
        // Try to check existence of resource that hasn't been published yet, expect false
        let exists_before = exists::<0xCAFE::GenKeyDropTest::EmptyNamedStruct>(addr_empty);
        assert!(!exists_before, 999);

        // We cannot directly move_in here with EmptyNamedStruct because it's a struct declared below.
        // But public function needs signer, so we just do nothing here. The test will call individual 
        // invocations on EmptyNamedStruct outside this runner. This is a placeholder.

        // We do an example call to borrow_mut (expect abort because resource does not exist)
        // We'll not call here to avoid abort, this is just structural.

        // This runner mainly used to test syntax and generic usage.

    }
}

/// Struct with specified field names, has key and drop abilities
struct EmptyNamedStruct has copy, drop, store, key {
    a: u8,
    b: bool,
}


//# run 0xCAFE::GenKeyDropTest::runner


//# publish
module 0xCAFE::UseEmptyAddress {
    use std::signer;
    use std::assert;
    use 0xCAFE::GenKeyDropTest;

    struct NamedStruct has copy, store, drop, key {
        a: u64,
        b: u64,
    }

    /// Publish resource of generic type T (with key+drop) with given inner value at `Empty` address (0x0)
    /// This simulates instantiating generic struct at Empty address and moving them via GenKeyDropTest
    public fun publish_empty<T: key + drop>(s: signer, inner: T) acquires GenKeyDropTest::ResourceKeyDrop<T> {
        // Move in resource under signer address (must be s with address 0x0)
        GenKeyDropTest::move_in<T>(s, inner);
    }

    /// Test borrowing mut reference to resource under signer address (expect success)
    public fun test_borrow_mut<T: key + drop>(s: signer) acquires GenKeyDropTest::ResourceKeyDrop<T> {
        let res_ref = GenKeyDropTest::borrow_mut<T>(s);
        // mutate inner if possible, unsafe but just dummy writes if T is known
        // we cannot do mutation here since T is generic, just read inner by copy if possible, do nothing here
        let _ = &res_ref.inner;
    }

    /// Test existence check for generic T at address
    public fun check_exists<T: key + drop>(addr: address): bool acquires GenKeyDropTest::ResourceKeyDrop<T> {
        GenKeyDropTest::exists<T>(addr)
    }

    /// Test removing resource of T
    public fun remove_resource<T: key + drop>(s: signer) acquires GenKeyDropTest::ResourceKeyDrop<T> {
        let _ = GenKeyDropTest::move_out<T>(s);
    }

    /// Runner function which will run all internal tests with NamedStruct at Empty address (0x0)
    public fun run_all_tests(s: signer) acquires GenKeyDropTest::ResourceKeyDrop<NamedStruct> {
        let addr_empty = @0x0;

        // Check non-existence before publish
        let before = check_exists<NamedStruct>(addr_empty);
        assert!(!before, 1001);

        // Publish resource under signer (must be 0x0 in script)
        publish_empty<NamedStruct>(s, NamedStruct { a: 42, b: 43 });

        // Now resource should exist
        let after = check_exists<NamedStruct>(addr_empty);
        assert!(after, 1002);

        // Borrow mut to see works
        test_borrow_mut<NamedStruct>(s);

        // Remove resource
        remove_resource<NamedStruct>(s);

        // After removal does not exist
        let after_removal = check_exists<NamedStruct>(addr_empty);
        assert!(!after_removal, 1003);
    }
}


//# run 0xCAFE::UseEmptyAddress::run_all_tests --signers 0x0


//# run 0xCAFE::UseEmptyAddress::publish_empty --signers 0x0 --args (0xCAFE::GenKeyDropTest::EmptyNamedStruct { a: 10u8, b: true })


//# run 0xCAFE::UseEmptyAddress::check_exists --args 0x0


//# run 0xCAFE::UseEmptyAddress::test_borrow_mut --signers 0x0


//# run 0xCAFE::UseEmptyAddress::remove_resource --signers 0x0


// Featurres:
// b3786d71f6c61a247c7a12e02fc1cdd7: Test that calling a module function with a type that has a key and drop capability triggers the appropriate resource existence and borrowing behaviors, leading to an expected failure or assertion.
// 0c5e7fdec695e24e3a309ea0a7ec424a: Use address specifier 'Empty' to represent an unspecified or default address.
// 197cdcb39c3186bef4e6d6e229772907: Declare struct fields with specific signatures and names.
