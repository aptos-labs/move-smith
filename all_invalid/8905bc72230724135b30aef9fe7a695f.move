
//# publish
module 0xCAFE::FunctionPointerTest {
    // Define a trait for function pointers with a specific signature
    public trait FnTrait {
        fun call(arg: u8): u8;
    }

    // Struct that holds a function pointer implementing FnTrait
    struct FunctionHolder has copy, drop {
        func: fn(arg: u8): u8
    }

    // Function to assign a closure (here, a function) to FunctionHolder
    public fun create_holder_with_closure() : FunctionHolder {
        let closure: fn(arg: u8): u8 = |a: u8| { a + 10 };
        let holder = FunctionHolder { func: closure };
        holder
    }

    // Function to invoke the function pointer inside FunctionHolder
    public fun invoke_holder(holder: &FunctionHolder, input: u8): u8 {
        (holder.func)(input)
    }

    // Deprecated module example for awareness (simulate deprecated code)
    
//# deprecated
//# publish
    module 0xDEAD::DeprecatedModule {
        // Simulate deprecated functionality
        public fun old_function() {
            // deprecated code
        }
    }

    // Function with explicit type parameters to check type parameter handling
    public fun generic_function<T>(x: T): T {
        x
    }

    // Runner function to test all features
    public fun run_tests() {
        let holder = create_holder_with_closure();
        let result = invoke_holder(&holder, 5u8);
        // Here, result should be 15
    }
}


//# run 0xCAFE::FunctionPointerTest::run_tests


// Featurres:
// 16ebec736c0d57d844a0829a22f216f4: Test that defining a struct with a function pointer trait and assigning a closure to it correctly evaluates the closure's logic when invoked.
// 1f09a30deb5ade0317891861ec701274: Identify deprecated modules in your code via annotations to be aware of their deprecated status.
// 1f390eda5af7e78edd4d96e25ae0e19f: Define functions with explicit type parameters (type parameter checks)
