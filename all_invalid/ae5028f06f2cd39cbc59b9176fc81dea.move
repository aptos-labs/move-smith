
//# publish
module 0xFACE::TestModule {
    // A top-level module to test nested module declaration, visibility, and function syntax.
    use std::signer;

    // Declare nested modules to test module syntax
//# publish
    module InnerModule {
        // Public function with local variables and expression termination testing
        public fun compute_sum(a: u8, b: u8): u8 {
            let sum = a + b;
            let double_sum = sum + sum; // expression with multiple operators
            // using local variables in expressions
            if (double_sum > 20) {
                let result = double_sum - 10;
            } else {
                let result = double_sum + 10;
            };
            // Return a local variable
            double_sum
        }

        // Function with complex expression involving multiple tokens
        public fun complex_expression(x: u16): u16 {
            let a = x + 1;
            let b = a * 2;
            // multiple tokens to test parsing of expression termination
            let c = b + 3; // + token
            if (c > 10) {
                c = c - 10;
            };
            c // return value
        }

        // Function with a loop and match expression
        public fun loop_match_test() {
            let counter = 0;
            loop {
                if (counter >= 3) {
                    break;
                };
                counter = counter + 1;
            };
            let result = match (counter) {
                0 => 0,
                1 => 10,
                2 => 20,
                _ => 30,
            };
            result
        }
    }

    // Declare another submodule to ensure nesting
//# publish
    module SubModule {
        public fun check_local_vars() {
            let a = 5;
            let b = 10;
            let c = a + b;
            let d = c * 2;
        }

        // Function with nested let and if-else, testing expression termination
        public fun nested_ifs(x: u8): u8 {
            let y = x + 1;
            let z;
            if (y > 5) {
                z = y * 2;
            } else {
                z = y + 2;
            };
            // using z in expression
            z
        }
    }

    // Function to invoke nested module functions, testing module resolution
    public fun caller() {
        InnerModule::compute_sum(3, 4);
        InnerModule::complex_expression(7);
        InnerModule::loop_match_test();
        SubModule::check_local_vars();
        SubModule::nested_ifs(4);
    }
}


//# run 0xFACE::TestModule::caller


// Featurres:
// e7c27353d8c26a6f11948b103983605b: Declare modules.
// b22b59fd28979c7d0b5ad3ffc3665620: Use a local variable in an assignment expression.
// f900b94dca53be25721b14907d8740c3: Terminate expressions with tokens such as else, }, ), ,, :, or ; to indicate the end of an expression in your Move code.
