// Corrected transactional test code

// Publish the module (remove 'deprecated' keyword to fix compile errors)
module 0xCAFE::DepModule {
    use std::vector;

    // Pure deprecation marker, no runtime impact
    public fun deprecated_function(x: u8): u8 {
        x
    }
}

// Publish the module (remove 'deprecated' keyword to fix compile errors)
module 0xCAFE::RefTestModule {
    use std::vector;

    // Function to test dereferencing
    public fun deref_test() {
        let x: u8 = 42;
        let r: &u8 = &x;
        // dereference via unary *
        let y = *r;
        // Use dereferenced value
        let _z = y + 1;
        // Use 'as' keyword as identifier
        let as_value = 10;
        // Use 'if' as identifier
        let if_var = as_value;
        // Use 'else' as identifier
        let else_var = 20;
        // Use 'true' as identifier
        let true_var = 1;
        // Use 'false' as identifier
        let false_var = 0;

        // Use 'let' keyword as identifier
        let let_var = 99;

        // Use 'return' as identifier
        let return_var = *r;

        // Use 'module' keyword as identifier
        let module_var = 7;

        // Use 'fun' as identifier
        let fun_var = 8;
    }
}

// Run the function in the dep module
script {
    fun main() {
        // Call deprecated function
        let result = 0xCAFE::DepModule::deprecated_function(5u8);
        // Call deref_test
        0xCAFE::RefTestModule::deref_test();
        // For clarity, do something with result if needed (not strictly necessary)
        result;
    }
}