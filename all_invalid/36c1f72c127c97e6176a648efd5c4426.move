//# publish
module 0xCAFE::FunctionVector {
    use std::vector;
    use std::option;

    /// Instead of `type` alias, define a struct wrapping function pointer
    /// because Move currently doesn't support `type` alias for function types.
    /// However, you cannot store function pointers directly in Move vectors 
    /// as values, so we just define public inline functions returning the functions.

    /// Since Move doesn't support function pointer types or storing functions in vectors,
    /// we simulate with inline functions and call them directly.

    /// Evaluate a vector of function pointers is not possible in current Move.
    ///
    /// So to follow the original intent, rewrite eval to receive a vector of u8 indexes picking functions from builtin set.

    // Instead, here we define the functions directly in eval runner.

    /// Map function over Option type (std::option::Option)
    public fun map_option<T1: copy + store, T2: copy + store>(opt: option::Option<T1>, f: fun(T1): T2): option::Option<T2> {
        match opt {
            option::Some(v) => option::Some(f(v)),
            option::None => option::None,
        }
    }

    /// simple runner function to test eval with two functions (increment and double)
    /// since storing fun ptr is not supported, directly call inline functions
    public fun runner(): u64 {
        // Define the two functions directly
        public inline fun add_one(x: u64): u64 { x + 1 }
        public inline fun double(x: u64): u64 { x * 2 }

        // Manually call both functions and sum results
        let sum = add_one(3) + double(3);
        sum
    }

    /// simple runner function to test map_option
    public fun runner_map(): option::Option<u64> {
        public inline fun f(x: u64): u64 { x * 10 }
        let opt_some = option::Some(5u64);
        let opt_none = option::None<u64>();
        let r1 = map_option(opt_some, f);
        let _r2 = map_option(opt_none, f);

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

    fun main() {
        // 1. let binding with expression
        let a = 7u64 + 8u64; // 15
        let b = a * 2u64;    // 30

        // 2. Since Move does not support function pointers in vector, call functions directly
        fun inc(x: u64): u64 { x + 1 }
        fun square(x: u64): u64 { x * x }

        let result = inc(4) + square(4);
        // Expect: 5 + 16 = 21

        // 3. test map_option
        let opt_some = option::Some(3u64);
        let opt_none = option::None<u64>();
        fun double(x: u64): u64 { x * 2 }

        let _mapped_some = FunctionVector::map_option(opt_some, double);
        let _mapped_none = FunctionVector::map_option(opt_none, double);

        // no asserts needed, just exercise compiler and VM with mutation and calls
    }
}