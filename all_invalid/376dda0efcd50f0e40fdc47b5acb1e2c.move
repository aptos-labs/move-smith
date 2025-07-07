
//# publish
module 0xCAFE::AddressedModule {
    /// Returns the module address in hex string format.
    public fun module_address_hex(): vector<u8> {
        b"0xCAFE"
    }

    /// A simple function to confirm public spec extraction.
    public fun greet(): vector<u8> {
        b"Hello from CAFFE!"
    }
}


//# publish
module AddresselessModule {
    /// Returns the default address as hex string (simulated).
    public fun default_address_hex(): vector<u8> {
        b"0x0000000000000000000000000000000000000000"
    }

    /// A simple function to confirm public spec extraction without explicit address.
    public fun greet(): vector<u8> {
        b"Hello from no address!"
    }
}


//# publish
module 0xCAFE::ModuleWithWarning {
    /// Function always returns 1 but already deprecated for demo warnings.
    // deprecated]
    public fun deprecated_func(): u8 {
        1
    }

    /// Function with unused variable simulating a warning.
    public fun unused_variable_warning() {
        let _unused: u8 = 42;
        // Nothing uses _unused explicitly, for warning test
    }
}


//# publish
module 0xCAFE::ModuleWithErrors {
    /// Function with a deliberate abort for diagnostic errors.
    public fun explicit_abort() {
        assert!(false, 12345);
    }

    /// Function with type mismatch (should trigger error)
    // Note: This won't compile if uncommented; simulate error by calling.
    // public fun type_mismatch(): u8 {
    //     let x: u8 = 1u64;
    //     x
    // }
}

/// Wrapper inside a public function to simulate failed check + diagnostic reporting
public fun test_combined_conditions() {
    let x: bool = true;
    if (x) {
        // dummy to trigger potential diagnostic
        let _unused = 5;
    };
}

/// Wrapping call to deprecated function, to test warnings on call-site.
public fun call_deprecated_warn() {
    let _ = 0xCAFE::ModuleWithWarning::deprecated_func();
}

/// Wrapping call to explicit abort, to test error catching.
public fun call_explicit_abort() {
    0xCAFE::ModuleWithErrors::explicit_abort();
}


//# run 0xCAFE::AddressedModule::greet


//# run AddresselessModule::greet


//# run 0xCAFE::ModuleWithWarning::deprecated_func


//# run 0xCAFE::ModuleWithWarning::unused_variable_warning


//# run 0xCAFE::ModuleWithErrors::explicit_abort


//# run 0xCAFE::AddressedModule::module_address_hex


//# run AddresselessModule::default_address_hex


//# run 0xCAFE::ModuleWithWarning::deprecated_func


//# run 0xCAFE::AddressedModule::greet


//# run 0xCAFE::ModuleWithErrors::explicit_abort


//# run 0xCAFE::ModuleWithErrors::explicit_abort


//# run 0xCAFE::AddressedModule::module_address_hex


//# run 0xCAFE::ModuleWithWarning::unused_variable_warning


//# run 0xCAFE::ModuleWithErrors::explicit_abort


//# run 0xCAFE::ModuleWithErrors::explicit_abort


//# run 0xCAFE::ModuleWithWarning::deprecated_func


//# run 0xCAFE::ModuleWithWarning::unused_variable_warning


//# run 0xCAFE::ModuleWithErrors::explicit_abort


//# run 0xCAFE::AddressedModule::greet


//# run 0xCAFE::ModuleWithWarning::deprecated_func


//# run 0xCAFE::ModuleWithErrors::explicit_abort


//# run 0xCAFE::AddressedModule::greet


//# run 0xCAFE::ModuleWithErrors::explicit_abort


//# run 0xCAFE::AddressedModule::module_address_hex


//# run 0xCAFE::ModuleWithWarning::deprecated_func


//# run 0xCAFE::ModuleWithWarning::unused_variable_warning


//# run 0xCAFE::ModuleWithErrors::explicit_abort


//# run 0xCAFE::ModuleWithWarning::deprecated_func


//# run 0xCAFE::ModuleWithWarning::unused_variable_warning


//# run 0xCAFE::ModuleWithErrors::explicit_abort


//# run 0xCAFE::ModuleWithWarning::deprecated_func


//# run 0xCAFE::ModuleWithErrors::explicit_abort


// Featurres:
// 2f1176a50aedba7210a09e1b87c0dc65: Define a module with a specific address or default address.
// 13df41857e7eace81575b0e86c8533d2: Extract and display the public specification of a Move module for documentation or review.
// df2e3b22b8378d90289589082d35d479: Report diagnostics and exit if any error or higher severity diagnostic is present.
