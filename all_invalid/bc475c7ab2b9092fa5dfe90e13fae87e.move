//# publish
module 0xCAFE::NativeTest {
    // A native function declaration without implementation to test compiler behavior.
    native public fun native_add(x: u64, y: u64): u64;

    // A runner function to call native_add with sample values (won't run successfully in VM because native not implemented)
    public fun run_native(): u64 {
        native_add(10, 20)
    }
}
//# run 0xCAFE::NativeTest::run_native --signers 0xCAFE


//# publish
module 0xCAFE::LambdaVector {
    use std::vector;

    /// An enum to represent the functions by variant
    enum Fun has copy, drop, store {
        AddFive,
        MulTwo,
        Squared,
    }

    /// A struct that stores vector of Fun enum
    struct FunVec has copy, drop, store {
        funs: vector::Vector<Fun>,
    }

    /// Creates a FunVec with 3 functions
    public fun new(): FunVec {
        let v = vector::empty<Fun>();
        let v = vector::push_back(v, Fun::AddFive);
        let v = vector::push_back(v, Fun::MulTwo);
        let v = vector::push_back(v, Fun::Squared);
        FunVec { funs: v }
    }

    /// Applies function represented by Fun variant to arg
    public fun apply(f: &Fun, arg: u64): u64 {
        // Use if-else instead of match - because Move does not support match on enums (only on struct variants or certain enums with no payload)
        if (*f == Fun::AddFive) {
            arg + 5
        } else if (*f == Fun::MulTwo) {
            arg * 2
        } else {
            // Fun::Squared
            arg * arg
        }
    }

    /// Iterate over vector and invoke each function on arg, summing results.
    public fun invoke_and_sum(self: &FunVec, arg: u64): u64 {
        let mut sum = 0;
        let len = vector::length(&self.funs);
        let mut i = 0;
        while (i < len) {
            let f = vector::borrow(&self.funs, i);
            let res = Self::apply(f, arg);
            sum = sum + res;
            i = i + 1;
        };
        sum
    }

    /// Runner function to test storing and iterating functions
    public fun run(): u64 {
        let fv = Self::new();
        // invoke all functions on 10, sum results:
        // add_five(10) = 15
        // mul_two(10) = 20
        // squared(10) = 100
        // sum = 135
        Self::invoke_and_sum(&fv, 10)
    }
}
//# run 0xCAFE::LambdaVector::run --signers 0xCAFE


//# publish
module 0xCAFE::VMErrorTest {
    use std::error;
    use std::vector;

    /// A function that triggers a divide-by-zero error to generate a VM error
    /// and tries to fetch source location from the error (if available)
    public fun trigger_div_zero(): vector::Vector<u8> {
        let result = error::catch_abort(|| 10 / 0);
        // result is error::Result<(), u64>

        let err_code = match result {
            error::Ok(_) => {
                0u64
            },
            error::Err(code) => {
                code
            },
        };

        // Attempt to retrieve source location from VM error
        // error::get_source_location takes error_code and returns vector<u8>
        let src_loc = error::get_source_location(err_code);
        src_loc
    }

    /// Runner calls function that triggers error and returns source location byte vector length
    public fun run(): u64 {
        let loc = Self::trigger_div_zero();
        // Return length of source location vector, just to confirm non-empty typically
        (vector::length(&loc) as u64)
    }
}
//# run 0xCAFE::VMErrorTest::run --signers 0xCAFE


//# run
script {
    use 0xCAFE::LambdaVector;
    use 0xCAFE::VMErrorTest;
    use 0xCAFE::NativeTest;
    use std::error;

    fun main() {
        // Call LambdaVector::run() to test lambdas vector
        let sum = LambdaVector::run();
        // Call VMErrorTest::run() to test source location available from VM error
        let src_loc_len = VMErrorTest::run();

        // Call NativeTest::run_native() to test native function declaration (likely aborts or no return)
        // We'll call it inside a catch so test script does not abort.
        let native_result = error::catch_abort(|| NativeTest::run_native());

        // Just consume these results - no assertions per instructions
        // To avoid unused variable warnings, store to dummy local
        let _ = sum;
        let _ = src_loc_len;
        let _ = native_result;
    }
}