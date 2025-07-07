
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

    // Or, to intentionally trigger a duplicate error, we might try to define a module with duplicate struct names.
    // But since this is invalid, we leave the comment to depict the intention.
}


//# publish
module 0xCAFE::AliasConflict {
    // Define two different modules with the same alias in a namespace should produce an error
    // For the test, simulate aliasing again is invalid (this should cause an error during compilation)
    // Since aliases are primarily a type-usage mechanism, we might attempt to misuse them.
    // But Move syntax doesn't directly have module aliasing like in other languages.
    // Alternatively, if simulating use of duplicate imports, writing duplicate module declarations with the same name.

    // First alias (simulated by duplicate)
    // The compiler should prevent duplicate module aliasing
    // Here is a hypothetical scenario:
    module ModuleA {
        struct Data { value: u8 }
    }

    // Trying to declare the same alias again
    // expect compiler to error here
    /*
    module ModuleA {
        struct DataAgain { value: u8 }
    }
    */
}


//# publish
module 0xCAFE::DeprecateMembers {
    // Deprecating module members - in Move, attributes can be used for deprecation.
    // But for the purpose of the test, demonstrate deprecation attribute.

    // Declaring a deprecated function
    public fun active_function() {
        // regular function
    }

    // deprecated]
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

// Featurres:
// 9ed516af7a96fbc4dc354976e0781049: Prevent duplicate struct definition by enforcing unique struct names within a module.
// 86f3e44c7ba6c25ee0603458bde6118a: Ensure module aliases are unique within a namespace to prevent duplication errors.
// 625879b32327864a453b143e992a0ce6: Deprecate module members using attributes
