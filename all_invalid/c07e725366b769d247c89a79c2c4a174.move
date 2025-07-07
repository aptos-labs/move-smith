
//# publish
module 0xCAFE::DuplicateStructTest {
    // Define a struct with a unique name
    struct UniqueStruct has copy, drop, store {
        data: u64
    }

    // Attempt to define another struct with the same name should trigger an error
    // In a real scenario, the compiler should catch this as a duplicate.
    // For testing purposes, we showcase how defining a duplicate would appear.
    // Uncommenting the below will produce a compiler error, representing the test.
    /*
    struct UniqueStruct has copy, drop, store {
        data: u64
    }
    */
}



//# publish
module 0xCAFE::AliasConflict {
    // Define two different modules with the same name should produce an error
    // For testing, simulate duplicate module definition by declaring same module twice

    // First declaration
    module ModuleA {
        struct Data { value: u8 }
    }

    // Duplicate module declaration with same name that should cause a compiler error
    /*
    module ModuleA {
        struct DataAgain { value: u8 }
    }
    */
}



//# publish
module 0xCAFE::DeprecateMembers {
    // Deprecating module members - in Move, attributes can be used for deprecation.
    // Here's an example of marking a function as deprecated.

    // To mark a function as deprecated, you'd typically add an attribute,
    // but Move currently doesn't have a built-in deprecation attribute.
    // Instead, simulate by commenting or custom attribute if supported.

    // Declaring an active (non-deprecated) function
    public fun active_function() {
        // regular function
    }

    // Declaring a deprecated function (simulate via comment)
    // deprecated] // Note: Move doesn't natively support this attribute; this is conceptual
    public fun deprecated_function() {
        // this function is marked as deprecated
    }

    public fun use_deprecated() {
        // Internal call to deprecated function
        deprecated_function()
    }
}



//# run 0xCAFE::DuplicateStructTest::UniqueStruct --signers 0xBEEF



//# run 0xCAFE::AliasConflict::ModuleA::Data --signers 0xBEEF



//# run 0xCAFE::DeprecateMembers::use_deprecated --signers 0xBEEF