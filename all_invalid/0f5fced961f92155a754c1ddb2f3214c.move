
//# publish
module 0xCAFE::TestCaps {
    // Test module for ability constraints and type parameters
    use std::signer;

    struct CapCopy has copy, drop, store {
        val: u8
    }

    struct CapStore has store {
        val: u16
    }

    struct CapKey has key {
        val: u32
    }

    struct CapDrop has drop {
        val: u64
    }

    // Generic struct with all 4 abilities required
    struct AllCaps<T: copy + drop + store + key> has key {
        inner: T
    }

    // Generic struct with only copy and drop required
    struct CopyDropOnly<T: copy + drop> {
        inner: T
    }

    // Generic struct with only store required
    struct StoreOnly<T: store> has store {
        inner: T
    }

    // Function requiring type parameter with copy ability
    public fun require_copy<T: copy>(val: T): T {
        val
    }

    // Function requiring type parameter with drop ability
    public fun require_drop<T: drop>(val: T): T {
        val
    }

    // Function requiring type parameter with store ability
    public fun require_store<T: store>(val: T): T {
        val
    }

    // Function requiring type parameter with key ability
    public fun require_key<T: key>(account: &signer, val: T) {
        move_to<T>(account, val)
    }

    // Runner function to instantiate structs and call functions
    public fun runner(account: &signer) {
        // Instantiate CapCopy
        let c = CapCopy { val: 10 };

        // Instantiate CapStore
        let s = CapStore { val: 20 };

        // Instantiate CapKey and move to signer
        let k = CapKey { val: 30 };
        move_to<CapKey>(account, k);

        // Instantiate CapDrop
        let d = CapDrop { val: 40 };

        // Instantiate AllCaps with CapKey (which has all required abilities)
        // Actually CapKey only has key, but our AllCaps requires copy + drop + store + key
        // So this will error; so instantiate AllCaps with a struct with all abilities

        // Define a local struct with all abilities inline
        struct AllAbilities has copy, drop, store, key {
            v: u8
        }

        // Must be declared at module top-level - move declaration out of function
    }
}

// Because Move does not allow inline struct declarations within functions,
// Move AllAbilities struct outside:

struct AllAbilities has copy, drop, store, key {
    v: u8
}

// Continue module with functions using AllAbilities

// Below module will cause errors because only one module per file
// So put all in 0xCAFE::TestCaps module:

// We rewrite the module with the new struct properly included:


//# publish
module 0xCAFE::TestCaps {
    use std::signer;

    struct CapCopy has copy, drop, store {
        val: u8
    }

    struct CapStore has store {
        val: u16
    }

    struct CapKey has key {
        val: u32
    }

    struct CapDrop has drop {
        val: u64
    }

    struct AllAbilities has copy, drop, store, key {
        v: u8
    }

    struct AllCaps<T: copy + drop + store + key> has key {
        inner: T
    }

    struct CopyDropOnly<T: copy + drop> {
        inner: T
    }

    struct StoreOnly<T: store> has store {
        inner: T
    }

    public fun require_copy<T: copy>(val: T): T {
        val
    }

    public fun require_drop<T: drop>(val: T): T {
        val
    }

    public fun require_store<T: store>(val: T): T {
        val
    }

    public fun require_key<T: key>(account: &signer, val: T) {
        move_to<T>(account, val)
    }

    public fun runner(account: &signer) {
        let c = CapCopy { val: 10 };
        let s = CapStore { val: 20 };
        let k = CapKey { val: 30 };
        move_to<CapKey>(account, k);
        let d = CapDrop { val: 40 };
        let a = AllAbilities { v: 50 };

        // Instantiate AllCaps with AllAbilities
        let all = AllCaps<AllAbilities> { inner: a };

        // Instantiate CopyDropOnly with CapCopy
        let cd = CopyDropOnly<CapCopy> { inner: c };

        // Instantiate StoreOnly with CapStore
        let so = StoreOnly<CapStore> { inner: s };

        // Call require functions
        let _ = require_copy(c);
        let _ = require_drop(d);
        let _ = require_store(s);
        require_key(account, all);
    }
}


//# run 0xCAFE::TestCaps::runner --signers 0xBEEF


// Featurres:
// dbc94bb18575b7ab61689e75eac66ec5: Process package definitions to include modules and address mappings.
// 064d9fdd5f44111051f10668210602d5: Display diagnostics with color-only if environment variable is set to 'NONE'.
// 1f1e15d73a91ef2d9e16f4165568f8a3: Include ability constraints in type parameter declarations to enforce capabilities.
