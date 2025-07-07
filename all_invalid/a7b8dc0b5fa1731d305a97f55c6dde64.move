
//# publish
module 0xCAFE::UnusedVarsTest {
    use std::vector;

    struct MyStruct has copy, drop, store {
        a: u8,
        b: u8,
    }

    struct MyResource has store, key {
        inner: MyStruct,
        count: u64,
    }

    public fun test_unused_vars(x: u8, y: u8): u8 {
        let a = x; // used
        let b = y; // used
        let c = a + b; // used
        let _unused1 = 42; // unused variable, should warn
        let _unused2 = 7; // unused variable, should warn

        // Intentionally unused variables in function scope
        let d = c;
        let e = a * b;

        // Update mutable variable
        d = d + e as u8;
        d
    }

    public fun create_resource_and_access_fields() {
        let signer_addr = 0xCAFE;
        let s = signer::borrow_global_mut<MyResource>(signer_addr);
        // Borrowing resource mutably
        let resource_ref: &mut MyResource = s;

        // Access nested struct field (immutable borrow)
        let inner_ref: &MyStruct = &resource_ref.inner;

        // Read fields from nested struct
        let a_field = inner_ref.a;
        let b_field = inner_ref.b;

        // Mutably borrow the nested struct to update fields
        resource_ref.inner.a = a_field + 1;
        resource_ref.inner.b = b_field + 1;

        // Read updated fields
        let updated_a = resource_ref.inner.a;
        let updated_b = resource_ref.inner.b;
    }

    public fun init_resource() {
        let signer_addr = 0xCAFE;
        let resource = MyResource {
            inner: MyStruct { a: 1, b: 2 },
            count: 10,
        };
        move_to<MyResource>(&signer_addr, resource);
    }
}


//# run 0xCAFE::UnusedVarsTest::test_unused_vars --args 5u8 10u8


//# run 0xCAFE::UnusedVarsTest::create_resource_and_access_fields --signers 0xCAFE


// Featurres:
// d1ff22fd96533f18059b24a9a0b9404f: Define function parameters and local variables, and receive warnings or errors if any are unused
// d840b70fed6bcaf6937925a725f68655: Declare module members with optional 'public' visibility modifier
// ee6f8ac25bdd718f7f30665bcd7dff2c: Test that referencing immutable and mutable borrows of a resource with nested structs correctly allows reading their fields and updating mutable references without causing conflicts.
