//# publish
module 0xCAFE::TestModuleWithSpecAndLogging {
    use std::debug;
    use std::signer;

    spec foo_spec_var: u64;

    struct Logger {
        dummy: bool, // just a placeholder
    }

    /// A struct with a function-typed field.
    struct FunStruct {
        f: fn(u64): u64,
    }

    public fun create_fun_struct(): FunStruct {
        let closure = fun (x: u64): u64 { x + 1 };
        FunStruct { f: closure }
    }

    public fun call_fun_struct(fs: &FunStruct, val: u64): u64 {
        // invoke the function field
        (fs.f)(val)
    }

    /// Log some messages to test logging
    public fun test_logging(s: &signer) {
        debug::print(&"Logging msg from test_logging");
        debug::print(&"Value is 42");
        debug::print(&"Logging with signer address:");
        debug::print(&signer::address_of(s));
    }

    /// Runner function that exercises the above
    public fun runner(s: &signer) {
        // Use the spec variable in an invariant to exercise spec typing
        spec {
            foo_spec_var: u64 = 123;
        }
        test_logging(s);

        let fs = create_fun_struct();
        let _res = call_fun_struct(&fs, 99);
        // No assertions needed for testing; just run the code
    }
}
//# run 0xCAFE::TestModuleWithSpecAndLogging::runner --signers 0xCAFE

//# run
script {
    use 0xCAFE::TestModuleWithSpecAndLogging;
    use std::signer;

    fun main(s: signer) {
        TestModuleWithSpecAndLogging::runner(&s);
    }
}

// Featurres:
// 7f194944ff993f9e657b4781aa70c7c3: Specify the type of a spec variable after a colon.
// fc50351db335dfe10d9caea5c5e31256: Configure logging for applications during development.
// 2dcaf4d44e1044060a6d017696e23c8b: Test that structs with function-typed fields can be declared, instantiated with a closure, and invoked inside a Move module.
