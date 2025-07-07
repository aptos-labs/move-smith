//# publish
module 0xCAFE::AbilityTest {
    // Ability test struct: only has copy and drop
    struct OnlyCopyDrop has copy, drop {
        x: u64,
    }

    // Ability test struct: only has store, key, and drop
    struct OnlyStoreKeyDrop has store, key, drop {
        x: u64,
    }

    // Ability test struct: has all abilities
    struct AllAbilities has copy, drop, store, key {
        x: u64,
    }

    // Will test copy
    public fun test_copy() {
        let a = OnlyCopyDrop { x: 42 };
        let b = copy a;
        // Drop both a and b -- copy/drop abilities hold
        let OnlyCopyDrop { x: y1 } = a;
        let OnlyCopyDrop { x: y2 } = b;
        // Just to consume y1, y2
        let _ = y1 + y2;
    }

    // Will test drop: unused
    public fun test_drop() {
        let _unused = OnlyCopyDrop { x: 123 };
        // Allowed because OnlyCopyDrop has drop
    }

    // Will test move only (no copy ability)
    public fun test_move_only() {
        let a = OnlyStoreKeyDrop { x: 5 };
        // let b = copy a; // Uncommenting this causes compiler error: no copy ability
        let OnlyStoreKeyDrop { x: b } = a;
        let _ = b;
    }

    // Will test all abilities
    public fun test_all_abilities() {
        let a = AllAbilities { x: 77 };
        let b = copy a;
        // Now also test drop
        let AllAbilities { x: v1 } = a;
        let AllAbilities { x: v2 } = b;
        let _ = v1 + v2;
    }

    // Test that move from global works only with key/store
    public fun setup_global(addr: address) {
        move_to(&addr, OnlyStoreKeyDrop { x: 99 });
    }
    public fun cleanup_global(addr: address): u64 {
        let OnlyStoreKeyDrop { x } = move_from<OnlyStoreKeyDrop>(addr);
        x
    }

    public fun runner(addr: address) {
        test_copy();
        test_drop();
        test_move_only();
        test_all_abilities();
        setup_global(addr);
        let _ = cleanup_global(addr);
    }
}
//# run 0xCAFE::AbilityTest::runner --signers 0xCAFE --args 0xCAFE

//# publish
module 0xCAFE::SumMultiples {
    // Returns the sum of all numbers below 'limit' that are multiples of 3 or 5
    public fun sum_3_or_5(limit: u64): u64 {
        let mut acc = 0u64;
        let mut i = 0u64;
        while (i < limit) {
            if (i % 3 == 0 || i % 5 == 0) {
                acc = acc + i;
            };
            i = i + 1;
        };
        acc
    }

    // A "runner" so we can transactionally test
    public fun runner() {
        // For limit=10, should be 3+5+6+9=23 (0,3,5,6,9)
        let result = sum_3_or_5(10);
        let _ = result;
        // No assertion; but whoever runs can see result
    }
}
//# run 0xCAFE::SumMultiples::runner --signers 0xBEEF

//# run
script {
    fun main() {
        // This script tests the use of 'no' as unreachable code
        let x = 5;
        if (x == 10) {
            // This branch is definitely not reachable
            no;
        }
    }
}

// Featurres:
// 8342a5161de0c9cb2d493b1ee5f4bf40: Run ability checks to ensure proper use of copy, move, and drop operations based on type abilities.
// 7ec96e2fbe9c752e7f502761ab591b1d: Test that the function correctly calculates the sum of all numbers below a given limit that are multiples of 3 or 5.
// 0f969730f1ad33e58b8fdc7180c14a97: Use 'no' as an indication that a code segment is definitely not reachable.
