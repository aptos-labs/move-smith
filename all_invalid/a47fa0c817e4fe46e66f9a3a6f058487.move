//:------------------------ Transactional Test Case ----------------------

//# publish
module 0xCAFE::TestModule {
    // Struct with copy & drop, test for abilities.
    struct CopyableStruct has copy, drop { x: u64, y: u8 }

    // Struct with all abilities.
    struct StorableStruct has key, store, drop { z: u8 }

    // Simple function to test number tokens and returns a value.
    public fun add_explicit(a: u8, b: u8): u8 {
        a + b
    }

    // Function that uses variable declared without initialization,
    // and assigns value in if-else.
    public fun assign_if_else(cond: bool): u16 {
        let result: u16;
        if (cond) {
            result = 42u16;
        } else {
            result = 99u16;
        };
        result
    }

    // Function to test storing and borrowing from global storage.
    public fun store_stuff(signer: &signer) {
        let s = StorableStruct { z: 77u8 };
        move_to<StorableStruct>(signer, s);
    }

    public fun use_borrowed(addr: address): u8 {
        let ref_ = borrow_global<StorableStruct>(addr);
        ref_.z
    }

    // Function to test tuple, copy, and return types
    public fun tuple_copy_add(): u64 {
        let t = (1u64, 2u8);
        let (x, y) = t;
        let s = CopyableStruct { x, y };
        s.x + (s.y as u64)
    }

    // Runner to call as entry point (tests multiple features).
    public fun runner(s: &signer): u8 {
        // store to global
        store_stuff(s);
        // borrow kills
        let z = use_borrowed(signer::address_of(s));
        // test add_explicit and assign_if_else
        let sum = add_explicit(3u8, 4u8);
        let cond_result = assign_if_else(true);
        // test tuple_copy_add
        let tup = tuple_copy_add();
        // Combine results to force all be used
        (z + sum + (cond_result as u8) + (tup as u8))
    }
}
//# run 0xCAFE::TestModule::runner --signers 0xCAFE

//# run 0xCAFE::TestModule::add_explicit --args 10u8 22u8
//# run 0xCAFE::TestModule::assign_if_else --args false
//# run 0xCAFE::TestModule::tuple_copy_add

//# publish
script {
    use 0xCAFE::TestModule;

    fun main() {
        let a: u64;
        let b = 5u8;
        if (b == 5u8) {
            a = 100u64;
        } else {
            a = 200u64;
        };
        let res = TestModule::add_explicit(b, 2u8);
        let r = TestModule::assign_if_else(false);
        let sum = a + (res as u64) + (r as u64);
        let _: u64 = sum;
        // Just exercises variable assignment and use
    }
}
//# run

// Features:
// d87b1cc431ca16982c2db6318f032318: Ensure that the module you reference is already declared to avoid unbound module errors.
// a50a8976c9e992036ebd7cdb036ed54c: Test that variables declared without an initial value can be assigned within an if-else statement and used afterward.
// 8140aa6eb185a657e6bd8e76221fded7: Use typed number tokens to specify numeric values with explicit types.
