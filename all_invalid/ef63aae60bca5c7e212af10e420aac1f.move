//# publish
module 0xCAFE::UnpackTest {

    // A singleton struct with some fields
    struct Singleton has key, store {
        val: u64,
        flag: bool,
    }

    // A variant singleton struct that references Singleton
    struct Variant has key, store {
        s: Singleton,
        count: u8,
    }

    // A tuple struct referencing Singleton as well
    struct TupleStruct has key, store {
        0: Singleton,
        1: u64,
    }

    // A resource struct to test move semantics and aborts
    struct Resource has key, store, drop {
        data: u64,
    }

    // Initialize function to publish singleton structs to the global storage
    public fun init(account: &signer) {
        // Publish singleton
        move_to(account, Singleton { val: 42, flag: true });

        // Publish variant struct using singleton from storage
        let s_ref = borrow_global<Singleton>(signer::address_of(account));
        move_to(account, Variant { s: copy s_ref, count: 7 });

        // Publish tuple struct
        move_to(account, TupleStruct { 0: copy s_ref, 1: 100 });
    }

    // Runner function to test unpacking
    public fun runner() {
        let addr = @0xCAFE;

        // Field unpacking of singleton: assign val and flag from struct field access
        let Singleton {val, flag} = borrow_global<Singleton>(addr);
        // We can do some simple operations to check values
        let _sum = val + (flag as u64);

        // Positional unpacking from tuple struct
        let TupleStruct{0: s, 1: num} = borrow_global<TupleStruct>(addr);
        let Singleton {val: v2, flag: f2} = s;
        let _ = v2 + (f2 as u64) + num;

        // Positional unpacking with let binding in tuple (tuple unpacking)
        let (a, b) = (10u8, 20u8);
        let _ = a + b;

        // Field unpacking for Variant with nested struct reference
        let Variant { s: inner_s, count } = borrow_global<Variant>(addr);
        let Singleton { val: iv, flag: iflag } = inner_s;
        let _ = iv + (iflag as u64) + (count as u64);
    }

    // Helper: consume Resource, returns error code 1 if Resource does not exist
    public fun consume_resource(addr: address): u64 acquires Resource {
        if (!exists<Resource>(addr)) {
            // Abort with error code 1
            abort 1;
        }
        let r = move_from<Resource>(addr);
        r.data
    }

    // Abort function to test proper abort behavior
    public fun test_abort() {
        abort 100;
    }

    // Runner to test abort and resource handling with error propagation using nested abort
    public fun abort_runner() {
        let addr = @0xCAFE;
        // The following line will abort with code 1 if no Resource exists in addr
        // To test error propagation, call abort and let caller catch it (in real tests)
        consume_resource(addr);

        // This will unconditionally abort with code 100
        // Uncomment to test abort propagation
        //test_abort();
    }

    // Create and publish Resource for testing
    public fun create_resource(account: &signer) {
        move_to(account, Resource { data: 999 });
    }
}
//# run 0xCAFE::UnpackTest::init --signers 0xCAFE
//# run 0xCAFE::UnpackTest::runner
//# run 0xCAFE::UnpackTest::create_resource --signers 0xCAFE
//# run 0xCAFE::UnpackTest::consume_resource --signers 0xCAFE --args 0xCAFE
//# run 0xCAFE::UnpackTest::test_abort

// Featurres:
// a4efd0cdd372451e51b13a4e7f5fb58b: Use field and positional unpacking in assignment or binding patterns for structs and tuples.
// db95778a40105e12d9c4ae2d62300372: Test handling of arithmetic errors, resource moves, and aborts in Move functions, including error propagation and resource existence checks.
// 246ec723997b3888a4b7d3ed0c806dc9: Add fields to singleton or variant structs with types that can reference other types
