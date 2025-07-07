//# publish
module 0xA550C18::TempOptionalType {
    use std::option::{Option, some, none};

    /// A generic struct holding an optional value of type T
    struct Holder<T> has store {
        value: Option<T>,
    }

    /// Create a new Holder with Some(value)
    public fun new_with_value<T>(value: T): Holder<T> {
        Holder {
            value: some(value)
        }
    }

    /// Create a new empty Holder with None
    public fun new_empty<T>(): Holder<T> {
        Holder {
            value: none<T>()
        }
    }

    /// A function that uses temporary expressions to compute an intermediate sum and multiply the result
    /// Returns u64
    public fun compute_and_multiply(x: u64, y: u64, factor: u64): u64 {
        // Use a temporary variable to hold intermediate sum
        let temp_sum = x + y;
        // multiply by factor
        temp_sum * factor
    }

    /// A function that accepts multiple argument types and returns a tuple (u8, bool, u64)
    /// Demonstrates argument type checking
    public fun mixed_args(a: u8, b: bool, c: u64): (u8, bool, u64) {
        (a, b, c)
    }

    /// A runner function to exercise above functions
    public fun runner(): bool {
        // Create temporary values
        let h1 = Self::new_with_value<u8>(42);
        let h2: Holder<u64> = Self::new_empty();
        let res1 = Self::compute_and_multiply(10, 15, 3);
        let (v1, v2, v3) = Self::mixed_args(7, true, 101);

        // Use temporary expression chaining
        let doubled = {
            let temp = res1;
            temp * 2
        };

        // The runner returns true if doubled is > 100
        doubled > 100
    }
}
//# run 0xA550C18::TempOptionalType::runner

//# run
script {
    use 0xA550C18::TempOptionalType;

    fun main() {
        let result = TempOptionalType::runner();
        // just drop result, no assert needed
        // additionally call compute_and_multiply with sample values
        let val = TempOptionalType::compute_and_multiply(5, 6, 2);

        // create Holder of bool with value true
        let _h = TempOptionalType::new_with_value<bool>(true);

        // call mixed_args with mismatched types consciously, correct types actually
        let (_a, _b, _c) = TempOptionalType::mixed_args(255, false, 999999);
    }
}