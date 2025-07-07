
//# publish
module 0xCAFE::SpecAndInlineTest {
    use std::vector;
    use 0xCAFE::MyModule;

    // This module is for testing merging specifications and implementations

    // Note: Move does not support nested modules. The 'spec' module has been removed from inside.
    // If needed, specifications can be represented through other means, such as comments or attributes.

    // Implementation of the actual module
    // (Already exists: 0xCAFE::MyModule)

    // Function calling inside implementation that involves inline functions
    public fun call_inline_func(a: u16): u16 {
        // Call an inline function
        MyModule::f2(a).0 + MyModule::f2(a).1
    }

    // Function that triggers a parsing error at EOF (simulate)
    public fun trigger_eof_error() {
        // Incorrectly terminate an expression to simulate unexpected EOF
        // Move the code to cause parse error intentionally
        // This code is invalid and should lead to parse error if compiled
        0x1 + // EOF here, should cause parser to report an unexpected EOF token
    }

    // Wrapper to invoke the above to test parser error
    public fun run_eof_test() {
        trigger_eof_error();
    }
}



//# run 0xCAFE::SpecAndInlineTest::call_inline_func --args 100u16
// The above will test function involving inlining and call correctness



//# run 0xCAFE::SpecAndInlineTest::run_eof_test
// The above will test parser's handling of unexpected EOF token