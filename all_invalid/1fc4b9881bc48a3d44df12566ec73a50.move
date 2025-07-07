// Test transactional script file for Move compiler and VM features

// Test 1: Check for Move module magic number in a binary resource.
// We'll create a module that stores a vector<u8> as a resource (simulating a binary file),
// then have a "runner" function that checks if the vector's bytes start with [0xA1, 0xAC, 0x28, 0x62]

//# publish
module 0x1::MagicChecker {
    use std::vector;
    use std::signer;

    // Store a binary blob for the account
    struct BinaryFile has key {
        bytes: vector<u8>,
    }

    /// Publish BinaryFile resource with contents from input vector<u8>
    public fun publish_binary(account: &signer, data: vector<u8>) {
        move_to(account, BinaryFile { bytes: data });
    }

    /// Check for the Move module magic number 0xA1, 0xAC, 0x28, 0x62 at the start of the vector
    public fun check_magic(addr: address): bool acquires BinaryFile {
        let bin = borrow_global<BinaryFile>(addr);
        let magic = vector::length(&bin.bytes) >= 4 &&
            *vector::borrow(&bin.bytes, 0) == 0xA1u8 &&
            *vector::borrow(&bin.bytes, 1) == 0xACu8 &&
            *vector::borrow(&bin.bytes, 2) == 0x28u8 &&
            *vector::borrow(&bin.bytes, 3) == 0x62u8;
        magic
    }

    /// Runner that checks the magic number for the runner's own account and does nothing
    /// Just calls check_magic; in a real test we'd assert the result.
    public fun runner(account: &signer) {
        ignore check_magic(signer::address_of(account));
    }
}

// Publish the module and a sample binary blob with/without magic number,
// then exercise the runner function
//# run 0x1::MagicChecker::publish_binary --signers 0xA550C18 --args [0xA1u8,0xACu8,0x28u8,0x62u8,0xDEu8,0xADu8]
//# run 0x1::MagicChecker::runner --signers 0xA550C18

// Test 2 and 3: Nested dot notation and 'public'
// Chain of nested structs and access
//# publish
module 0x2::DotsTest {
    // Outer struct "A"
    public struct A has copy, drop, store {
        inner: B,
    }

    // Nested struct "B"
    struct B has copy, drop, store {
        value: u64,
    }

    /// Create an A { B { value: 123 } }
    public fun make_a(): A {
        A { inner: B { value: 123 } }
    }

    /// Fetch the nested value using full dot notation
    public fun get_b_value(a: &A): u64 {
        a.inner.value
    }

    /// Runner: create A and fetch value
    public fun runner(): u64 {
        let a = make_a();
        get_b_value(&a)
    }
}

//# run 0x2::DotsTest::runner