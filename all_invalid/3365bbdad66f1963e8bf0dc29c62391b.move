
//# publish
module 0xCAFE::Recursive {
    /// Mutually recursive inline and non-inline functions to test recursive calls.
    public fun odd(x: u8): bool {
        if (x == 0) {
            false
        } else {
            even(x - 1)
        };
    }

    public inline fun even(x: u8): bool {
        if (x == 0) {
            true
        } else {
            odd(x - 1)
        };
    }

    /// Returns mutable reference to the first element of the vector `v`
    public fun get_vmut(v: &mut vector<u8>): &mut u8 {
        vector::borrow_mut(v, 0)
    }

    /// Tests that mutable reference returned from a function is released correctly.
    public fun test_mut_ref_release(v: &mut vector<u8>) {
        let r: &mut u8 = get_vmut(v);
        *r = 10;
        // After this scope, `r` must be released to allow use of `v` again.
        // So we can safely use `v` now without conflicting borrows.
        let len = vector::length(v);
        assert!(len > 0, 777);
    }

    /// Declares unused local variable to trigger compiler warning
    public fun unused_local_vars() {
        let unused1 = 1u8;
        let unused2 = 2u64;
        // Intentionally unused variables for warning test.
    }

    /// Runner function to test odd(5) and even(4) return true
    public fun runner(): bool {
        let o = odd(5);
        let e = even(4);
        o && e
    }
}


//# run 0xCAFE::Recursive::runner


//# run 0xCAFE::Recursive::test_mut_ref_release --args vector[1u8, 2u8, 3u8]


// Featurres:
// 0495da1927e15e372326c91e8a707cd1: Test that mutually recursive inline and non-inline functions work correctly by verifying that `odd(5)` and `even(4)` return true.
// 38612f10955896ecb2bcb0fa7a142101: Test that a mutable reference returned from a function (`get_vmut`) is properly released at the end of its scope, allowing safe subsequent use of the original mutable reference (`r`) within the same function.
// 4cf1b5b548abbd8a56f796d3111f541a: Declare local variables in functions and have the compiler warn you if they are unused
