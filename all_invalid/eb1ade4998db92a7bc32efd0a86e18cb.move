
//# publish
module 0xCAFE::TestModule {
    // Attributes declarations (for illustrative purposes, attributes don't have runtime effects in Move)
    #[my_attr]
    const MY_CONST: u8 = 1;

    #[my_attr = 10]
    const MY_CONST2: u64 = 20;

    #[my_attr(param)]
    const MY_CONST3: bool = true;

    // Function to be invoked in different styles
    public fun target_function(x: u64): u64 {
        x + 1
    }

    // Static variable to hold a function pointer (not directly supported in Move; illustrating concept)
    // Instead, we simulate different invocation styles via public functions
    public fun call_direct(x: u64): u64 {
        target_function(x)
    }

    public fun call_via_variable(x: u64): u64 {
        let func = target_function;
        func(x)
    }

    public fun call_via_lambda(x: u64): u64 {
        let lambda = |y: u64| target_function(y);
        lambda(x)
    }

    // Specification example (Move doesn't support contract annotations, so we illustrate as comments)
    // #[spec]
    // fun specify_function(x: u64): bool {
    //     target_function(x) > x
    // }
}


//# run 0xCAFE::TestModule::call_direct --signers 0xDEAD --args 5u64


//# run 0xCAFE::TestModule::call_via_variable --signers 0xDEAD --args 5u64


//# run 0xCAFE::TestModule::call_via_lambda --signers 0xDEAD --args 5u64

// Scripts to test the above module and features


//# run
script {
    use 0xCAFE::TestModule;

    fun main() {
        // Call target_function directly
        let res1 = TestModule::call_direct(42);
        // Call via variable
        let res2 = TestModule::call_via_variable(42);
        // Call via lambda
        let res3 = TestModule::call_via_lambda(42);

        // (Optional) Print results or verify, but assertions are ignored as per instructions
    }
}

// Additional script demonstrating attributes, constants, and use; attributes noted as comments


//# run
script {
    use 0xCAFE::TestModule;

    fun main() {
        let c1 = TestModule::MY_CONST;   // u8
        let c2 = TestModule::MY_CONST2;  // u64
        let c3 = TestModule::MY_CONST3;  // bool

        // Use constants to ensure they are available
        // No assertions or runtime checks needed
    }
}