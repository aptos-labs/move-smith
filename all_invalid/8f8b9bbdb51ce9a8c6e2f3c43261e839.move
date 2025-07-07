
// This will fail compilation or runtime if restrictions are enforced
// For example, calling a private function from outside its module

//# call 0xCAFE::MyModule::f1 --args 4u8 true


//# publish
module 0xCAFE::ErrorTest {
    use 0xCAFE::MyModule;

    // Assume 'f1' is a private function (not declared as public)
    // For testing purposes, suppose we try to call 'f1' which is 'public' here, but pretend restricted
    fun call_restricted() {
        // The compiler or VM should provide detailed error information here if access is restricted
        // But since 'f1' is public, this example demonstrates call site info in an error
        // If 'f1' were private, this would cause an error
        // For the purpose of this test, we simulate invoking a non-existing or restricted call
        // The test is conceptual; in real setup, mark 'f1' as private to trigger restriction error
        
//# call 0xCAFE::MyModule::f1 --args 4u8 true
    }
}


public fun test_variable_scope_and_assignment() {
    let x;
    let condition = true;
    if (condition) {
        x = 10u8;
    } else {
        x = 20u8;
    };
    // After the if-else, x should hold the last assigned value
    // Validate that x is correct; (since no assertion, just the flow)
    // The last expression is x to verify correct value assignment depending on condition
    x
}


// Verify attribute detection in the compilation process
// NATIVE_INTERFACE]
public fun native_interface_function() {
    // Function logic can be empty; attribute is key for test
    0u8
}


void test_attribute_recognition() {
    let _ = native_interface_function();
}


// Featurres:
// 86e60b7b8afe9487f0d478e63af0d9d5: Receive detailed error reporting about improper function calls, including call sites and the reason for the restriction
// ef0d8e076c5cee0d7d3002c7d8da1efa: Ensure that variables declared without an initial value can be assigned a value within an if-else statement, and that the variable's value reflects the correct branch taken.
// a4ab16b1f1217107bb207d87ca9cfe63: Apply custom attributes like '#[NATIVE_INTERFACE]' to functions.
