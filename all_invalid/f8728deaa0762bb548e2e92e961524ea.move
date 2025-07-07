//# publish
module 0x1::EscapeSequences {
    public fun test_escape_sequence() {
        let bytes = b"hello\n\tworld\"!";
        assert(bytes == b"hello\n\tworld\"!");
    }
}

//# publish
module 0x1::DependencyExample {
    use 0x1::EscapeSequences;

    public fun get_dependency_module_id(): vector<u8> {
        // Return module id as bytes
        b"DependencyModule"
    }

    public fun test_module_dependency() {
        // Call a function from EscapeSequences module
        EscapeSequences::test_escape_sequence();
    }
}

//# publish
module 0x1::FunctionAssignment {
    // Define a function type
    public fun add(a: u64, b: u64): u64 {
        a + b
    }
    
    // Runner function to test invocation styles
    public fun run() {
        let f_direct = Self::add;
        let f_var = Self::add;

        // Call directly
        let res1 = Self::add(1, 2);

        // Call via variable
        let res2 = move(f_var)(3, 4);

        // Call via lambda
        let lambda = |a: u64, b: u64| { a + b };
        let res3 = lambda(5, 6);
    }
}

//# publish
module 0x1::TypeParamFunction {
    // Function with type parameters, parameters, and return type
    public fun generic_add<T>(a: T, b: T): T 
        where T: copy + std::ops::Add<Output = T> 
    {
        a + b
    }
    
    // Runner to invoke the generic function with specific types
    public fun run() {
        let sum_u64 = Self::generic_add<u64>(10, 20);
        let sum_u8 = Self::generic_add<u8>(3, 4);
    }
}

//# run
script {
    // Exercise escape sequence parsing
    LockedModule::test_escape_sequence();

    // Test module with dependencies
    // (Note: dependencies are declared but not explicitly tested here)
    0x1::DependencyExample::test_module_dependency();

    // Test function assignment invocation styles
    let () = 0x1::FunctionAssignment::run();

    // Test function with type parameters
    let () = 0x1::TypeParamFunction::run();
}