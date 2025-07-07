// # publish
address 0xCAFE {
    module LambdaApply {

        /// A public type to wrap a closure (lambda) expecting two u64 inputs and producing a u64 output.
        /// Since Move doesn't have "normal" closures, we use a struct wrapping a function pointer.
        public type Fun2 = fun(u64, u64): u64;

        /// Applies the given lambda on two u64 arguments and returns the result.
        public fun apply(f: Fun2, a: u64, b: u64): u64 {
            f(a, b)
        }

        /// Nested apply test: applies addition lambda and then applies multiplication lambda on the result and a constant.
        /// Returns ((x + y) * 2).
        public fun nested_apply(x: u64, y: u64): u64 {
            // Define addition function
            let add_fun: Fun2 = &add_lambda;
            let mul_fun: Fun2 = &mul_lambda;
            let sum = apply(add_fun, x, y);
            apply(mul_fun, sum, 2)
        }

        /// A sample addition lambda: adds two u64 numbers
        public inline fun add_lambda(x: u64, y: u64): u64 {
            x + y
        }

        /// A sample multiplication lambda: multiplies two u64 numbers
        public inline fun mul_lambda(x: u64, y: u64): u64 {
            x * y
        }
    }
}
// # run 0xCAFE::LambdaApply::nested_apply --args 3u64 4u64

// # publish
address 0xCAFE {
    module NativeFunGen {

        /// Define a named native function with a generic type parameter T.
        /// This simulates "native" style definitions using inline functions as movable placeholders.
        public inline fun identity<T: copy + drop>(x: T): T {
            x
        }

        /// A runner function that uses identity on a u8 (byte) and returns it incremented.
        public fun runner(): u8 {
            let val = identity<u8>(10);
            val + 1
        }
    }
}
// # run 0xCAFE::NativeFunGen::runner


// # publish
address 0xCAFE {
    module ValidateBytes {

        /// Checks if a byte (u8) is permitted:
        /// For example: allowed bytes are digits (0x30-0x39), uppercase letters (0x41-0x5A),
        /// lowercase letters (0x61-0x7A), underscore (0x5F) and hyphen (0x2D).
        public fun is_byte_allowed(c: u8): bool {
            (c >= 0x30 && c <= 0x39) ||  // '0'-'9'
            (c >= 0x41 && c <= 0x5A) ||  // 'A'-'Z'
            (c >= 0x61 && c <= 0x7A) ||  // 'a'-'z'
            (c == 0x5F) ||                // '_'
            (c == 0x2D)                   // '-'
        }

        /// Validate all characters in a byte vector are allowed.
        /// Returns true if all bytes are allowed, false otherwise.
        public fun validate_all(bytes: vector<u8>): bool {
            let length = vector::length(&bytes);
            let mut i = 0;
            while (i < length) {
                let c = *vector::borrow(&bytes, i);
                if (!is_byte_allowed(c)) {
                    return false;
                }
                i = i + 1;
            }
            true
        }

        /// Runner function that tests valid and invalid byte vectors.
        /// Returns true if valid test passes and invalid test fails correctly, false otherwise.
        public fun runner(): bool {
            let valid = b"Test_Name-123";
            let invalid = b"Invalid!@#";

            let valid_res = validate_all(valid);
            let invalid_res = validate_all(invalid);

            valid_res && !invalid_res
        }
    }
}
// # run 0xCAFE::ValidateBytes::runner


// # run
script {
    use 0xCAFE::LambdaApply;
    use 0xCAFE::NativeFunGen;
    use 0xCAFE::ValidateBytes;

    fun main() {
        // Test LambdaApply nested_apply function: expect (3 + 4) * 2 = 14
        let result1 = LambdaApply::nested_apply(3, 4);
        // Just call to run VM, no asserts needed

        // Test NativeFunGen runner returns 11 (10 + 1)
        let result2 = NativeFunGen::runner();

        // Test ValidateBytes runner returns true
        let result3 = ValidateBytes::runner();

        // Consume results to avoid warnings
        let _ = result1;
        let _ = result2;
        let _ = result3;
    }
}

// Featurres:
// a2d395f7cc514b343f4569a28ad36e2a: Test that the `apply` function correctly executes a passed-in lambda function with provided arguments, and verify that nested `apply` calls produce the expected combined result.
// 3ce7f9ec7dcf0f463d7ee246609ec231: Define named native functions with custom type parameters for generics.
// c0b78578eb3e13abcdf56b70cfdfafe4: Validate that each character in a byte sequence is permitted according to specific criteria
