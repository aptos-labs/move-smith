
//# publish
module 0xCAFE::SpecModuleTest {
    // Spec modules cannot declare functions, structs or constants directly:
    // so leave the spec module empty or only with spec code (not shown).
    spec module SpecModuleTest {
        // The following declarations should cause errors if uncommented:
        //
        // fun spec_fun(): bool {
        //     true
        // }
        //
        // struct SpecStruct {
        //     x: u8,
        // }
        //
        // const SPEC_CONST: u8 = 1;
    }
}

struct SimpleStruct has copy, drop, store {
    a: u8,
    b: u64,
}

struct ComplexStruct has store, key {
    nested: SimpleStruct,
    flag: bool,
}

// Annotation attribute values with numerical and named addresses
// test_attr(address = 0xCAFE)]
// check(address = @0xCAFE)]
// owner(address = 0xABCD)]
// creator(address = @0xABCD)]



//# publish
module 0xCAFE::AnnotationAttrTest {
    use std::signer;

    // Add key ability since move_to requires it
    struct Dummy has store, key {}

    public fun create_dummy(s: signer) {
        move_to<Dummy>(&s, Dummy {});
    }

    public fun dummy_ret(): 0xCAFE::SimpleStruct {
        0xCAFE::SimpleStruct { a: 5, b: 100 }
    }
}



//# run 0xCAFE::AnnotationAttrTest::create_dummy --signers 0xBEEF



//# run 0xCAFE::AnnotationAttrTest::dummy_ret


// Features:
// b67838f01f1672912a7cabc235296ed0: Include `struct` definitions in the module output.
// 6944f68830d8207340ad171d16b914ef: Use both numerical and symbolic (named) addresses as attribute values in annotations.
// 00d5da4c654d1d499b3f0e3337e544be: Receive error messages if you declare Move functions, structs, or constants directly inside a specification module
