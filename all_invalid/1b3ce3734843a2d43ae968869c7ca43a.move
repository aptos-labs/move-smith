
//# publish
module 0xBABE::DeprecationTest {
    // Simulate a namespace of multiple modules with deprecation attribute
    // (Note: No actual attribute support; actual test involves attempting to access modules)
    //! deprecated: do not use

//# publish
    module NamespaceA {
        public fun fake_func(): u8 {
            42
        }
    }


//# publish
    module NamespaceB {
        public fun another_func(): u8 {
            100
        }
    }
}



//# publish
module 0xCAFE::FuncUtils {
    // Utility to test function pointer assignment, passing, invocation
    public fun identity<T>(x: T): T {
        x
    }

    public fun call_with_args<F, T>(func: F, arg: T): T
    where
        F: (T) -> T {
        func(arg)
    }
}



//# publish
module 0xCAFE::GenericFunctions {
    // Generic function with type parameter
    public fun type_param_example<T: store>(x: T): T {
        x
    }

    // Function taking type parameters via index (simulated via explicit type parameter)
    public fun instantiate_generic<T: store>(x: T): T {
        x
    }
}



//# publish
module 0xCAFE::Conditions {
    // Store condition property as a function returning a boolean (simulate property)
    public fun is_active(): bool acquires DummyState {
        true
    }

    public fun check_and_act(): u8 {
        if (Self::is_active()) {
            // Do something
            1u8
        } else {
            0u8
        }
    }
}



//# publish
module 0xCAFE::TransitiveCalls {
    // Non-inline public function calling a private function
    public fun transitively_invoke(): u8 {
        helper_func()
    }

    fun helper_func(): u8 {
        // do something
        123u8
    }
}



//# run 0xBABE::DeprecationTest::NamespaceA::fake_func --args
// Attempt to call deprecated namespace module (expected to warn or error in actual compiler if supported)



//# run 0xBABE::DeprecationTest::NamespaceB::another_func --args



//# run 0xCAFE::FuncUtils::identity --args 123u64


//# run 0xCAFE::FuncUtils::call_with_args --args 0xCAFE::FuncUtils::identity 456u64



//# run 0xCAFE::GenericFunctions::type_param_example --args 789u64


//# run 0xCAFE::GenericFunctions::instantiate_generic --args 999u64



//# run 0xCAFE::Conditions::check_and_act --args



//# run 0xCAFE::TransitiveCalls::transitively_invoke --args


// Features:
// c1367d37b2075aa6fdcc5740b3ac2c36: Attach deprecation attributes at the address (namespace) level to mark all modules under it as deprecated.
// c75b5002236cb27e7430836ca3ad0a31: Test that functions (including generic functions) can be used as first-class values—assigned to variables, passed as closures and function pointers, and invoked as arguments or with type arguments.
// 0f26324d5bfccb30b1fbc5010a2360ab: Declare condition properties enclosed in brackets in your code.
// 678e6ff726e24c9cffca1d8bd263c5d8: Use type parameters by referencing them with an index to support generic type definitions.
// 83ae541e328416c20a4466daa88b7654: Automatically include functions that are transitively called by public (non-inline) target functions in bytecode generation
