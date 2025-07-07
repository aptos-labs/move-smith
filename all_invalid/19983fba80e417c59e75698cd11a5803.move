//# publish
address 0x1 {
    module CompilerVMTest {
        use std::signer;
        use std::error;
        use std::vector;
        use std::debug;
        use std::option;
        use std::u32;

        /// A simple resource for modification in do()
        struct R has key {
            value: u64,
        }

        /// Context struct to test parsing of targets and deps with addresses
        /// This is a dummy struct to simulate target and dependency addresses mapping
        struct AddressMapping has copy, drop {
            addr: address,
        }

        /// Function to simulate parsing of Move programs from target and dependency files
        /// with associated address mappings.
        public fun parse_move_programs() {
            // Since we cannot parse files here, just simulate by instantiating AddressMapping
            let target = AddressMapping { addr: @0xA };
            let dep = AddressMapping { addr: @0xB };
            debug::print(&vector::empty<u8>());
            // Print addresses to exercise compiler and VM
            debug::print(&vector::singleton(u8::from_u8(10)));
            debug::print(&vector::singleton(u8::from_u8(11)));
        }

        /// The R resource should be modified or interacted within this function based on v
        public fun do(r: &mut R, v: u64) {
            if (v == 0) {
                // Reset value to 0
                r.value = 0;
            } else if (v == 1) {
                // Increment value by 1
                r.value = r.value + 1;
            } else {
                // Multiply value by v
                r.value = r.value * v;
            }
        }

        /// #[skip(lint_redundant_return, lint_non_camel_case_types)]
        /// To test the skip attribute with lints
        public fun lint_skipped_function() {
            let x = 10u64;
            return; // redundant return that would be linted if not skipped
        }

        /// #[skip(lint_dead_code)]
        /// This function is dead code but will be skipped in lint
        fun dead_code_func() {}

        /// Generate a test plan for primary target modules when test code compilation is enabled.
        public fun generate_test_plan() {
            debug::print(&vector::singleton(42u8));
            // Just print the value 42 as a dummy "test plan" emission.
        }

        /// Arithmetic tests for u32 with boundary conditions, overflow, underflow, divide/mod by zero checks.
        public fun arith_tests(): u8 {
            let max = u32::MAX;
            let zero = 0u32;

            let add_ok = max - 1 + 1; // should be max
            let sub_ok = 1 - 1; // zero
            let mul_ok = 2 * 3; // 6
            let div_ok = 6 / 2; // 3
            let mod_ok = 7 % 2; // 1

            // Overflow - add 1 to max should cause panic (simulate using assert false)
            let overflow = max + 1;
            // Underflow - sub 1 from zero should cause panic
            let underflow = zero - 1;

            // Division by zero and mod zero should panic (simulate by aborts)
            if (zero == 0) {
                // This forces division by zero to be caught by VM in runtime tests
                let _ = 1 / zero;
            }
            if (zero == 0) {
                let _ = 1 % zero;
            }
            42
        }

        /// Analyze function exit states using ExitStateAnalysis
        /// We simulate by returning an Option<u8> based on conditions.
        public fun analyze_exit_state(input: u8): option::Option<u8> {
            if (input == 0) {
                option::some(0)
            } else if (input == 1) {
                option::some(1)
            } else {
                option::none()
            }
        }


        /// Runner function which does all the above without arguments
        public fun run_all() {
            // parse move programs simulation
            parse_move_programs();

            // Test R resource modification
            let r = signer::borrow_address(signer::spec_signer_ref());
            // Create resource R at 0x1 for testing
            move_to(&signer::spec_signer_ref(), R { value: 10 });

            let r_ref = borrow_global_mut<R>(@0x1);
            do(r_ref, 0); // reset to 0
            do(r_ref, 1); // increment by 1 (1)
            do(r_ref, 5); // multiply by 5 (5)

            // call lint skipped function
            lint_skipped_function();

            // generate test plan
            generate_test_plan();

            // arithmetic tests
            let _ = arith_tests();

            // exit state analysis
            let _ = analyze_exit_state(0);
            let _ = analyze_exit_state(1);
            let _ = analyze_exit_state(2);

            // Cleanup R resource
            move_from<R>(@0x1);
        }
    }
}
//# run 0x1::CompilerVMTest::run_all --signers 0x1

//# run
script {
    use std::signer;
    use 0x1::CompilerVMTest;

    fun main(account: signer) {
        // Publish resource R for testing
        move_to(&account, CompilerVMTest::R { value: 99 });

        let r_ref = borrow_global_mut<CompilerVMTest::R>(signer::address_of(&account));

        CompilerVMTest::do(r_ref, 0);  // reset value to 0
        CompilerVMTest::do(r_ref, 1);  // increment value to 1
        CompilerVMTest::do(r_ref, 3);  // multiply value to 3

        // Run lint skipped function that would have lint issues but skipped
        CompilerVMTest::lint_skipped_function();

        // Run exit state analysis for different inputs
        let _ = CompilerVMTest::analyze_exit_state(0);
        let _ = CompilerVMTest::analyze_exit_state(1);
        let _ = CompilerVMTest::analyze_exit_state(10);

        // Remove resource to clean up
        move_from<CompilerVMTest::R>(signer::address_of(&account));

        // Run arithmetic tests to capture compiler and VM behavior around arithmetic ops
        CompilerVMTest::arith_tests();

        // Generate test plan as part of script run
        CompilerVMTest::generate_test_plan();
    }
}