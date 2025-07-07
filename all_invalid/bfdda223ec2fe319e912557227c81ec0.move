//# publish
module 0xCAFE::DecreasesExample {
    use std::vector;

    /// A function that recursively sums up numbers from n down to 0.
    /// The decreases clause decreases in n to prove termination.
    public fun recursive_sum(n: u64): u64
        decreases n
    {
        if (n == 0) {
            0
        } else {
            n + recursive_sum(n - 1)
        }
    }

    /// A function using a generic vector parameter and an index,
    /// demonstrates expression with type argument for vector.
    public fun get_first_element<T: copy>(v: vector<T>): T
    {
        // using vector::borrow with type argument explicitly
        *vector::borrow<T>(&v, 0)
    }

    /// Runner function to trigger recursive_sum in test, no arguments needed.
    public fun runner(): u64
    {
        recursive_sum(10)
    }
}
//# run 0xCAFE::DecreasesExample::runner


//# publish
module 0xCAFE::MultiParamClosure {
    /// Defines a function type alias for closure taking two u64 and returning u64
    /// Move currently does not have a function type system, so we simulate closures by functions.

    /// A function that takes a two-parameter "closure" (function pointer) and two u64's,
    /// returns the result of the closure called with the two arguments.
    public fun apply_closure(
        f: &fun(u64, u64): u64,
        x: u64,
        y: u64
    ): u64
    {
        (*f)(x, y)
    }

    /// A simple function that can act as a closure: sum two u64 values.
    public fun sum_fn(x: u64, y: u64): u64 {
        x + y
    }

    /// Runner function that applies the sum_fn on (7, 11).
    public fun runner(): u64 {
        apply_closure(&sum_fn, 7, 11)
    }
}
//# run 0xCAFE::MultiParamClosure::runner


//# publish
script 0xCAFE::TestClosureAndTypeArgsScript {
    use 0xCAFE::MultiParamClosure;
    use 0xCAFE::DecreasesExample;
    use std::vector;

    fun sum_two_numbers_closure(x: u64, y: u64): u64 {
        x + y
    }

    fun test_type_arg_vector() {
        let mut v = vector::empty<u8>();
        vector::push_back<u8>(&mut v, 42);
        let first = DecreasesExample::get_first_element<u8>(v); // expression with type argument
        drop(first)
    }

    fun test_closure_application() {
        let s = MultiParamClosure::apply_closure(&sum_two_numbers_closure, 100, 200);
        // no assert required
        drop(s);
    }

    fun test_recursive_sum() {
        let sum = DecreasesExample::recursive_sum(5);
        drop(sum);
    }

    fun main(_signer: signer) {
        test_type_arg_vector();
        test_closure_application();
        test_recursive_sum();
    }
}
//# run 0xCAFE::TestClosureAndTypeArgsScript