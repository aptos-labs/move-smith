//# publish
module 0xCAFE::FunctionVector {
    use std::vector;
    use std::option;

    /// Since Move currently doesn't support function pointer types or storing functions in vectors,
    /// we simulate by passing functions as inline functions at call-site.
    /// However, function types (fun(T): U) cannot be used as parameters, so we provide specialized inline functions.

    /// Map function over Option type (std::option::Option)
    /// This is a generic function over T1 and T2.
    /// Since function types are not allowed, we make this an inline generic function taking an inline function f.
    ///
    /// The caller must provide an inline function `f` that can be called on T1 to produce T2.
    /// So we define map_option as inline and passing the function as an inline generic parameter.
    /// Unfortunately, Move does not support higher order functions properly.
    ///
    /// As a workaround, define map_option as an inline function with a generic parameter F that represents the function to call.
    ///
    /// But since Move doesn't support generic function parameters,
    /// the only practical way is to define separate map_option instantiations per function needed.
    ///
    /// Here we define a simple map_option in terms of an inline function f.
    public inline fun map_option<T1: copy + store, T2: copy + store>(opt: option::Option<T1>, f: (x: T1) -> T2): option::Option<T2> {
        match opt {
            option::Some(v) => option::Some(f(v)),
            option::None => option::None,
        }
    }

    /// The above signature with `(x: T1) -> T2` is invalid in Move (not supported).
    /// Since higher order functions are not supported as first-class types, we will unfold map_option
    /// to a non-generic function for the example usage below.

    /// Instead, provide map_option for u64 and multiply_by_10 inline function usage.
    public inline fun map_option_u64_mult10(opt: option::Option<u64>): option::Option<u64> {
        inline fun f(x: u64): u64 { x * 10 }
        match opt {
            option::Some(v) => option::Some(f(v)),
            option::None => option::None,
        }
    }

    /// simple runner function to test eval with two functions (increment and double)
    /// since storing fun ptr is not supported, directly call inline functions
    public fun runner(): u64 {
        // Define the two functions directly
        // Inline functions must be declared at module level, move them out

        add_one(3) + double(3)
    }

    /// simple runner function to test map_option
    public fun runner_map(): option::Option<u64> {
        let opt_some = option::Some(5u64);
        let opt_none = option::None<u64>();
        let r1 = map_option_u64_mult10(opt_some);
        let _r2 = map_option_u64_mult10(opt_none);

        // Return r1 only to keep return type simple
        r1
    }

    // Inline functions moved out of runner because Move does not support function definitions inside functions
    public inline fun add_one(x: u64): u64 { x + 1 }
    public inline fun double(x: u64): u64 { x * 2 }
}

//# run 0xCAFE::FunctionVector::runner
//# run 0xCAFE::FunctionVector::runner_map

//# run
script {
    use std::option;
    use 0xCAFE::FunctionVector;

    fun main() {
        // 1. let binding with expression
        let a = 7u64 + 8u64; // 15
        let b = a * 2u64;    // 30

        // 2. Since Move does not support function pointers in vector, call functions directly
        // Functions must be defined at script level, not inside function bodies
        // So define them here

        // Define inline functions at script scope (script does not support inline, define as normal functions)
        fun inc(x: u64): u64 { x + 1 }
        fun square(x: u64): u64 { x * x }

        let result = inc(4) + square(4);
        // Expect: 5 + 16 = 21

        // 3. test map_option
        let opt_some = option::Some(3u64);
        let opt_none = option::None<u64>();
        fun double(x: u64): u64 { x * 2 }

        let _mapped_some = FunctionVector::map_option_u64_mult10(opt_some);
        let _mapped_none = FunctionVector::map_option_u64_mult10(opt_none);

        // no asserts needed, just exercise compiler and VM with mutation and calls
    }
}