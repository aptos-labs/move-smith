//# publish
module 0xA11D::TestModule {
    use std::debug;

    // Function to demonstrate cross-module call restriction
    public fun attempt_cross_module_call() {
        // This function won't compile if called from unauthorized module
        // For testing, we just keep it as a placeholder
    }

    // Inline function accepting reference parameter and performing addition
    public fun add_reference<'a>(a: &u64, b: &u64): u64 {
        *a + *b
    }

    // Function to test lambda with references
    public fun test_lambda_add(x: u64, y: u64): u64 {
        // Creating references
        let ref_x = &x;
        let ref_y = &y;
        // Using lambda to add via function
        move || Self::add_reference(ref_x, ref_y) {
            Self::add_reference(ref_x, ref_y)
        }
    }

    // Function to report specification errors with detailed messages
    public fun report_error(message: string) {
        debug::print(&message);
    }

    // Runner function to execute tests
    public fun run_all() {
        // 1. Cross-module call attempt (will not compile across different address domains)
        // Note: For testing, we can simulate an error scenario
        // In actual test environment, calling such a function should cause an error
        // For demonstration, we just comment or leave as placeholder
        // Alternatively, simulate with a failed assertion
        debug::print(&"Starting cross-module call restriction test");
        // (In actual test, calling attempt_cross_module_call from unauthorized address would error)

        // 2. Test inline function with lambda
        let result = Self::test_lambda_add(10, 20);
        debug::print(&format(&"Lambda addition result: {}", result));
        // Should print 30

        // 3. Error reporting with detailed message
        Self::report_error("Specification check failed: invalid claim");

        // 4. Test early termination with return inside if
        let condition = true;
        if (condition) {
            debug::print(&"Condition true, returning early");
            return;
        }
        // This code should not run if early return occurs
        debug::print(&"This should not print if early return works");

        // 5. Create primary expressions: name references and literals
        let name_ref = &"test_name";
        let number_literal = 42u64;
        let bool_literal = true;
        let byte_string = b"byte_data";

        // Print them
        debug::print(&format(&"Name: {}", *name_ref));
        debug::print(&format(&"Number: {}", number_literal));
        debug::print(&format(&"Boolean: {}", bool_literal));
        debug::print(&format(&"Byte string: {:?}", byte_string));

        // 6. Group multiple expressions into a block
        let result_block = {
            let a = 1u64;
            let b = 2u64;
            let c = 3u64;
            a + b + c
        };
        debug::print(&format(&"Result of block group expressions: {}", result_block));
    }
}

//# run 0xA11D::TestModule::run_all