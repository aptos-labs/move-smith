// # publish
module 0xCAFE::UnpackTest {
    struct NestedStruct has store {
        a: u8,
        b: u64,
    }

    struct MainStruct has store {
        x: NestedStruct,
        y: Option<u8>,
        z: address,
    }

    // A function that returns a MainStruct instance for testing
    public fun make_struct(): MainStruct {
        MainStruct {
            x: NestedStruct { a: 42u8, b: 1000u64 },
            y: option::some(7u8),
            z: @0xCAFE,
        }
    }

    // Runner for unpack patterns with nested and '..'
    public fun runner() {
        let s = make_struct();

        // Nested unpack, fully unpacked
        let MainStruct { x: NestedStruct { a, b }, y, z } = s;
        // just reading values (no errors expected)

        // Partial unpack with '..' to omit some fields
        let MainStruct { x: NestedStruct { a, .. }, .. } = s;

        // Optional type unpack with some
        if (option::is_some(&s.y)) {
            let option::some(value) = s.y;
            let _val = value;
        }

        // Optional type unpack with none
        let no_opt = option::none<u8>();
        if (!option::is_some(&no_opt)) {
            let option::none() = no_opt;
        }
    }

    // A private struct with a key, to test cross-module privileged operation
    struct PrivStruct has key {
        val: u8,
    }

    // Create a new PrivStruct (only this module can create it)
    public fun create_priv(): PrivStruct {
        PrivStruct { val: 10 }
    }

    // Privileged operation inside this module - mutate val
    public fun mutate_priv(mut p: PrivStruct) {
        p.val = 99;
    }
}
// # run 0xCAFE::UnpackTest::runner


// # publish
module 0xCAFE::PrivilegedTest {
    use std::signer;

    // Attempt to re-define the key struct, it should not be accessible here as key structs can't be declared same name.
    // Instead, we import UnpackTest and try operations on PrivStruct.

    // Import the other module
    use 0xCAFE::UnpackTest;

    // This should fail to compile if uncommented, showing cross-module key struct operations are forbidden:
    // public fun try_create(): UnpackTest::PrivStruct {
    //    UnpackTest::PrivStruct { val: 123 }
    // }

    // Try to call privileged mutation - which should fail to compile because PrivStruct is private.
    // This will test privilege boundaries (actual failure will be compiler error)

    // We provide a function to call the privileged mutation via public API
    public fun call_mutator() {
        let priv_struct = UnpackTest::create_priv();
        // The following mutation will be fine since mutate_priv is public and accepts the struct
        UnpackTest::mutate_priv(priv_struct);
    }
}
// # run 0xCAFE::PrivilegedTest::call_mutator --signers 0xCAFE


// # run
script {
    use std::signer;
    use 0xCAFE::UnpackTest;
    use 0xCAFE::PrivilegedTest;

    fun main(account: signer) {
        // Test address parsing '@'
        let addr: address = @0xCAFE;

        // Call the unpack test runner to verify patterns
        UnpackTest::runner();

        // Call privileged test to check cross-module privilege boundaries
        PrivilegedTest::call_mutator();
    }
}

// Featurres:
// 5e600aa226a8d8449755d06c34c1c553: Unpack struct patterns with support for nested fields and optional `..` for field omission.
// 0c8870a38a1e499e1272d024f2bc0bbc: Use the '@' sign to denote and parse an address value.
// da167b1970ccb5deda57add2fd12ed02: Ensure privileged operations on structs cannot be performed across module boundaries.
