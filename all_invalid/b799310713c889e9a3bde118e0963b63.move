// This transactional test covers:
// 1. Attach specifications (spec blocks) to scripts for formal verification or documentation
// 2. Functions with multiple type arguments and proper compiler expansion
// 3. Variable shadowing inside closures passed to inline functions, testing correct shadowing and assignment

// Address: 0xCAFE

//# publish
module 0xCAFE::MultiTypeFuncs {
    use std::vector;

    /// A generic struct to test type expansion
    struct Pair<T1, T2> has copy, drop, store {
        first: T1,
        second: T2,
    }

    /// A function with multiple type parameters which returns a Pair of their references
    public fun make_pair_ref<T1, T2>(
        x: &T1,
        y: &T2
    ): Pair<&T1, &T2> {
        Pair { first: x, second: y }
    }

    /// A function with multiple type parameters which returns a Pair of the values doubled (assume numeric)
    public fun double_pair<T: copy + store>(
        x: T,
        y: T
    ): Pair<T, T> {
        // Let's assume T is u64 here for the test, so we can multiply by 2
        // The cast _as_ u64 must be avoided; so we in test we will use u64 specifically
        // But here keep generic and just return the same values, testing type expansion
        Pair { first: x, second: y }
    }

    /// A public inline function that takes a closure and an outer variable which is shadowed inside closure
    public inline fun call_with_shadowing<F: copy + store>(
        x: &mut u64,
        mut f: impl FnMut(&mut u64)
    ) {
        f(x);
    }

    /// A "runner" function that demonstrates variable shadowing semantics via call_with_shadowing
    /// It will shadow variable `a` inside the closure, assign to outer `a` and return final value of `a`
    public fun runner(): u64 {
        let mut a = 5u64;
        call_with_shadowing(&mut a, 
            fun (a: &mut u64) {
                let a_inner = 10u64; // shadowing (different variable name to verify no confusion)
                *a = a_inner; // assign outer a to 10
                // no return in closure
            }
        );
        a
    }
}
//# run 0xCAFE::MultiTypeFuncs::runner

//# run
script {
    use 0xCAFE::MultiTypeFuncs;

    // Attached specification block to script
    spec {
        // Just document intended behavior for verification tooling
        fun script_spec() {
            // Spec content can describe runner() returns 10
            assert(MultiTypeFuncs::runner() == 10, 0);
        }
    }

    fun main() {
        // Test function with multiple type args: make_pair_ref
        let x = 42u64;
        let y = 24u8;
        let pair_ref = MultiTypeFuncs::make_pair_ref(&x, &y);

        // Access elements via references (we do not assert, but rely on VM for errors)
        let a = *pair_ref.first;
        let b = *pair_ref.second;

        // Test double_pair with u64 explicitly
        let doubled_pair = MultiTypeFuncs::double_pair(3u64, 4u64);

        // Test runner for shadowing functionality
        let result = MultiTypeFuncs::runner();

        // No assertion as per instruction, but just keep variables to show usage
        let _ = (a, b, doubled_pair.first, doubled_pair.second, result);
    }
}

// Featurres:
// 4560a8e8558fc0bbc98bddd7f60a3cf6: Attach specifications (spec blocks) to scripts for formal verification or documentation
// d870a0000b48e35cc77bca89dc41a92a: Write functions that take multiple type arguments and have them properly expanded in the compiler
// 292a0ea61739d634ef720b93929410ea: Test that variable shadowing works correctly in closures passed to inline functions, ensuring the closure can assign to the outer variable when names are shadowed.
