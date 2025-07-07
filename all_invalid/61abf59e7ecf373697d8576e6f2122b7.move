//# publish
module 0xCAFE::DeprecationExample {
    use std::vector;

    #[deprecated(reason = "Use new_function instead")]
    public fun old_function(x: u8): u8 {
        x + 1
    }

    public fun new_function(x: u8): u8 {
        x + 2
    }

    #[deprecated(reason = "Use new_runner instead")]
    public fun deprecated_runner() {
        let _ = old_function(10u8);
    }

    public fun new_runner() {
        let _ = new_function(10u8);
    }

    // Function with decreases on parameter for formal verification and termination analysis
    public fun countdown(x: u8) decreases x {
        if (x > 0) {
            countdown(x - 1);
        };
    }
}

//# publish
module 0xCAFE::UseErrorsAndWarnings {
    // Intentionally attempt to import a non-existent module "NonExistentModule"
    // and a non-existent member "foo" from 0xCAFE::DeprecationExample
    // This will trigger errors during compilation.
    use 0xCAFE::NonExistentModule;
    use 0xCAFE::DeprecationExample::foo;

    public fun call_non_existent() {}

    public fun call_old_function_warn() {
        // This should trigger a deprecation warning
        let _ = 0xCAFE::DeprecationExample::old_function(5u8);
    }
}

//# run 0xCAFE::DeprecationExample::deprecated_runner

//# run 0xCAFE::DeprecationExample::new_runner

//# run 0xCAFE::DeprecationExample::countdown --args 5u8

// Featurres:
// b18d7f32e3012062b8b94d90af97ab7f: Write 'decreases' specifications for functions to aid formal verification and termination analysis.
// 8a52e53179eaf73ebe0e390d10c6133d: Receive errors if you attempt to import a non-existent module or a non-existent member in a 'use' statement.
// b2a04f5a0e0ae5a6de09d743766345e2: Receive deprecation warnings in the Move compiler when using members tagged as deprecated in either the same module or from an imported module.
