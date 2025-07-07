
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
        // Unpack the struct to avoid implicit drop issue
        let DeprecatedStruct { value } = val;
        value
    }
}


//# run 0xCAFE::DeprecatedFeatures::deprecated_function


//# run 0xCAFE::DeprecatedFeatures::use_deprecated_struct --args 42u64


//# run 0xCAFE::DeprecatedFeatures::DeprecatedStruct --signers 0xCAFE --args 100u64