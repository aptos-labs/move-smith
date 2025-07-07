
//# publish
module 0xBABE::ParseTrailingCommaTests {
    // Access specifiers with optional trailing comma
    public ,  // Should be accepted as syntax error-free (but invalid in real code)
    public,  // Proper syntax
    public, // Proper syntax
    public , // Proper syntax, trailing comma at end
}
// Expect parse success or specific syntax errors for invalid syntax


//# publish
module 0xCAFE::VersionFeatures {
    // Suppose `native` functions require Move v2
    // For older versions, this should produce an error
    public native fun native_func(): bool;
}
// Attempt to compile with an older Move version (e.g., v1), expect a version error


//# publish
module 0xF00D::RestrictedNames {
    // Restricted module name example
//# publish
    module 0xBADF::InvalidModule { } // Error: cannot use "0xBADF" as a module name
    // Function with restricted name
    fun restricted() { }
    // Variable with restricted name
    let public = 1; // Error: 'public' is a reserved keyword
}
// These should trigger clear errors about reserved or invalid names


//# publish
module 0xDEAD::CombinedSyntax {
    // List with optional trailing comma including a feature that is only in Move v3
    public, // Valid, should parse
    public, // Trailing comma accepted
    // Attempt to define a feature that requires a higher version
    public native fun new_native_feature(): bool; // Requires Move v3
}
// Expect either parse success with warning/error if version too low, or specific error about 'native' and version mismatch


//# publish
module 0xBADD::ErrorCase {
    // Restricted name but with newer syntax
    fun public() { } // Error: 'public' is a reserved keyword (or restricted name)
    fun normal() {
        // inside function, use an access modifier that doesn't exist
        // Cannot annotate functions with reserved keywords
    }
    // Using a reserved variable name with newer syntax
    let native = true; // 'native' may be reserved or restricted; expect error
}
// These tests should produce precise errors indicating misuse of reserved names


//# publish
module 0xFEED::VersionMismatch {
    // Attempt to declare a feature only available in a future version
    // version = "3"]
    public fun future_feature() { }
}
// Expect an error about missing or incompatible version attribute


//# publish
module 0xCAFE::LegacySupport {
    // Functions using only basic features
    public fun simple(): u8 { 42 }
    // Usage of optional trailing commas should not affect parsing
}
// Expect success if syntax is valid, no errors


// Featurres:
// 7f11eead1c9592429aab953f8054c037: Allow optional trailing commas in access specifier lists.
// bbbc9c0cd146e4bac89b8e3b9201cf08: Use language features that require a specific minimum Move language version.
// d877c8510ec718ba1a581eca0d7a5155: Receive clear error messages when attempting to use a restricted name for a Move construct such as a module, function, or variable.
