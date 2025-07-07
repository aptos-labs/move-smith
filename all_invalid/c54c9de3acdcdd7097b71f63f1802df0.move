//# publish
module 0xCAFE::FunctionVector {
    use std::vector;
    use std::option;

    /// A function type alias for example purposes: (u64) -> u64
    public type FunType = fun(u64): u64;

    /// Evaluate a vector of functions on x, summing their results
    public fun eval(fs: vector<FunType>, x: u64): u64 {
        let mut sum = 0u64;
        let len = vector::length(&fs);
        let mut i = 0u64;
        while (i < (len as u64)) {
            let f = *vector::borrow(&fs, (i as u64) as usize);
            sum = sum + f(x);
            i = i + 1;
        }
        sum
    }

    /// Map function over Option type (std::option::Option)
    public fun map_option<T1: copy + store, T2: copy + store>(opt: option::Option<T1>, f: fun(T1): T2): option::Option<T2> {
        match opt {
            option::Some(v) => option::Some(f(v)),
            option::None => option::None,
        }
    }

    /// simple runner function to test eval with two functions (increment and double)
    public fun runner(): u64 {
        // Create two functions: increment and double
        fun add_one(x: u64): u64 { x + 1 }
        fun double(x: u64): u64 { x * 2 }

        let fs = vector::empty<FunType>();
        let fs = vector::push_back(fs, add_one);
        let fs = vector::push_back(fs, double);

        eval(fs, 3) // (3+1) + (3*2) = 4 + 6 = 10
    }

    /// simple runner function to test map_option
    public fun runner_map(): option::Option<u64> {
        fun f(x: u64): u64 { x * 10 }
        let opt_some = option::Some(5u64);
        let opt_none = option::None<u64>();
        let r1 = map_option(opt_some, f);
        let r2 = map_option(opt_none, f);

        // Return r1 only to keep return type simple
        r1
    }
}
/// run 0xCAFE::FunctionVector::runner
/// run 0xCAFE::FunctionVector::runner_map

//# run
script {
    use std::vector;
    use std::option;
    use 0xCAFE::FunctionVector;

    fun add(x: u64): u64 { x + 5 }

    fun main() {
        // 1. let binding with expression
        let a = 7u64 + 8u64; // 15
        let b = a * 2u64;    // 30

        // 2. test eval with vector of functions
        // Define two functions
        fun inc(x: u64): u64 { x + 1 }
        fun square(x: u64): u64 { x * x }

        let fs = vector::empty<FunctionVector::FunType>();
        let fs = vector::push_back(fs, inc);
        let fs = vector::push_back(fs, square);
        let result = FunctionVector::eval(fs, 4); 
        // Expect: inc(4) + square(4) = 5 + 16 = 21

        // 3. test map_option
        let opt_some = option::Some(3u64);
        let opt_none = option::None<u64>();
        fun double(x: u64): u64 { x * 2 }

        let mapped_some = FunctionVector::map_option(opt_some, double);
        let mapped_none = FunctionVector::map_option(opt_none, double);

        // no asserts needed, just exercise compiler and VM with mutation and calls
    }
}

// Featurres:
// 41f8c7258935ea12ed715b21888bd747: Assign an expression to a named variable using a 'let' binding in Move.
// 1f8caf0229b4f4e45239ffff6f3cba57: Test that the `eval` function correctly computes the sum of applying the generated vector of functions to the input argument.
// 2546adaf47f70b2598c1cbdc28df4fc3: Test that the map function correctly transforms a some option value by applying a given function.
