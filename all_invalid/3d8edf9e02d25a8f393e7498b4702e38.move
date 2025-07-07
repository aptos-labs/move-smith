
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
    
    // Removed the invalid '
//# deprecated' comment to avoid parsing errors
    
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
