
//# publish
module 0xCAFE::InteractionTest {
    use std::vector;

    // Function to swap two u64 values and return a tuple
    public fun swap_u64(a: u64, b: u64): (u64, u64) {
        (b, a)
    }

    // Function with an explicit type parameter that swaps two values of type T
    public fun swap_generic<T>(x: T, y: T): (T, T) {
        (y, x)
    }

    // Runner function to test swap_u64
    public fun run_swap_u64_test(): (u64, u64) {
        let a = 10u64;
        let b = 20u64;
        let (swapped_b, swapped_a) = swap_u64(a, b);
        (swapped_b, swapped_a)
    }

    // Runner function to test swap_generic with u64
    public fun run_swap_generic_u64(): (u64, u64) {
        let a = 100u64;
        let b = 200u64;
        let (swapped_b, swapped_a) = swap_generic<u64>(a, b);
        (swapped_b, swapped_a)
    }
}


//# run 0xCAFE::InteractionTest::run_swap_u64_test


//# run 0xCAFE::InteractionTest::swap_generic::u64 --args 555u64 666u64


//# run 0xCAFE::InteractionTest::run_swap_generic_u64


// Featurres:
// f9da88c6c81c8d4842f9cfc49e241d70: Test swapping two u64 values and returning them as a tuple from a function.
// 82f755af6a64ca1b7520a8282c6064dc: Define scripts using the 'script' keyword in Move files.
// 88780a25fcdc495a06545d1cbd51852d: Define functions with explicitly specified type parameters and parameters.
