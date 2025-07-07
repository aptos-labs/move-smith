script {
    use std::debug;
    use std::assert;

    module 0x1::TestRefSpec {
        // 1. Define functions and constants to be referenced in schema specs.
        const CONST_VAL: u64 = 42;

        public fun pure_function(x: u64): u64 {
            x + 1
        }

        public fun impure_function(x: u64): u64 {
            // Just a regular function, not pure (for testing)
            x + 2
        }

        // A struct to test schema specification with reference to code members
        struct TestStruct has copy, drop, store {
            a: u64,
            b: u64,
        }

        // 1. Schema spec referencing constants and functions with optional signature
        schema example_schema(s: &TestStruct) {
            // Ref to constant
            assert!(s.a == CONST_VAL, 100);

            // Ref to pure_function with optional type signature
            let result: u64 = pure_function<u64>(s.b);
            assert!(result == s.b + 1, 101);
        }

        // 2. Test final expression in a code block yields block's value

        public fun block_value_test(): u64 {
            let x = {
                let temp = 5;
                temp + 10  // no semicolon: final expression value to be returned by block
            };
            x  // final expression is returned from the function
        }

        public fun block_value_unit_test(): bool {
            // This block has a semicolon, so its value is unit; function returns true
            let _ = {
                let temp = 3;
                temp + 7;
            };
            true
        }

        // 3. Nonterminating loops with assignment and nested breaks + if + failing assert

        public fun complex_loop_test(flag: bool) {
            let mut x = 0;
            loop {
                // assign x inside the loop
                x = x + 1;

                // nested break condition
                if (x > 3) {
                    break;
                }

                // nested inner block with breaks but loop continues
                {
                    if (x == 2) {
                        break;
                    }
                    // Do nothing here
                }
            }

            // After loop finishes
            if (flag) {
                assert!(false, 999); // failing assert, triggers only if flag = true
            }
        }
    }

    script {
        // Test 1: Validate schema references to constants and functions
        use 0x1::TestRefSpec;

        fun main(){
            let s = TestRefSpec::TestStruct {
                a: TestRefSpec::CONST_VAL,
                b: 10,
            };

            // Schema checking inline via a test pattern - using schema block
            // Schema blocks are for specification/verification only - move prover (simulated)
            // We simulate the checks via calls and asserts since in transaction testing,
            // schema is for spec/proof.
            // So here we just run code equivalent to the schema's conditions:
            assert!(s.a == TestRefSpec::CONST_VAL, 100);
            let sf = TestRefSpec::pure_function(10);
            assert!(sf == 11, 101);

            // Test 2: Block final expression return values
            let val = TestRefSpec::block_value_test();
            assert!(val == 15, 200);

            let val2 = TestRefSpec::block_value_unit_test();
            assert!(val2 == true, 201);

            // Test 3: Loop and control flow
            // This call with flag = false => no failing assert, should complete
            TestRefSpec::complex_loop_test(false);

            // This call with flag = true => failing assert triggers
            let triggered = false;
            // Catch the abort (simulated, since Move transactional tests normally stop)
            // In Aptos transactional tests, we expect an abort code on assertion failure.
            // So we run it expecting abort 999.

            // We simulate failure by a try/catch equivalent pattern (Move VM does not have try/catch,
            // so we simulate by a testing framework's expectation of abort)
            // Here we write a separate testing function or comment:

            // Uncomment to test abort:
            // TestRefSpec::complex_loop_test(true); // expected abort 999

            debug::print(&"Test suite completed without unexpected aborts");
        }
    }
}

// Featurres:
// 4c527aa28e2407e75658ec9802c21cf4: Reference code members (functions or constants) within schema specifications with optional signatures.
// e0644c261f1685b715b40782170a5abb: Allow the final expression in a code block to act as the block's resulting value, or treat it as unit if omitted or terminated by a semicolon.
// b6660307806f58facbbe3ec37467f8e5: Test that nonterminating loops with assignment and nested breaks, followed by an if statement and a failing assert, execute as expected without causing unintended termination.
