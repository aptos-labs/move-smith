//# publish
module 0xCAFE::NativeFunctions {
    use std::signer;

    native public fun native_no_body();

    native public fun native_with_body(): u8;

    public fun call_native_with_body(): u8 {
        native_with_body()
    }

    // Wrapper function to use signer argument
    public fun call_native_with_signer(s: signer): u8 {
        native_with_body() + 1u8
    }
}

//# run 0xCAFE::NativeFunctions::call_native_with_body

//# run 0xCAFE::NativeFunctions::call_native_with_signer --signers 0xD00D

//# publish
module 0xCAFE::DiagnosticsTest {
    use std::vector;

    // This module has some deliberate issues for diagnostics

    // Commented out code that would cause error if uncommented: 
    // functon typo instead of function
    // functon error_func() {}

    // Deliberate type mismatch variable usage
    public fun diagnostic_fun(): u8 {
        let x = 3u8;
        // let x = "string"; // This would cause a type error
        x
    }

    public fun another_fun() {
        let mut v = vector::empty<u8>();
        vector::push_back(&mut v, 1u8);
        // vector::push_back(&mut v, true); // compilation error: bool used instead of u8
    }
}

//# run 0xCAFE::DiagnosticsTest::diagnostic_fun

//# run 0xCAFE::DiagnosticsTest::another_fun

//# publish
module 0xCAFE::AliasUsage {
    use 0xCAFE::NativeFunctions as NF;

    public fun call_alias_native(): u8 {
        NF::native_with_body()
    }

    public fun call_alias_native_via_wrapper(): u8 {
        NF::call_native_with_body()
    }
}

//# run 0xCAFE::AliasUsage::call_alias_native

//# run 0xCAFE::AliasUsage::call_alias_native_via_wrapper