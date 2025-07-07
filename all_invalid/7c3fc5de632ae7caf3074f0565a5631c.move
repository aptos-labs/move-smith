// This transactional test case demonstrates the following aspects:
// 1. Consistent sorted diagnostics via clearly separated modules, scripts, and functions located at different addresses/lines.
// 2. Generic type parameters for both structs and functions.
// 3. Aggregation of comments and definitions from multiple files via separate modules in a transactional test.

// ----------------------------------------------------
//# publish
module 0xCAFE::GenericStore {
    /// A generic container MyBox<T> with a value inside.
    struct MyBox<T: copy + drop + store> has copy, drop, store {
        value: T,
    }
    /// Store<T> as a key/resource in global storage
    struct Store<T: copy + drop + store + key> has key {
        box: MyBox<T>,
    }

    /// Creates a new MyBox<T>
    public fun new_box<T: copy + drop + store>(x: T): MyBox<T> {
        MyBox { value: x }
    }

    /// Gets the inner value out of the MyBox. Copies.
    public fun unbox<T: copy + drop + store>(b: &MyBox<T>): T {
        copy b.value
    }

    /// Stores a Store<T> under a signer address
    public fun save_value<T: copy + drop + store + key>(account: &signer, v: T) {
        let b = new_box<T>(v);
        let r = Store<T> { box: b };
        move_to<Store<T>>(account, r);
    }

    /// Extracts and returns the inner value from Store<T>
    public fun extract<T: copy + drop + store + key>(addr: address): T {
        let b = borrow_global<Store<T>>(addr);
        unbox<T>(&b.box)
    }

    /// Runner for u64
    public fun generic_runner_u64(account: &signer, n: u64): u64 {
        save_value<u64>(account, n);
        extract<u64>(signer::address_of(account))
    }
    /// Runner for bool
    public fun generic_runner_bool(account: &signer, b: bool): bool {
        save_value<bool>(account, b);
        extract<bool>(signer::address_of(account))
    }
}

//# run 0xCAFE::GenericStore::generic_runner_u64 --signers 0xBEEF --args 4242u64
//# run 0xCAFE::GenericStore::generic_runner_bool --signers 0xFACA --args true

//----------------------------------------------
//# publish
module 0xCAB0::Diagnostics {
    /// This module attempts to generate Move errors at different lines and approaches
    struct D has copy, drop {}
    public fun div_by_zero(): u8 {
        1u8 / 0u8 // Division by zero: should see diagnostics on this line.
    }
    public fun tuple_unpack_error() {
        let (a, b) = 1u8; // Unpack error: not enough values. Should trigger diagnostic after above.
    }
    public fun shift_error(x: u8): u8 {
        x >> 9u8 // 8-bit can only shift by <= 8
    }
    /// Runner to hit errors (uncomment lines to trigger specific diagnostics)
    public fun runner() {
        //div_by_zero();
        //tuple_unpack_error();
        //shift_error(3u8);
    }
}

//# run 0xCAB0::Diagnostics::runner

//----------------------------------------------
//# publish
module 0xCBBB::CrossFileComments {
    /// This struct and function will be combined with the rest in the aggregated AST.
    struct S has copy, drop {}

    /// Another comment for cross-file aggregation.
    public fun hello(): u8 { 42 }
}
//# run 0xCBBB::CrossFileComments::hello

//----------------------------------------------
//# run
script {
    use 0xCAFE::GenericStore;
    use 0xCBBB::CrossFileComments;

    fun main(account: &signer) {
        // Check that GenericStore works with u64 and bool
        let x = GenericStore::generic_runner_u64(account, 99);
        let y = GenericStore::generic_runner_bool(account, false);
        let _ = (x, y);

        // Call hello from another module, demonstrates aggregate definitions
        let z = CrossFileComments::hello();
        let _ = z;
        // Uncomment to check error aggregation:
        // 0xCAB0::Diagnostics::div_by_zero();
    }
}

// Featurres:
// 2d60c29ba5de06ed22e8beb91d9094bd: See diagnostics in a consistent, sorted order based on source location to aid in debugging
// 01b4f574d69d308443d5edb67f5ee6d1: Declare generic type parameters for structs and functions
// 12c8256ad07a90199b4f857924e03b64: Aggregate source definitions and comments from multiple Move source files into a unified program structure.
