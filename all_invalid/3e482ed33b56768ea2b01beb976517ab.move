
//# publish
    module 0xDEAD::TestModule {
        use std::vector;
        use std::signer;

        struct Data has copy, drop, store {
            value: u64,
        }

        public fun init_and_return_on_if(x: u8, s: signer): u64 {
            let maybe_uninit;
            if (x > 5) {
                // declare a variable before if-else, and return early in then branch
                maybe_uninit = 42;
                move_to(&s, Data { value: maybe_uninit });
                // early return
                0
            } else {
                // the variable 'maybe_uninit' isn't initialized if in else branch
                // To test that the compiler recognizes uninitialized variable, this code is correct
                let data_ref: &Data = borrow_global<Data>(signer::address_of(&s));
                data_ref.value
            }
        }

        public fun test_variable_scope_with_return(s: signer): u64 {
            let val;
            // Declare variable outside if-else
            if (true) {
                // Return occurs here, variable may be uninitialized afterwards
                return 999u64;
            } else {
                val = 0;
            };
            // The variable 'val' used after the if-else; testing variable initialization recognition
            val
        }

        // Function to test type casting and expressions
        public fun type_cast_and_expression_test(x: u8): u8 {
            // Cast u8 to u16 for demonstration
            let large_x: u16 = x as u16;
            // expression with parentheses
            let sum = (large_x + 10) as u8;
            sum
        }

        // Function to test executing inside an address block
        public fun execute_in_address(s: signer): u64 {
            let addr = signer::address_of(&s);
            let result_value: u64;

            // Use an address block to declare a module inside
            address addr {
//# publish
                module 0xDEAD::InnerModule {
                    public fun inner_function(y: u64): u64 {
                        y + 1
                    }
                }
            }

            // Call the inner function with expression
            result_value = 0xDEAD::InnerModule::inner_function(123u64);
            result_value
        }

        // Function to test expression with cast and nested parentheses
        public fun nested_expression(x: u8): u8 {
            ((x as u16) + 5) as u8
        }

        // Runner function for all tests
        public fun run_tests() {
            // simulate signers
            let s1 = signer::new_signer(0xBADD);
            let s2 = signer::new_signer(0xFACE);
            // Call functions
            let _ = init_and_return_on_if(8, s1);
            let _ = test_variable_scope_with_return(s2);
            let _ = type_cast_and_expression_test(10);
            let _ = execute_in_address(s1);
            let _ = nested_expression(12);
        }
    }
}


//# run 0xDEAD::TestModule::run_tests --signers 0xBADD --signers 0xFACE


// Featurres:
// 9215ae1df667395735358a83241850e3: Test that variables declared before an if-else statement are correctly recognized as potentially uninitialized if a return occurs in one branch.
// ff0e1ae15b3f12bb2b442c47cdeae366: Declare a module inside an 'address <address> { ... }' block to assign the sender address.
// d05c007f1c93df9d5a175e4c5e439e9a: Use type cast and test expressions when supported.
