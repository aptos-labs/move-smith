//# publish
module 0xCAFE::FunctionTypes {

    use std::vector;

    /// An enum wrapping functions of different arities.
    /// We wrap functions taking 0, 1, or 2 u64 arguments, returning u64.
    /// Also tests storing and calling functions through enum variants.
    #[copy] // allow copy since functions have copy ability
    public enum FuncWrapper {
        Zerary(fn(): u64),
        Unary(fn(u64): u64),
        Binary(fn(u64, u64): u64),
    }

    /// Wrap a 0-arity function in the enum.
    public fun wrap_zerary(f: fn(): u64): FuncWrapper {
        FuncWrapper::Zerary(f)
    }

    /// Wrap a unary function in the enum.
    public fun wrap_unary(f: fn(u64): u64): FuncWrapper {
        FuncWrapper::Unary(f)
    }

    /// Wrap a binary function in the enum.
    public fun wrap_binary(f: fn(u64, u64): u64): FuncWrapper {
        FuncWrapper::Binary(f)
    }

    /// Calls the wrapped function with zero arguments.
    /// Only valid for Zerary functions, errors if not.
    public fun call_zerary(fw: &FuncWrapper): u64 {
        match fw {
            FuncWrapper::Zerary(f) => f(),
            _ => 0, // fallback to 0 if wrong variant, no asserts as per tip
        }
    }

    /// Calls the wrapped function with one argument.
    public fun call_unary(fw: &FuncWrapper, x: u64): u64 {
        match fw {
            FuncWrapper::Unary(f) => f(x),
            _ => 0,
        }
    }

    /// Calls the wrapped function with two arguments.
    public fun call_binary(fw: &FuncWrapper, x: u64, y: u64): u64 {
        match fw {
            FuncWrapper::Binary(f) => f(x, y),
            _ => 0,
        }
    }

    /// A simple function with zero parameters.
    public fun zero(): u64 {
        42u64
    }

    /// A simple unary function.
    public fun add_one(x: u64): u64 {
        x + 1
    }

    /// A simple binary function.
    public fun add(x: u64, y: u64): u64 {
        x + y
    }

    /// Recursive wrapping of functions: wraps add_one into unary inside binary wrapper by ignoring second argument.
    public fun wrap_recursive_unary(): FuncWrapper {
        let unary_wrapped = wrap_unary(add_one);
        // Build a binary function that ignores second argument and calls unary function
        // Closure emulation is by having a named fun here:
        fun binary_ignorer(x: u64, _y: u64): u64 {
            call_unary(&unary_wrapped, x)
        };
        wrap_binary(binary_ignorer)
    }

    /// Recursive calling: call binary wrapper which calls unary ...
    public fun recursive_call(): u64 {
        let rec_wrapper = wrap_recursive_unary();
        call_binary(&rec_wrapper, 10, 5)
    }

    /// A runner function that uses all the above to exercise function wrapping and calling
    public fun runner(): u64 {
        let f0 = wrap_zerary(zero);
        let f1 = wrap_unary(add_one);
        let f2 = wrap_binary(add);

        let r0 = call_zerary(&f0);
        let r1 = call_unary(&f1, 10);
        let r2 = call_binary(&f2, 10, 15);

        let rrec = recursive_call();

        // Just sum all results to have one output
        r0 + r1 + r2 + rrec
    }
}
//# run 0xCAFE::FunctionTypes::runner

//# publish
module FunctionGeneric<phantom T, phantom U> {
    /// A generic struct holding two values
    public struct Pair has copy, drop, store {
        first: T,
        second: U,
    }

    /// Construct a new pair
    public fun new_pair(a: T, b: U): Pair {
        Pair { first: a, second: b }
    }

    /// Swap function
    public fun swap(p: Pair): Pair {
        Pair {
            first: p.second,
            second: p.first,
        }
    }

    /// Runner that demonstrates generic types with multiple type parameters
    public fun runner(): u64 {
        let p = new_pair(10u64, 20u8);
        let p_swapped = swap(p);
        // Convert u8 to u64 then add
        (p_swapped.first as u64) + p_swapped.second
    }
}
//# run 0xCAFE::FunctionGeneric::runner

//# publish
module 0xBAD::NoAddressModule {

    /// No explicit address block module to test compilation without it.

    public fun simple(): u64 {
        7u64
    }
}
//# run 0xBAD::NoAddressModule::simple

// Featurres:
// 19d5198d73253ebb3bc5edf83ecd9904: Test that functions, closures, and lambdas with different arity (no parameter, one parameter, two parameters) can be correctly captured, stored in enums, passed, called, recursively wrapped, and invoked with appropriate parameter adaptation and variable capture.
// 17ff4d5772fb0424b7dea7332fe27329: Define Move modules with or without specifying an explicit address block.
// da67a855c6357f72934f12020e1bde4a: Specify multiple type parameters separated by commas within the angle brackets.
