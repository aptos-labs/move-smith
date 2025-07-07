
//# publish
module 0xCAFE::DeprecatedFeatures {
    #[deprecated]
    public fun deprecated_function() {
        // Function body
    }

    #[deprecated]
    struct DeprecatedStruct {
        value: u64,
    }

    public fun use_deprecated_struct(val: DeprecatedStruct): u64 {
        val.value
    }
}


//# run 0xCAFE::DeprecatedFeatures::deprecated_function

//# run 0xCAFE::DeprecatedFeatures::use_deprecated_struct --args 42u64

//# run 0xCAFE::DeprecatedFeatures::DeprecatedStruct --signers 0xCAFE --args 100u64

// Featurres:
// 2727731fcfe3c6a7fa9707320adbd25a: Mark member items (such as functions, structs, or constants) as deprecated using Move's #[deprecated] annotation to signal their deprecation to users.
// 189a1678fa3db99f51a1711cdf62e162: Use public or internal visibility modifiers on spec apply patterns
// aedf10f6119c777fd675653e9b2f4a02: Write Move code using standard bytecode constructs to allow the compiler to automatically run peephole optimizations for improved performance.
