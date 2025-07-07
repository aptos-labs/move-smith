//# publish
module 0xCAFE::TestStructFeatures {
    /// This struct is used to test unpacking and field access.
    struct TestStruct has copy, drop {
        a: u64,
        b: u128,
    }

    /// Deprecated struct to test deprecation warnings.
    #[deprecated]
    struct DeprecatedStruct has copy, drop {
        x: u8,
        y: u8,
    }

    /// Function to create a TestStruct instance.
    public fun create_struct(a: u64, b: u128): TestStruct {
        TestStruct { a, b }
    }

    /// Function to create a DeprecatedStruct instance.
    public fun create_deprecated_struct(x: u8, y: u8): DeprecatedStruct {
        DeprecatedStruct { x, y }
    }

    /// Expose the deprecated struct creation for testing deprecation warnings.
    public fun get_deprecated_struct() {
        let _ = create_deprecated_struct(1, 2);
    }
}

//# run 0xCAFE::TestStructFeatures::create_struct
#[test]
fun test_unpacking_and_fields() {
    let s = 0xCAFE::TestStructFeatures::create_struct(42, 1000);
    // Unpack into individual variables
    let TestStruct { a, b } = s;
    // We can add assertions here if needed
}

//# run 0xCAFE::TestStructFeatures::get_deprecated_struct
#[test]
fun test_deprecation_warning() {
    // This should trigger a compiler warning about deprecated usage
    0xCAFE::TestStructFeatures::get_deprecated_struct();
}

//# publish
module 0xCAFE::MetadataAnnotations {
    /// Derived documentation attribute
    #[doc = "This module contains annotated functions for metadata testing."]
    public fun annotated_func() {}

    /// Function with custom attributes for metadata testing
    #[my_custom_attribute]
    public fun custom_metadata() {}
}

//# run 0xCAFE::MetadataAnnotations::annotated_func --signers 0xCAFE
//# run 0xCAFE::MetadataAnnotations::custom_metadata --signers 0xCAFE

// Features:
// e1d98ba16aeb5b5874fc6a31b9eda823: Unpack struct types in assignments with specified fields.
// b2a04f5a0e0ae5a6de09d743766345e2: Receive deprecation warnings in the Move compiler when using members tagged as deprecated in either the same module or from an imported module.
// 08aa38b120e4d4d8871c242a85c0b751: Add documentation comments and custom attributes to Move modules and their members for improved code annotation and metadata.