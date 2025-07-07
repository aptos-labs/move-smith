
//# publish
module 0xCAFE::ShadowTest {
    use std::debug;
    use 0xCAFE::MyModule;

    public fun shadow_lambda(x: u8, f: |u8|u8): u8 {
        // Here, 'f' shadows any imported function named 'f'
        f(x)
    }

    public fun test_shadow() {
        // Define a lambda shadowing MyModule::f1
        let f1: |u8, bool| u8 = |x: u8, y: bool| {
            let _shadowed = MyModule::f1(x, y); // explicitly call the imported function
            x + 10
        };

        // Use lambda shadowing MyModule::f1 name but different signature captured as f1
        let res = f1(2u8, true);

        // Call the shadow_lambda with a lambda that shadows MyModule::f1 name inside parameter 'f'
        let r2 = shadow_lambda(5u8, |x: u8| {
            // This inner lambda shadows MyModule::f1 as parameter name doesn't conflict with import
            x * 2
        });

        // Use MyModule::f1 explicitly with direct call
        let _ = MyModule::f1(3u8, false);

        // No assertions, just run to test shadows and calls
    }

    public fun runner() {
        test_shadow();
    }
}


//# run 0xCAFE::ShadowTest::runner

// The following are lint directives and compiler diagnostic configuration comments.
// These do not belong inside a module and must be on top-level.

//! // skip(unused_variable)]
//! // skip(unreachable_code)]
//! #! compiler-terminate-on-error level=Error


// Featurres:
// 0c6264ced8632d23808d99abd623d46c: Test that function parameters can correctly shadow imported module functions with the same name, including in the context of function parameters passed as lambdas.
// a99471d2ea89cf76f0ccd0486eb6abcd: Configure your code with `#[skip(lint_name)]` attributes to customize lint enforcement according to your preferences.
// f48f01c31a1fbec319be6b03a383a9bf: Trigger compiler exit on diagnostics with severity higher than Warning.
