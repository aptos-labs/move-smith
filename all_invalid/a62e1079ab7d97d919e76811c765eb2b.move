// Transactional test for Move compiler and VM features:
// 1) Verbose debug output before/after expansion
// 2) Use of 'verify_only' attribute
// 3) Removal of inline functions after inlining

address 0x1 {
    // ==== Module with verify_only attribute ====
    #[verify_only]
    module VerifyModule {
        // a verify-only function, used for verification only, not emitted in bytecode
        public fun is_even(x: u64): bool {
            x % 2 == 0
        }
    }

    // ==== Main test module ====
    module TestInlineAndVerification {
        use std::debug;
        use 0x1::VerifyModule;

        /// Inline function - should be removed after inlining to avoid codegen issues
        #[inline]
        fun inline_add(a: u64, b: u64): u64 {
            a + b
        }

        // Regular function calling inline function
        public fun sum_and_verify(a: u64, b: u64): bool {
            // Verbose debug output before expansion
            debug::print(&"Before expansion:");
            debug::print(&"Calling inline_add...");
            // Call inline function
            let sum = inline_add(a, b);
            
            // Verbose debug output after expansion
            debug::print(&"After expansion:");
            debug::print(&"sum = ".concat(&std::debug::u64_to_string(sum)));

            // Use verify-only function
            VerifyModule::is_even(sum)
        }
    }

    // ==== Transactional test script ====
    script {
        use 0x1::TestInlineAndVerification;
        use std::debug;

        fun main() {
            // Test input values
            let a = 10;
            let b = 22;

            debug::print(&"=== Transactional test start ===");
            debug::print(&format!("Inputs a={}, b={}", a, b));

            let is_even_sum = TestInlineAndVerification::sum_and_verify(a, b);
            
            debug::print(&format!("Is sum even? {}", is_even_sum));
            assert!(is_even_sum, 0);

            // Negative test case for completeness
            let a2 = 11;
            let b2 = 22;
            let is_even_sum2 = TestInlineAndVerification::sum_and_verify(a2, b2);
            debug::print(&format!("Inputs a2={}, b2={}", a2, b2));
            debug::print(&format!("Is sum even? {}", is_even_sum2));
            
            // This should not abort, as verification function only serves as info
            // But assert to verify the outcome programmatically:
            assert!(is_even_sum2 == false, 1);

            debug::print(&"=== Transactional test end ===");
        }
    }
}

// Featurres:
// 04d8f35cd859951dbf262532ad7e0c4e: Output verbose debug information about the program before and after expansion.
// c7b5560c242cdd6b01699cc61c97f34e: Annotate code with the 'verify_only' attribute to specify verification-only functions or modules.
// 4957c6b77b94890bc1f8b09f0feac0e4: Remove inline functions from the program after inlining to reduce code size and prevent codegen issues.
