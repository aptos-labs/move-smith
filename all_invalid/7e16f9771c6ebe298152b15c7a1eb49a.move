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
    /// Define a struct to hold vector of lambdas (functions).
    /// Lambdas with same signature only.
    /// To store lambdas, use function type aliases.
    /// Here, functions that take (u64) and return u64.

    // Define function type alias for clarity (not enforced by compiler but for explanation)
    // We define a function type by an argument list and return type:
    // "fun(u64): u64"
    // There's no type alias syntax for function types in Move 
    // so we'll just directly store vector<fun(u64): u64>

    use std::vector;

    /// A struct that stores vector of lambdas (functions)
    struct FunVec has copy, drop, store {
        funs: vector<fun(u64): u64>,
    }

    /// Creates a FunVec with 3 lambda functions that each add a different constant to their input.
    public fun new(): FunVec {
        let f1 = fun add_five(x: u64): u64 { x + 5 };
        let f2 = fun mul_two(x: u64): u64 { x * 2 };
        let f3 = fun squared(x: u64): u64 { x * x };
        FunVec {
            funs: vector::empty<fun(u64): u64>()
        }
        .add_fun(f1)
        .add_fun(f2)
        .add_fun(f3)
    }

    /// Adds a function to FunVec
    public fun add_fun(self: FunVec, f: fun(u64): u64): FunVec {
        let mut v = copy self.funs;
        vector::push_back(&mut v, f);
        FunVec { funs: v }
    }

    /// Iterate over vector and invoke each lambda on arg, summing all results.
    public fun invoke_and_sum(self: &FunVec, arg: u64): u64 {
        let mut sum = 0;
        let len = vector::length(&self.funs);
        let mut i = 0;
        while (i < len) {
            let f = *vector::borrow(&self.funs, i);
            let res = f(arg);
            sum = sum + res;
            i = i + 1;
        };
        sum
    }

    /// Runner function to test storing and iterating lambdas
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
    public fun trigger_div_zero(): vector<u8> {
        let result = error::catch_abort(|| { 10 / 0 });
        // result is error::ErrorCode or success

        let err_code = match result {
            error::Ok(_) => { 0 },
            error::Err(code) => { code },
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
        vector::length(&loc) as u64
    }
}
//# run 0xCAFE::VMErrorTest::run --signers 0xCAFE


//# run
script {
    use 0xCAFE::LambdaVector;
    use 0xCAFE::VMErrorTest;

    fun main() {
        // Call LambdaVector::run() to test lambdas vector
        let sum = LambdaVector::run();
        // Call VMErrorTest::run() to test source location available from VM error
        let src_loc_len = VMErrorTest::run();

        // Call NativeTest::run_native() to test native function declaration (likely aborts or no return)
        // We'll call it inside a catch so test script does not abort.
        use std::error;
        let native_result = error::catch_abort(|| 0xCAFE::NativeTest::run_native());

        // Just consume these results - no assertions per instructions
        // To avoid unused variable warnings, store to dummy local
        let _ = sum;
        let _ = src_loc_len;
        let _ = native_result;
    }
}

// Featurres:
// 9e39b74edbca9497671d446bc896bd5f: Declare functions or modules as 'native' to indicate native implementation
// be132e2b495333820d8b02e55f4bcf08: Test that vectors can store and iterate over lambda functions, and that each lambda can be invoked with arguments during iteration.
// 453682ddea7b74240c22d95d81f4b0ee: Retrieve the source location associated with a VM error when available.
