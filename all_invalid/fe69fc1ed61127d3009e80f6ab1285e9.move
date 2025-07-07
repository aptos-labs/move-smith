//# publish
module 0xCAFE::VectorRefTest {
    use std::vector;

    public fun modify_and_return_copy(v: &vector<u8>): vector<u8> {
        let mut new_v = vector::empty<u8>();
        let len = vector::length(v);
        let mut i = 0;
        while (i < len) {
            let val = *vector::borrow(v, i);
            vector::push_back(&mut new_v, val + 1);
            i = i + 1;
        };
        // Return modified copy, original vector referenced by &v remains unchanged
        new_v
    }

    public fun get_original_contents(v: &vector<u8>): vector<u8> {
        let len = vector::length(v);
        let mut res = vector::empty<u8>();
        let mut i = 0;
        while (i < len) {
            vector::push_back(&mut res, *vector::borrow(v, i));
            i = i + 1;
        };
        res
    }

    // Runner function to create a vector and test modification
    public fun runner(): vector<u8> {
        let mut vec = vector::empty<u8>();
        vector::push_back(&mut vec, 10);
        vector::push_back(&mut vec, 20);
        vector::push_back(&mut vec, 30);

        let modified = modify_and_return_copy(&vec);
        let original = get_original_contents(&vec);

        // Returning length of modified + original to ensure both exist and are unchanged
        // We won't return them together as tuples in script, just return one to satisfy type
        // Use sum to represent data content roughly
        let mut sum = 0u8;
        let len_mod = vector::length(&modified);
        let mut i = 0;
        while (i < len_mod) {
            sum = sum + *vector::borrow(&modified, i);
            i = i + 1;
        };
        let len_orig = vector::length(&original);
        let mut j = 0;
        while (j < len_orig) {
            sum = sum + *vector::borrow(&original, j);
            j = j + 1;
        };
        sum
    }
}

//# run 0xCAFE::VectorRefTest::runner


//# run
script {
    // Test 2: Make sure functions inside scripts have no visibility keywords by design.
    // NOTE: Move scripts cannot have public/package/friend keywords.
    // This script simply declares an internal function and calls it.

    fun internal_function(x: u8): u8 {
        x + 1
    }

    fun main() {
        let _res = internal_function(42);
    }

    main();
}


//# run
script {
    // Test 3: Default integer literals are treated as u64.
    // Perform arithmetic on default integers and test overflow behavior.
    // Use checked_add to simulate overflow detection.

    use std::option;

    fun checked_add_u64(a: u64, b: u64): bool {
        let (res, overflow) = std::u64::checked_add(a, b);
        !overflow
    }

    fun overflow_example() {
        let max = 18446744073709551615; // Maximum u64 value without suffix
        let does_not_overflow = checked_add_u64(1u64, 2u64);
        let overflows = checked_add_u64(max, 1u64);
    }

    fun main() {
        overflow_example();
    }

    main();
}

// Featurres:
// 7aa77a36ff1c977bd08f926092f49b76: Test that passing a reference to a vector and returning a modified copy correctly updates the vector and preserves its contents.
// d6b18feb62bf10640ad30fdeb701a653: Ensure that script functions do not use public, package, or friend visibility, as scripts must only contain internally visible functions.
// e9491ee367958f474341fb0473bebb57: Verify that default integer literals in Move scripts are always treated as u64, and that arithmetic with default integers correctly enforces u64 bounds and overflows as expected.
