
//# publish
module 0xCAFE::CaptureExample {
    public fun run_lambda_capture(): u8 {
        let captured: u8 = 10u8;
        let lambda: |u8|u8 has copy+drop = |x: u8| {
            x + captured
        };
        lambda(5u8)
    }
}


//# run 0xCAFE::CaptureExample::run_lambda_capture


//# publish
module 0xCAFE::UnboundExample {
    // Intentionally import a non-existing module to test unbound module warning.
    use 0xCAFE::NonExistentModule;

    // Intentionally import a non-existing member from MyModule.
    use 0xCAFE::MyModule::{non_existing_function};

    public fun dummy(): u8 {
        42u8
    }
}


//# run 0xCAFE::UnboundExample::dummy


// Featurres:
// fb1e25ca90c27954dba599d551f1cf59: Use named addresses in module references to resolve modules.
// 14b8844f8e1d8d6ab35f01cacb9f4778: Define and use lambda functions (anonymous functions), including capturing variables.
// 7c3bd925de3d03822b5b214c14044e50: Perform validity checks and warn about unbound modules or members when importing.
