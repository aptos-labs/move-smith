//# publish
module 0xCAFE::SpecTest {
    use std::signer;

    struct Data has copy, drop, store {
        field: u8
    }

    /// Inline function with attached spec block and abort condition
    public inline fun inline_with_spec(x: u8): u8 {
        spec {
            ensures result > 0;
            aborts_if x == 0;
        }
        if (x == 0) {
            abort 100;
        };
        x + 1
    }

    /// Function that calls the inline function and has spec abort condition
    public fun call_inline(x: u8): u8 {
        spec {
            aborts_if x == 255;
            ensures result > x;
        }
        if (x == 255) {
            abort 101;
        };
        inline_with_spec(x)
    }

    /// Procedure with spec aborts_if and no return
    public fun proc_with_abort(x: u8) {
        spec {
            aborts_if x > 10;
        }
        if (x > 10) {
            abort 102;
        };
    }

    /// Public function to store data at signer
    public fun store_data(s: signer, val: u8) {
        let d = Data { field: val };
        move_to<Data>(&s, d);
    }

    /// View function to get data field from signer address; inline with spec block
    public inline fun view_data(addr: address): u8 acquires Data {
        spec {
            ensures result >= 0;
        }
        let d_ref = borrow_global<Data>(addr);
        d_ref.field
    }

    /// Runner function without parameters to call all above for testing
    public fun runner(s: signer) {
        let _ = call_inline(5u8);
        proc_with_abort(5u8);
        store_data(s, 7u8);
        let _ = view_data(signer::address_of(&s));
    }
} 

//# run 0xCAFE::SpecTest::inline_with_spec --args 1u8

//# run 0xCAFE::SpecTest::call_inline --args 2u8

//# run 0xCAFE::SpecTest::proc_with_abort --args 10u8

//# run 0xCAFE::SpecTest::store_data --signers 0xBEEF --args 20u8

//# run 0xCAFE::SpecTest::view_data --args 0x0000000000000000000000000000000000000BEEF

//# run 0xCAFE::SpecTest::runner --signers 0xBEEF

//# run 0xCAFE::SpecTest::call_inline --args 255u8

//# run 0xCAFE::SpecTest::proc_with_abort --args 11u8

// Immediate neighbors: 0xCAFE::MyModule
// Used addresses: 0xBEEF, 0xCAFE

// Featurres:
// f3a7035384ac791c9ac3118b6c3076ba: Attach specification blocks to functions during inlining to include behavior specifications in the generated inline functions.
// c1d1e13893b59b8cc7f8b47cbab7747c: Specify immediate neighbors and used addresses for modules and scripts for dependency analysis.
// afa5bd48459f694f37d4fcf57d0a95f9: Use 'aborts_if' specifications to specify custom abort conditions for a function or procedure.
